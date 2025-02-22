import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as path;

class GitService {
  final Logger _logger = Logger();

  Future<bool> cloneRepository(String repoUrl, String targetPath, {String branch = 'main'}) async {
    try {
      _logger.info('Cloning repository $repoUrl...');

      // Ensure target directory exists
      final targetDir = Directory(targetPath);
      if (!targetDir.existsSync()) {
        await targetDir.create(recursive: true);
      }

      final result = await Process.run('git', [
        'clone',
        '--depth',
        '1',
        '-b',
        branch,
        repoUrl,
        targetPath,
      ]);

      if (result.exitCode != 0) {
        _logger.err('Failed to clone repository: ${result.stderr}');
        return false;
      }

      // Clean up .git folder
      final gitDir = Directory(path.join(targetPath, '.git'));
      if (await gitDir.exists()) {
        await gitDir.delete(recursive: true);
      }

      _logger.success('Repository cloned successfully');
      return true;
    } catch (e) {
      _logger.err('Error cloning repository: $e');
      return false;
    }
  }

  Future<bool> validateRepository(String repoUrl, {String branch = 'main'}) async {
    try {
      final tempDir = await Directory.systemTemp.createTemp('git_validation');
      final result = await Process.run('git', [
        'ls-remote',
        '--heads',
        repoUrl,
        'refs/heads/$branch'
      ]);

      await tempDir.delete(recursive: true);
      return result.exitCode == 0 && result.stdout.toString().isNotEmpty;
    } catch (e) {
      _logger.err('Error validating repository: $e');
      return false;
    }
  }
}
