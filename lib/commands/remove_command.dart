import 'package:args/command_runner.dart';
import '../services/template_manager.dart';

class RemoveCommand extends Command {
  @override
  String get name => 'remove';

  @override
  String get description => 'Remove a template';

  RemoveCommand() {
    argParser.addOption('name', abbr: 'n', help: 'Template name to remove');
  }

  @override
  void run() {
    final name = argResults?['name'];
    
    if (name == null) {
      print('Please provide the template name to remove');
      return;
    }

    TemplateManager().removeTemplate(name);
    print('Template "$name" removed successfully!');
  }
} 