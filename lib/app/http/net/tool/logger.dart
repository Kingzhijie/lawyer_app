import 'package:flutter/foundation.dart';

/// 通过修改此配置来控制日志输出，便于调试
final Map<LogUtil, bool> _globalLogIsShow = {
  LogUtil.def: !kReleaseMode,
  LogUtil.http: false,
  LogUtil.httpDetail: !kReleaseMode,
};

enum LogUtil {
  def, // 通用
  http, // 网络请求完整链接
  httpDetail, // 网络请求（详细数据）
}

String _split =
    '\n═════════════════════════════════════════════════════════════════════';

extension LogExtension on LogUtil {
  /// 是否打开
  bool get isShowLog => _globalLogIsShow[this] == true;

  void print(String? message) {
    if (isShowLog) {
      debugPrint('${toString()}：${message ?? 'null'}');
    }
  }

  void success(String? message) {
    if (isShowLog) {
      debugPrint('${toString()}✅：${message ?? 'null'}$_split');
    }
  }

  void error(String? message) {
    if (isShowLog) {
      debugPrint('${toString()}❌：${message ?? 'null'}$_split');
    }
  }
}

/// 打印默认日志
void logPrint(String message) {
  if (LogUtil.def.isShowLog) {
    debugPrint(message);
  }
}
