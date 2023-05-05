import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static const propertyUploaderCache = 'propertyUploader';

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
      {required File file, String? subDirectory, String? newFileName}) async {
    var cacheDir = await getCacheDirectory(subDirectory: subDirectory);
    var filename = newFileName ?? basename(file.path);
    var newPath = '${cacheDir.path}${Platform.pathSeparator}$filename';
    return moveFile(file, newPath);
  }

  /// If [child] is not null, clears only the specific folder within the cache
  /// directory
  static Future<FileSystemEntity> clearCache({String? child}) async {
    var cacheDir = await getCacheDirectory(subDirectory: child);
    return cacheDir.delete(recursive: true);
  }

  /// If [subDirectory] is not null, returns path of the specific folder in the
  /// cache directory
  static Future<Directory> getCacheDirectory({String? subDirectory}) async {
    var appCacheDir = await getTemporaryDirectory();
    var path = appCacheDir.path;
    subDirectory != null ? path += Platform.pathSeparator + subDirectory : null;
    return Directory(path).create();
  }

  /// If [subDirectory] is not null, returns list of files within the specific
  /// folder in the cache directory
  static Future<List<File>> getCacheFiles(
      {String? subDirectory, bool recursive = false}) async {
    var cacheDir = await getCacheDirectory(subDirectory: subDirectory);
    var fileEntityList = cacheDir.listSync(recursive: recursive);
    var fileList = <File>[];
    for (var entity in fileEntityList) {
      if (entity is File) {
        fileList.add(entity);
      }
    }
    return fileList;
  }

  /// Returns all contents in the directory, including [Directory] objects
  static Future<List<FileSystemEntity>> dirContents(Directory dir,
      {bool recursive = true}) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: recursive);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }
}
