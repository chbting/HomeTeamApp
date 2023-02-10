import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static const remodelingCache = 'remodeling_scheduler';

  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename() for optimization
      return await sourceFile.rename(newPath);
    } on FileSystemException {
      // if rename() fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  static Future<File> moveToCache(
      {required File file, String? child, String? newFileName}) async {
    var cacheDir = await getCacheDirectory(child: child);
    var newPath = '${cacheDir.path}${Platform.pathSeparator}'
        '${newFileName ?? basename(file.path)}';
    return moveFile(file, newPath);
  }

  /// If [child] is not null, clears the specific folder within the cache
  /// directory
  static Future<FileSystemEntity> clearCache({String? child}) async {
    var cacheDir = await getCacheDirectory(child: child);
    return cacheDir.delete(recursive: true);
  }

  /// If [child] is not null, returns path of the specific folder in the cache
  /// directory
  static Future<Directory> getCacheDirectory({String? child}) async {
    var appCacheDir = await getTemporaryDirectory();
    var path = appCacheDir.path;
    child != null ? path += Platform.pathSeparator + child : null;
    return Directory(path).create();
  }

  /// If [child] is not null, returns list of files within the specific folder
  /// in the cache directory
  static Future<List<File>> getCacheFiles({String? child}) async {
    var cacheDir = await getCacheDirectory(child: child);
    var fileEntityList = cacheDir.listSync();
    var fileList = <File>[];
    for (var entity in fileEntityList) {
      if (entity is File) {
        fileList.add(entity);
      }
    }
    return fileList;
  }
}
