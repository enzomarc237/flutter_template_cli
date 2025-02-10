import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
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
    final logger = Logger();
    final name = argResults?['name'];
    
    if (name == null) {
      logger.err('Please provide the template name to remove');
      return;
    }

    final templateManager = TemplateManager();
    final template = templateManager.getTemplate(name);
    
    if (template == null) {
      logger.err('Template "$name" not found');
      return;
    }

    templateManager.removeTemplate(name);
    logger.success('Template "$name" removed successfully!');
  }
} 