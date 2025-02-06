import 'dart:io';
import 'git_service.dart';
import 'template_manager.dart';

class ProjectCreator {
  final GitService _gitService;
  final TemplateManager _templateManager;

  ProjectCreator(this._gitService, this._templateManager);

  Future<bool> createProject(String templateName, String projectPath) async {
    final template = _templateManager.getTemplate(templateName);
    if (template == null) {
      print('Template not found: $templateName');
      return false;
    }

    final success = await _gitService.cloneRepository(template.repoUrl, projectPath);
    if (!success) return false;

    for (final command in template.postCreateCommands) {
      try {
        final parts = command.split(' ');
        final result = await Process.run(parts.first, parts.skip(1).toList(),
            workingDirectory: projectPath);
        if (result.exitCode != 0) {
          print('Command failed: $command');
          print(result.stderr);
          return false;
        }
      } catch (e) {
        print('Error executing command: $command');
        print(e);
        return false;
      }
    }

    return true;
  }
} 