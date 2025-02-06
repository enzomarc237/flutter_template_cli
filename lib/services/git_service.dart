import 'dart:io';

class GitService {
  Future<bool> cloneRepository(String repoUrl, String targetPath) async {
    try {
      final result = await Process.run('git', ['clone', repoUrl, targetPath]);
      if (result.exitCode != 0) {
        throw Exception('Failed to clone repository: ${result.stderr}');
      }
      return true;
    } catch (e) {
      print('Error cloning repository: $e');
      return false;
    }
  }
} 