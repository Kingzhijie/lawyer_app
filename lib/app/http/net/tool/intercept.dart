import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../utils/storage_utils.dart';
import 'logger.dart';


//header中添加token
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String accessToken = 'test1';
    //StorageUtils.getToken();
    logPrint('accessToken===$accessToken');
    options.headers['Authorization'] = 'Bearer $accessToken';
    // options.headers['App-brand'] = base64Encode(utf8.encode(DeviceInfo.brand ?? ''));
    // options.headers['Device-type'] = PlatformUtils.platform;
    // options.headers['platformID'] = PlatformUtils.isIOS ? 1 : 2;
    // options.headers['App-build'] = DeviceInfo.buildNumber;
    // options.headers['App-version'] = DeviceInfo.version;
    // options.headers['channel'] = AppInfoUtils.instance.appChannel;
    // options.headers['Accept-Encoding'] = 'gzip, deflate';
    //
    // options.headers['latitude'] = AppInfoUtils.instance.latitude;
    // options.headers['longitude'] = AppInfoUtils.instance.longitude;
    super.onRequest(options, handler);
  }
}

/// 错误信息拦截
class TokenInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Map<String, dynamic> map = {};
    // if (response.data is String) {
    //   map = jsonDecode(response.data!);
    // } else if (response.data is Map) {
    //   map = response.data!;
    // } else {
    //   var error = NetCodeHandle.handleException(
    //       NetError(NetCodeHandle.parse_error, '数据解析错误'));
    //   showToast(error.msg);
    //   return;
    // }
    // int code = map['code'] as int? ?? 0;
    // switch (code) {
    //   case NetCodeHandle.success:
    //     break;
    //   case NetCodeHandle.unauthorized:
    //     _logoutAction();
    //   default:
    //     // showToast(map['data'].toString());
    // }
    super.onResponse(response, handler);
  }

}
