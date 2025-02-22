 import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_parse/pubspec_parse.dart';
import '../models/template.dart';
import '../services/git_service.dart';

class TemplateManager {
  final File _storageFile;
  final Directory _cacheDir;
  List<Template> _templates = [];

  TemplateManager()
      : _storageFile = File(path.join(
          Platform.environment['HOME'] ?? '',
          '.flutter_template_cli',
          'templates.json',
        )),
        _cacheDir = Directory(path.join(
          Platform.environment['HOME'] ?? '',
          '.flutter_template_cli',
          'cache',
        )) {
    _initStorage();
  }

  void _initStorage() {
    if (!_storageFile.existsSync()) {
      _storageFile.createSync(recursive: true);
      _storageFile.writeAsStringSync('[]');
    }
    _loadTemplates();
  }

  void _loadTemplates() {
    final content = _storageFile.readAsStringSync();
    final List<dynamic> jsonList = json.decode(content);
    _templates = jsonList.map((json) => Template.fromJson(json)).toList();
  }

  void _saveTemplates() {
    final jsonList = _templates.map((t) => t.toJson()).toList();
    _storageFile.writeAsStringSync(json.encode(jsonList));
  }

  List<Template> listTemplates() => _templates;
  get cacheDir => _cacheDir;

  void addTemplate(Template template) {
    _templates.add(template);
    _saveTemplates();
  }

  void removeTemplate(String name) {
    _templates.removeWhere((t) => t.name == name);
    _saveTemplates();
  }

  Template? getTemplate(String name) {
    return _templates.firstWhereOrNull((t) => t.name == name);
  }

  void updateTemplate(String name, Template newTemplate) {
    final index = _templates.indexWhere((t) => t.name == name);
    if (index != -1) {
      _templates[index] = newTemplate;
      _saveTemplates();
    }
  }

  Future<void> cacheTemplate(Template template) async {
    final cacheFolder = path.join(_cacheDir.path, template.name);
    final gitService = GitService();

    if (await gitService.cloneRepository(template.repoUrl, cacheFolder, branch: template.branch)) {
      final updatedTemplate = template.copyWith(cached: true, lastUsed: DateTime.now());
      updateTemplate(template.name, updatedTemplate);
    }
  }

  Future<void> updateCache(String templateName) async {
    final template = getTemplate(templateName);
    if (template == null) return;

    final cacheFolder = path.join(_cacheDir.path, template.name);
    if (Directory(cacheFolder).existsSync()) {
      try {
        final result = await Process.run('git', ['pull'], workingDirectory: cacheFolder);
        if (result.exitCode != 0) {
          // If git pull fails, re-cache the template
          await cacheTemplate(template);
        }
      } catch (e) {
        await cacheTemplate(template); // Re-cache if git pull fails
      }
    } else {
      await cacheTemplate(template);
    }
  }

  Future<bool> validateTemplate(String repoUrl, String branch) async {
    try {
      final tempDir = await Directory.systemTemp.createTemp('template_validation');
      final gitService = GitService();

      if (!await gitService.cloneRepository(repoUrl, tempDir.path, branch: branch)) {
        return false;
      }

      // Check for pubspec.yaml
      final pubspecFile = File(path.join(tempDir.path, 'pubspec.yaml'));
      if (!pubspecFile.existsSync()) {
        return false;
      }

      // Validate pubspec.yaml
      try {
        final pubspecContent = pubspecFile.readAsStringSync();
        Pubspec.parse(pubspecContent);
      } catch (e) {
        return false;
      }

      await tempDir.delete(recursive: true);
      return true;
    } catch (e) {
      print('Error validating template: $e');
      return false;
    }
  }
}
