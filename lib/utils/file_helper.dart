import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  static Future<File> moveToSchedulerCache(File file) async {
    var cacheDir = await getSchedulerCacheDirectory();
    var newPath =
        '${cacheDir.path}${Platform.pathSeparator}${basename(file.path)}';
    return moveFile(file, newPath);
  }

  static Future<FileSystemEntity> clearSchedulerCache() async {
    var cacheDir = await getSchedulerCacheDirectory();
    return cacheDir.delete(recursive: true);
  }

  static Future<Directory> getSchedulerCacheDirectory() async {
    var appCacheDir = await getTemporaryDirectory();
    var path = '${appCacheDir.path}${Platform.pathSeparator}scheduler';
    return Directory(path).create();
  }
}
