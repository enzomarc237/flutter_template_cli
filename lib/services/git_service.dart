import 'dart:io';
// import 'package:git/git.dart';
import 'package:path/path.dart' as path;

class GitService {
  Future<bool> cloneRepository(String repoUrl, String targetPath, {String branch = 'main'}) async {
    try {
      // await GitDir.init(targetPath);

      final result = await Process.run('git', [
        'clone',
        '-b',
        branch,
        repoUrl,
        targetPath,
      ]);

      if (result.exitCode != 0) {
        throw Exception('Failed to clone repository: ${result.stderr}');
      }

      // Clean up .git folder
      await Directory(path.join(targetPath, '.git')).delete(recursive: true);

      return true;
    } catch (e) {
      print('Error cloning repository: $e');
      return false;
    }
  }
}
