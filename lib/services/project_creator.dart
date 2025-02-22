import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';
import 'git_service.dart';
import 'template_manager.dart';

class ProjectCreator {
  final GitService _gitService;
  final TemplateManager _templateManager;
  final Logger _logger;

  ProjectCreator(this._gitService, this._templateManager, this._logger);

  Future<bool> createProject(String templateName, String projectPath, Map<String, String> variables) async {
    final template = _templateManager.getTemplate(templateName);
    if (template == null) {
      _logger.err('Template not found: $templateName');
      return false;
    }

    _logger.info('Creating project from template: ${template.name}');

    // Use cached template if available
    String sourceDir = path.join(_templateManager.cacheDir.path, template.name);
    if (!template.cached || !Directory(sourceDir).existsSync()) {
      _logger.info('Downloading template...');
      final success = await _gitService.cloneRepository(
        template.repoUrl,
        projectPath,
        branch: template.branch,
      );
      if (!success) return false;
      sourceDir = projectPath;
    } else {
      _logger.info('Using cached template...');
      await copyPath(sourceDir, projectPath);
    }

    // Get the original project name from pubspec.yaml
    final pubspecFile = File(path.join(projectPath, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      _logger.err('pubspec.yaml not found in template');
      return false;
    }

    final pubspecContent = await pubspecFile.readAsString();
    final pubspecYaml = loadYaml(pubspecContent);
    final originalProjectName = pubspecYaml['name'] as String;

    // Replace project name in files
    _logger.info('Updating project files with new name...');
    await _updateProjectFiles(projectPath, originalProjectName, path.basename(projectPath));

    // Execute post-create commands
    _logger.info('Running post-create commands...');
    for (final command in template.postCreateCommands) {
      try {
        final expandedCommand = _expandVariables(command, variables);
        final parts = expandedCommand.split(' ');

        _logger.info('Executing: $expandedCommand');
        final result = await Process.run(
          parts.first,
          parts.skip(1).toList(),
          workingDirectory: projectPath,
        );

        if (result.exitCode != 0) {
          _logger.err('Command failed: $expandedCommand');
          _logger.err(result.stderr);
          return false;
        }
      } catch (e) {
        _logger.err('Error executing command: $command');
        _logger.err(e.toString());
        return false;
      }
    }

    _logger.success('Project created successfully! 🎉');
    return true;
  }


  Future<void> copyPath(String source, String destination) async {
    final sourceDir = Directory(source);
    final destDir = Directory(destination);

    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }

    await for (final entity in sourceDir.list(recursive: false)) {
      final name = path.basename(entity.path);
      if (name.startsWith('.')) {
        continue; // Skip hidden files and directories
      }
      if (entity is File) {
        await entity.copy('${destDir.path}/${name}');
      } else if (entity is Directory) {
        await copyPath(entity.path, '${destDir.path}/${name}');
      }
    }
  }

  String _expandVariables(String input, Map<String, String> variables) {
    String result = input;
    variables.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value);
    });
    return result;
  }

  Future<void> _processTemplateFiles(String projectPath, Map<String, String> variables) async {
    final dir = Directory(projectPath);
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        // Skip binary files
        if (_isBinaryFile(entity.path)) continue;

        try {
          final content = await entity.readAsString();
          final processedContent = _expandVariables(content, variables);
          await entity.writeAsString(processedContent);
        } catch (e) {
          // Log error but continue processing other files
          _logger.warn('Failed to process file: ${entity.path}');
        }
      }
    }
  }

  bool _isBinaryFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return [
      'png', 'jpg', 'jpeg', 'gif', 'ico', 'svg', 'bmp', 'tiff', 'webp', 'raw', 'heic', // Images
      'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'pages', 'numbers', 'key', // Documents
      'zip', 'rar', 'tar', 'gz', '7z', 'bz2', 'xz', 'iso', 'dmg', // Archives
      'ttf', 'otf', 'woff', 'woff2', 'eot', 'pfm', 'pfb', // Fonts
      'mp3', 'mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv', 'wav', 'ogg', 'm4a', 'aac', 'webm', // Media
      'db', 'sqlite', 'sqlite3', 'mdb', 'frm', 'myd', 'myi', // Databases
      'so', 'dll', 'dylib', 'a', 'lib', 'ko', // Libraries
      'xcassets', 'xcworkspace', 'xcodeproj', 'pbxproj', 'framework', // Xcode files
      'jar', 'class', 'war', 'ear', 'dex', 'apk', 'aab', // Java/Android binaries
      'exe', 'bin', 'app', 'dmg', 'pkg', 'deb', 'rpm', 'msi', 'appx', // Executables and Installers
      'psd', 'ai', 'eps', 'sketch', 'fig', 'xd', // Design files
      'pyc', 'pyo', 'pyd', // Python bytecode
      'o', 'obj', 'lib', 'pdb', 'ilk', 'exp', // Object and debug files
      'swf', 'fla', // Flash files
      'wasm', // WebAssembly
      'tflite', 'mlmodel', // Machine Learning models
    ].contains(extension);
  }

  Future<void> _updateProjectFiles(String projectPath, String originalName, String newName) async {
    final files = await _findFilesToUpdate(projectPath);

    for (final file in files) {
      _logger.info('Updating ${path.basename(file.path)}...');

      if (file.path.endsWith('.yaml')) {
        await _updateYamlFile(file, originalName, newName);
      } else {
        await _updateTextFile(file, originalName, newName);
      }
    }
  }

  Future<List<File>> _findFilesToUpdate(String projectPath) async {
    final files = <File>[];

    await for (final entity in Directory(projectPath).list(recursive: true)) {
      if (entity is File) {
        final filename = path.basename(entity.path).toLowerCase();

        // Add files that commonly contain project name references
        if ([
              'pubspec.yaml',
              'package_config.json',
              'android/app/build.gradle',
              'android/app/src/main/AndroidManifest.xml',
              'ios/Runner.xcodeproj/project.pbxproj',
              'ios/Runner/Info.plist',
              'macos/Runner/Configs/AppInfo.xcconfig',
              'windows/runner/main.cpp',
              'linux/CMakeLists.txt',
              'web/index.html',
              'web/manifest.json',
              'README.md',
            ].contains(entity.path.substring(projectPath.length + 1)) ||
            filename.endsWith('.dart')) {
          files.add(entity);
        }
      }
    }

    return files;
  }

  Future<void> _updateYamlFile(File file, String originalName, String newName) async {
    try {
      final content = await file.readAsString();
      final yamlEditor = YamlEditor(content);

      if (file.path.endsWith('pubspec.yaml')) {
        yamlEditor.update(['name'], newName);

        // Update description if it contains the project name
        final currentDescription = yamlEditor.parseAt(['description'], orElse: () => loadYamlNode("")) as String;
        if (currentDescription.contains(originalName)) {
          yamlEditor.update(
            ['description'],
            currentDescription.replaceAll(originalName, newName),
          );
        }
      }

      await file.writeAsString(yamlEditor.toString());
    } catch (e) {
      _logger.warn('Error updating YAML file ${file.path}: $e');
    }
  }

  Future<void> _updateTextFile(File file, String originalName, String newName) async {
    try {
      final content = await file.readAsString();

      // Create regex patterns for different name formats
      final patterns = [
        RegExp(originalName, caseSensitive: true),
        RegExp(_toSnakeCase(originalName), caseSensitive: true),
        RegExp(_toCamelCase(originalName), caseSensitive: true),
        RegExp(_toPascalCase(originalName), caseSensitive: true),
        RegExp(_toKebabCase(originalName), caseSensitive: true),
      ];

      var newContent = content;
      for (final pattern in patterns) {
        newContent = newContent.replaceAll(
          pattern,
          _matchCase(pattern.pattern, newName),
        ); // Use replaceAllMapped to preserve case
      }

      await file.writeAsString(newContent);
    } catch (e) {
      _logger.warn('Error updating file ${file.path}: $e');
    }
  }

  String _matchCase(String original, String newText) {
    if (original.contains('_')) {
      return _toSnakeCase(newText);
    } else if (original[0].toLowerCase() == original[0]) {
      return _toCamelCase(newText);
    } else if (original[0].toUpperCase() == original[0]) {
      return _toPascalCase(newText);
    } else if (original.contains('-')) {
      return _toKebabCase(newText);
    }
    return newText;
  }

  String _toSnakeCase(String text) => text.replaceAll('-', '_').replaceAll(' ', '_').toLowerCase();

  String _toCamelCase(String text) {
    final words = text.split(RegExp(r'[_\- ]'));
    return words[0].toLowerCase() + words.skip(1).map((word) => word.capitalize()).join();
  }

  String _toPascalCase(String text) {
    final words = text.split(RegExp(r'[_\- ]'));
    return words.map((word) => word.capitalize()).join();
  }

  String _toKebabCase(String text) => text.replaceAll('_', '-').replaceAll(' ', '-').toLowerCase();
}

// Add this extension method
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
