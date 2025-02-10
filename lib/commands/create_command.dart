import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
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
      ..addOption('name', abbr: 'n', help: 'Project name')
      ..addMultiOption('var', 
          abbr: 'v', 
          help: 'Template variables (format: key=value)')
      ..addFlag('update-cache', 
          help: 'Update template cache before creating project');
  }

  @override
  Future<void> run() async {
    final templateName = argResults?['template'];
    final projectName = argResults?['name'];
    final updateCache = argResults?['update-cache'] ?? false;

    if (templateName == null || projectName == null) {
      print('Please provide both template name and project name');
      return;
    }

    // Parse variables
    final variables = <String, String>{};
    for (final var_ in argResults?['var'] ?? []) {
      final parts = var_.split('=');
      if (parts.length == 2) {
        variables[parts[0]] = parts[1];
      }
    }

    final logger = Logger();
    final templateManager = TemplateManager();
    
    if (updateCache) {
      logger.info('Updating template cache...');
      await templateManager.updateCache(templateName);
    }

    final creator = ProjectCreator(GitService(), templateManager, logger);
    await creator.createProject(templateName, projectName, variables);
  }
} 