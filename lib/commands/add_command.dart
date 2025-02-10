import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../models/template.dart';
import '../services/template_manager.dart';

class AddCommand extends Command {
  @override
  String get name => 'add';

  @override
  String get description => 'Add a new template';

  AddCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'Template name')
      ..addOption('repo', abbr: 'r', help: 'Repository URL')
      ..addOption('branch', abbr: 'b', defaultsTo: 'main', help: 'Repository branch')
      ..addOption('description', abbr: 'd', help: 'Template description')
      ..addMultiOption('command', abbr: 'c', help: 'Post-create commands')
      ..addMultiOption('var', help: 'Template variables (format: key=value)')
      ..addFlag('cache', help: 'Cache template after adding', defaultsTo: true);
  }

  @override
  Future<void> run() async {
    final logger = Logger();
    final name = argResults?['name'];
    final repoUrl = argResults?['repo'];
    final branch = argResults?['branch'];
    final description = argResults?['description'];
    final commands = argResults?['command'] as List<String>? ?? [];
    final cache = argResults?['cache'] ?? true;

    if (name == null || repoUrl == null) {
      logger.err('Please provide template name and repository URL');
      return;
    }

    final variables = <String, String>{};
    for (final var_ in argResults?['var'] ?? []) {
      final parts = var_.split('=');
      if (parts.length == 2) {
        variables[parts[0]] = parts[1];
      }
    }

    final templateManager = TemplateManager();

    logger.info('Validating template...');
    if (!await templateManager.validateTemplate(repoUrl, branch)) {
      logger.err('Invalid template repository');
      return;
    }

    final template = Template(
      name: name,
      repoUrl: repoUrl,
      branch: branch,
      description: description,
      postCreateCommands: commands,
      variables: variables,
    );

    templateManager.addTemplate(template);
    logger.success('Template added successfully!');

    if (cache) {
      logger.info('Caching template...');
      await templateManager.cacheTemplate(template);
      logger.success('Template cached successfully!');
    }
  }
} 