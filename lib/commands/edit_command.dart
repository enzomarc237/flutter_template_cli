import 'package:args/command_runner.dart';
import '../models/template.dart';
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
      ..addMultiOption('commands', 
          abbr: 'c', 
          help: 'New post-create commands (can be specified multiple times)');
  }

  @override
  void run() {
    final name = argResults?['name'];
    if (name == null) {
      print('Please provide the template name to edit');
      return;
    }

    final manager = TemplateManager();
    final existing = manager.getTemplate(name);
    if (existing == null) {
      print('Template "$name" not found');
      return;
    }

    final newTemplate = Template(
      name: name,
      repoUrl: argResults?['repo'] ?? existing.repoUrl,
      postCreateCommands: argResults?['commands'] as List<String>? ?? 
          existing.postCreateCommands,
    );

    manager.updateTemplate(name, newTemplate);
    print('Template "$name" updated successfully!');
  }
} 