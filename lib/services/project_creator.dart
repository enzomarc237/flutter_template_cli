import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;
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

    // Apply template variables
    final allVariables = {
      ...template.variables,
      ...variables,
      'project_name': path.basename(projectPath),
    };

    await _processTemplateFiles(projectPath, allVariables);

    // Execute post-create commands
    _logger.info('Running post-create commands...');
    for (final command in template.postCreateCommands) {
      try {
        final expandedCommand = _expandVariables(command, allVariables);
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
      if (entity is File) {
        await entity.copy('${destDir.path}/${entity.uri.pathSegments.last}');
      } else if (entity is Directory) {
        await copyPath(entity.path, '${destDir.path}/${entity.uri.pathSegments.last}');
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
}
