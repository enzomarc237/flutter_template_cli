import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';
import '../services/template_manager.dart';

class ListCommand extends Command {
  @override
  String get name => 'list';

  @override
  String get description => 'List all available templates';

  @override
  void run() {
    final logger = Logger();
    final templates = TemplateManager().listTemplates();
    
    if (templates.isEmpty) {
      logger.warn('No templates available.');
      return;
    }

    logger.info('Available templates:');
    for (final template in templates) {
      logger.info('\n${template.name}:');
      if (template.description != null) {
        logger.info('  Description: ${template.description}');
      }
      logger.info('  Repository: ${template.repoUrl}');
      logger.info('  Branch: ${template.branch}');
      
      if (template.variables.isNotEmpty) {
        logger.info('  Variables:');
        for (final entry in template.variables.entries) {
          logger.info('    - ${entry.key}: ${entry.value}');
        }
      }
      
      if (template.postCreateCommands.isNotEmpty) {
        logger.info('  Post-create commands:');
        for (final cmd in template.postCreateCommands) {
          logger.info('    - $cmd');
        }
      }

      if (template.cached) {
        logger.info('  Cached: Yes${template.lastUsed != null ? ' (Last used: ${template.lastUsed})' : ''}');
      }
    }
  }
} 