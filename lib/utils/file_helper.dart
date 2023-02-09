import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename for optimization
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
    var schedulerCacheDir = await getSchedulerCacheDirectory();
    return schedulerCacheDir.delete(recursive: true);
  }

  static Future<Directory> getSchedulerCacheDirectory() async {
    var appCacheDir = await getTemporaryDirectory();
    var path = '${appCacheDir.path}${Platform.pathSeparator}scheduler';
    return Directory(path).create();
  }

  static Future<List<File>> getSchedulerCacheFiles() async {
    var schedulerCacheDir = await getSchedulerCacheDirectory();
    var fileEntityList = schedulerCacheDir.listSync();
    var fileList = <File>[];
    for (var entity in fileEntityList) {
      if (entity is File) {
        fileList.add(entity);
      }
    }
    return fileList;
  }
}
