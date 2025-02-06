import 'package:args/command_runner.dart';
import '../services/template_manager.dart';

class ListCommand extends Command {
  @override
  String get name => 'list';

  @override
  String get description => 'List all available templates';

  @override
  void run() {
    final templates = TemplateManager().listTemplates();
    
    if (templates.isEmpty) {
      print('No templates available.');
      return;
    }

    print('Available templates:');
    for (final template in templates) {
      print('\n${template.name}:');
      print('  Repository: ${template.repoUrl}');
      if (template.postCreateCommands.isNotEmpty) {
        print('  Post-create commands:');
        for (final cmd in template.postCreateCommands) {
          print('    - $cmd');
        }
      }
    }
  }
} 