import 'dart:io';
import 'package:dio/dio.dart';
import 'package:native_file_preview/native_file_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

/// 文件预览工具类
/// 支持本地文件和网络文件预览
/// 支持格式：.doc, .docx, .wps, .ppt, .pptx, .xls, .xlsx, .md, .txt, .pdf
class FilePreviewUtil {
  FilePreviewUtil._();

  /// 支持的文件格式
  static const List<String> supportedFormats = [
    'doc',
    'docx',
    'wps',
    'ppt',
    'pptx',
    'xls',
    'xlsx',
    'md',
    'txt',
    'pdf',
    'json',
  ];

  /// 预览文件
  /// 
  /// [filePath] 文件路径，可以是本地路径或网络 URL
  /// [fileName] 文件名（可选），用于网络文件下载时的命名
  /// [showLoading] 是否显示加载提示，默认 true
  /// [useCache] 是否使用缓存，默认 true。如果为 false，每次都会重新下载
  /// 
  /// 返回 true 表示预览成功，false 表示失败
  static Future<bool> previewFile({
    required String filePath,
    String? fileName,
    bool showLoading = true,
    bool useCache = true,
  }) async {
    try {
      // 判断是本地文件还是网络文件
      final isNetworkFile = filePath.startsWith('http://') || 
                           filePath.startsWith('https://');

      String localPath;

      if (isNetworkFile) {
        // 网络文件，需要先下载
        if (showLoading) {
          showToast('正在下载文件...');
        }
        
        localPath = await _downloadFile(filePath, fileName, useCache: useCache);
        
        if (showLoading) {
          showToast('下载完成，正在打开...');
        }
      } else {
        // 本地文件，直接使用
        localPath = filePath;
        
        // 检查文件是否存在
        final file = File(localPath);
        if (!await file.exists()) {
          showToast('文件不存在');
          return false;
        }
      }

      // 检查文件格式是否支持
      final extension = _getFileExtension(localPath);
      if (!_isSupportedFormat(extension)) {
        showToast('不支持的文件格式: .$extension');
        return false;
      }

      // 使用 native_file_preview 预览文件
      await NativeFilePreview().previewFile(localPath);
      
      return true;
    } catch (e) {
      logPrint('文件预览失败: $e');
      showToast('文件预览失败');
      return false;
    }
  }

  /// 下载网络文件到本地
  /// 
  /// [url] 文件 URL
  /// [fileName] 文件名（可选）
  /// [useCache] 是否使用缓存，默认 true
  /// 
  /// 返回本地文件路径
  static Future<String> _downloadFile(
    String url, 
    String? fileName, {
    bool useCache = true,
  }) async {
    try {
      // 获取临时目录
      final tempDir = await getTemporaryDirectory();
      
      // 生成文件名
      final name = fileName ?? _getFileNameFromUrl(url);
      final savePath = '${tempDir.path}/$name';

      // 检查缓存
      final file = File(savePath);
      if (useCache && await file.exists()) {
        logPrint('使用缓存文件: $savePath');
        return savePath;
      }

      // 如果不使用缓存或文件不存在，删除旧文件
      if (await file.exists()) {
        await file.delete();
      }

      // 下载文件
      logPrint('开始下载文件: $url');
      final dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            logPrint('下载进度: $progress%');
          }
        },
      );

      logPrint('文件下载成功: $savePath');
      return savePath;
    } catch (e) {
      logPrint('文件下载失败: $e');
      throw Exception('文件下载失败: $e');
    }
  }

  /// 从 URL 中提取文件名
  static String _getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        return segments.last;
      }
    } catch (e) {
      logPrint('解析 URL 失败: $e');
    }
    
    // 如果无法解析，生成一个默认文件名
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'file_$timestamp';
  }

  /// 获取文件扩展名
  static String _getFileExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1) return '';
    return filePath.substring(lastDot + 1).toLowerCase();
  }

  /// 检查文件格式是否支持
  static bool _isSupportedFormat(String extension) {
    return supportedFormats.contains(extension.toLowerCase());
  }

  /// 检查文件是否可以预览
  /// 
  /// [filePath] 文件路径或 URL
  /// 
  /// 返回 true 表示支持预览
  static bool canPreview(String filePath) {
    final extension = _getFileExtension(filePath);
    return _isSupportedFormat(extension);
  }

  /// 获取文件格式的友好名称
  static String getFormatName(String filePath) {
    final extension = _getFileExtension(filePath);
    switch (extension) {
      case 'doc':
      case 'docx':
        return 'Word 文档';
      case 'wps':
        return 'WPS 文档';
      case 'ppt':
      case 'pptx':
        return 'PowerPoint 演示文稿';
      case 'xls':
      case 'xlsx':
        return 'Excel 表格';
      case 'pdf':
        return 'PDF 文档';
      case 'txt':
        return '文本文件';
      case 'md':
        return 'Markdown 文档';
      default:
        return '未知格式';
    }
  }

  /// 清除所有缓存文件
  /// 
  /// 返回清除的文件数量
  static Future<int> clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      int count = 0;

      for (var file in files) {
        if (file is File) {
          final extension = _getFileExtension(file.path);
          if (_isSupportedFormat(extension)) {
            await file.delete();
            count++;
          }
        }
      }

      logPrint('清除缓存文件: $count 个');
      return count;
    } catch (e) {
      logPrint('清除缓存失败: $e');
      return 0;
    }
  }

  /// 获取缓存文件大小（字节）
  static Future<int> getCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      int totalSize = 0;

      for (var file in files) {
        if (file is File) {
          final extension = _getFileExtension(file.path);
          if (_isSupportedFormat(extension)) {
            totalSize += await file.length();
          }
        }
      }

      return totalSize;
    } catch (e) {
      logPrint('获取缓存大小失败: $e');
      return 0;
    }
  }

  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}
