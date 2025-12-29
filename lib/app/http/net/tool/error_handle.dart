import 'dart:io';
import 'package:dio/dio.dart';
import 'logger.dart';

class NetCodeHandle {
  ///请求成功
  static const int success = 200;
  /// 未授权, 未登录
  static const int unauthorized = 403;
  static const int success_not_content = 204;
  static const int not_modified = 304;
  static const int forbidden = 401;
  static const int not_found = 404;

  static const int net_error = 1000;
  static const int parse_error = 1001;
  static const int socket_error = 1002;
  static const int http_error = 1003;
  static const int connect_timeout_error = 1004;
  static const int send_timeout_error = 1005;
  static const int receive_timeout_error = 1006;
  static const int cancel_error = 1007;
  static const int unknown_error = 9999;

  static final Map<int, NetError> _errorMap = <int, NetError>{
    net_error: NetError(net_error, '网络异常，请检查你的网络！'),
    parse_error: NetError(parse_error, '数据解析错误！'),
    socket_error: NetError(socket_error, '网络异常，请检查你的网络！'),
    http_error: NetError(http_error, '服务器异常，请稍后重试！'),
    connect_timeout_error: NetError(connect_timeout_error, '连接超时！'),
    send_timeout_error: NetError(send_timeout_error, '请求超时！'),
    receive_timeout_error: NetError(receive_timeout_error, '响应超时！'),
    cancel_error: NetError(cancel_error, '取消请求'),
    unknown_error: NetError(unknown_error, '未知异常'),
    unauthorized: NetError(unauthorized, '鉴权失败')
  };

  static NetError handleException(dynamic error) {
    logPrint('error=====$error');
    if (error is DioException) {
      if (error.response?.data != null) {
        logPrint('error=111====$error');
        if (error.response!.data!.toString().startsWith('<html>')) {
          return NetError(502, 'Bad Gateway');
        }
        return NetError(9999, error.response?.data.toString() ?? '');
      } else if (error.type.errorCode == 0) {
        logPrint('error==222===$error');
        return _handleException(error.error);
      } else {
        logPrint('error==333===$error');
        if (_errorMap.keys.contains(error.type.errorCode)) {
          return _errorMap[error.type.errorCode]!;
        }
        return NetError(http_error, '服务器异常，请稍后重试！');
      }
    } else {
      logPrint('error==444===$error');
      return _handleException(error);
    }
  }

  static NetError _handleException(dynamic error) {
    int errorCode = unknown_error;
    if (error is SocketException) {
      errorCode = socket_error;
    }
    if (error is HttpException) {
      errorCode = http_error;
    }
    if (error is FormatException) {
      errorCode = parse_error;
    }

    if (_errorMap.keys.contains(errorCode)) {
      return _errorMap[errorCode]!;
    }
    return NetError(http_error, '服务器异常，请稍后重试！');
  }
}

class NetError {
  NetError(this.code, this.msg);
  int code;
  String msg;
}

extension DioErrorTypeExtension on DioExceptionType {
  int get errorCode => [
        NetCodeHandle.connect_timeout_error,
        NetCodeHandle.send_timeout_error,
        NetCodeHandle.receive_timeout_error,
        0,
        0,
        NetCodeHandle.cancel_error,
        0,
        NetCodeHandle.unknown_error,
      ][index];
}
