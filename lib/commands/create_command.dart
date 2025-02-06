import 'package:args/command_runner.dart';
import '../services/git_service.dart';
import '../services/template_manager.dart';
import '../services/project_creator.dart';

class CreateCommand extends Command {
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project from template';

  CreateCommand() {
    argParser
      ..addOption('template', abbr: 't', help: 'Template name to use')
      ..addOption('name', abbr: 'n', help: 'Project name');
  }

  @override
  Future<void> run() async {
    final templateName = argResults?['template'];
    final projectName = argResults?['name'];

    if (templateName == null || projectName == null) {
      print('Please provide both template name and project name');
      return;
    }

    final creator = ProjectCreator(GitService(), TemplateManager());
    final success = await creator.createProject(templateName, projectName);

    if (success) {
      print('Project created successfully!');
    } else {
      print('Failed to create project');
    }
  }
} 