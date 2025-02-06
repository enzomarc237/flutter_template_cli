import 'package:args/command_runner.dart';
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
      ..addMultiOption('commands', 
          abbr: 'c', 
          help: 'Post-create commands (can be specified multiple times)');
  }

  @override
  void run() {
    final name = argResults?['name'];
    final repoUrl = argResults?['repo'];
    final commands = argResults?['commands'] as List<String>? ?? [];

    if (name == null || repoUrl == null) {
      print('Please provide both template name and repository URL');
      return;
    }

    final template = Template(
      name: name,
      repoUrl: repoUrl,
      postCreateCommands: commands,
    );

    TemplateManager().addTemplate(template);
    print('Template "$name" added successfully!');
  }
} 