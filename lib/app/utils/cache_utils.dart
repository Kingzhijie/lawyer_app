import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../http/net/tool/logger.dart';

class CacheUtils {

  /// 获取缓存大小
  static Future<String> total() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir == null) {
      return '';
    }
    int total = await _reduce(tempDir);
    return renderSize(total);
  }

  //格式化文件大小
  static String renderSize(value) {
    if (value == null) {
      return '';
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return value == 0 ? '' : size + unitArr[index];
  }

  /// 清除缓存
  static Future<void> clear() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir == null) return;
    await _delete(tempDir);
    deleteOldFiles();
  }

  /// 递归缓存目录，计算缓存大小
  static Future<int> _reduce(final FileSystemEntity file) async {
    /// 如果是一个文件，则直接返回文件大小
    if (file is File) {
      int length = await file.length();
      return length;
    }

    /// 如果是目录，则遍历目录并累计大小
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();

      int total = 0;

      if (children.isNotEmpty)
        for (final FileSystemEntity child in children)
          total += await _reduce(child);
      return total;
    }

    return 0;
  }

  /// 递归删除缓存目录和文件
  static Future<void> _delete(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await _delete(child);
      }
    } else {
      await file.delete();
    }
  }


  ///清除Documents 文件下,  超过30天的文件, 比如发送失败的图片
  static Future<void> deleteOldFiles({int daysToKeep = 30}) async {
    final files = await getFilesWithTimestamps();
    final now = DateTime.now();
    for (final file in files) {
      final stat = await file.stat();
      final lastModified = stat.modified;
      final age = now.difference(lastModified).inDays;
      if (age > daysToKeep) {
        await file.delete();
        logPrint('已删除旧文件: ${file.path} (${age}天前)');
      }
    }
  }

  static Future<List<FileSystemEntity>> getFilesWithTimestamps() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final files = await appDocDir.list().toList();
    return files.where((file) => file is File).toList();
  }

}
