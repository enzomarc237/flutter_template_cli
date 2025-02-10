import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../services/template_manager.dart';

class EditCommand extends Command {
  @override
  String get name => 'edit';

  @override
  String get description => 'Edit an existing template';

  EditCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'Template name to edit')
      ..addOption('repo', abbr: 'r', help: 'New repository URL')
      ..addOption('branch', abbr: 'b', help: 'New repository branch')
      ..addOption('description', abbr: 'd', help: 'New description')
      ..addMultiOption('command', abbr: 'c', help: 'New post-create commands')
      ..addMultiOption('var', help: 'New template variables (format: key=value)')
      ..addFlag('cache', help: 'Cache template after editing');
  }

  @override
  Future<void> run() async {
    final logger = Logger();
    final name = argResults?['name'];
    if (name == null) {
      logger.err('Please provide the template name to edit');
      return;
    }

    final manager = TemplateManager();
    final existing = manager.getTemplate(name);
    if (existing == null) {
      logger.err('Template "$name" not found');
      return;
    }

    final variables = {...existing.variables};
    for (final var_ in argResults?['var'] ?? []) {
      final parts = var_.split('=');
      if (parts.length == 2) {
        variables[parts[0]] = parts[1];
      }
    }

    final newTemplate = existing.copyWith(
      repoUrl: argResults?['repo'] ?? existing.repoUrl,
      branch: argResults?['branch'] ?? existing.branch,
      description: argResults?['description'] ?? existing.description,
      postCreateCommands: argResults?['command'] as List<String>? ?? 
          existing.postCreateCommands,
      variables: variables,
      cached: false,
      lastUsed: null,
    );

    manager.updateTemplate(name, newTemplate);
    logger.success('Template "$name" updated successfully!');

    if (argResults?['cache'] ?? false) {
      logger.info('Caching template...');
      await manager.cacheTemplate(newTemplate);
      logger.success('Template cached successfully!');
    }
  }
} 