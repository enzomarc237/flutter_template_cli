import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/template.dart';

class TemplateManager {
  final File _storageFile;
  List<Template> _templates = [];

  TemplateManager() : _storageFile = File(path.join(
          Platform.environment['HOME'] ?? '',
          '.flutter_template_cli',
          'templates.json',
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

  void addTemplate(Template template) {
    _templates.add(template);
    _saveTemplates();
  }

  void removeTemplate(String name) {
    _templates.removeWhere((t) => t.name == name);
    _saveTemplates();
  }

  Template? getTemplate(String name) {
    return _templates.firstWhere((t) => t.name == name);
  }

  void updateTemplate(String name, Template newTemplate) {
    final index = _templates.indexWhere((t) => t.name == name);
    if (index != -1) {
      _templates[index] = newTemplate;
      _saveTemplates();
    }
  }
} 