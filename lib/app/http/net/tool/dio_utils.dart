import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/utils/app_common_instance.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../utils/loading.dart';
import '../../../utils/object_utils.dart';
import '../../../utils/toast_utils.dart';
import 'base_entity.dart';
import '../../../config/dio_config.dart';
import 'error_handle.dart';
import 'intercept.dart';
import 'logger.dart';

class DioUtils {
  static DioUtils get instance => DioUtils();

  factory DioUtils() => _singleton;
  static final DioUtils _singleton = DioUtils._();
  static late Dio _dio;

  Dio get dio => _dio;

  DioUtils._() {
    final BaseOptions options = BaseOptions(
      connectTimeout: DioConfig.connectTimeout,
      receiveTimeout: DioConfig.receiveTimeout,
      headers: DioConfig.httpHeaders,
      baseUrl: DioConfig.baseURL,
    );
    options.sendTimeout = DioConfig.sendTimeout;
    _dio = Dio(options);
    _addAuthInterceptor();
    _prettyDioLogger();
  }

  /// 打印dio日志
  _prettyDioLogger() {
    if (!LogUtil.httpDetail.isShowLog) return;
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 100,
      ),
    );
  }

  /// 添加授权
  _addAuthInterceptor() {
    _dio.interceptors.add(AuthInterceptor());
    _closeHttpsSecurity();
  }

  /// 关闭https证书校验
  void _closeHttpsSecurity() {
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
  }

  /// 网络请求
  Future<BaseEntity> requestNetwork<T>(
    Method method,
    String url, {
    Object? params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool isLoading = true,
    bool isCheckToken = false,
    bool isToastErrorMsg = true,
  }) {
    return _request<T>(
      method.value,
      url,
      data: params,
      queryParameters: queryParameters,
      options: options,
      isLoading: isLoading,
      isCheckToken: isCheckToken,
      isToastErrorMsg: isToastErrorMsg,
      cancelToken: cancelToken,
    );
  }

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity> _request<T>(
    String method,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool isLoading = true,
    bool isToastErrorMsg = true,
    bool isCheckToken = false,
    Options? options,
  }) async {
    if (isLoading) {
      LoadingTool.showLoading();
    }
    try {
      ///刷新token的逻辑
      if (AppCommonUtils.isLogin && !isCheckToken) {
        int? tokenExpiresTime = StorageUtils.getInt(StorageKey.tokenExpiresTime);
        String refreshToken = StorageUtils.getString(StorageKey.refreshToken).toString();

        if (tokenExpiresTime != null &&
            tokenExpiresTime > 0 &&
            tokenExpiresTime <= DateTime.now().millisecondsSinceEpoch &&
            !ObjectUtils.isEmptyString(refreshToken)) {
          //token过期,  需要刷新token换token
          logPrint('token过期,  需要刷新token从新换取');
          var data = await NetUtils.post(
            Apis.refreshToken,
            params: {'refreshToken': refreshToken},
            isCheckToken: true,
          );
          if (data.code == NetCodeHandle.success) {
            String accessToken = data.data['accessToken'].toString();
            String refreshToken = data.data['refreshToken'].toString();
            int expiresTime = int.parse(data.data['expiresTime'] ?? '0'); //毫秒
            if (!ObjectUtils.isEmptyString(accessToken)) {
              StorageUtils.setToken(accessToken);
              StorageUtils.setString(StorageKey.refreshToken, refreshToken);
              if (expiresTime > 0) {
                StorageUtils.setInt(StorageKey.tokenExpiresTime, expiresTime);
              }
            }
          } else {
            BaseEntity<T> model = BaseEntity<T>.fromJson({
              'code': NetCodeHandle.unauthorized,
            });
            return model;
          }
        }
      }

      final Response<Map<String, dynamic>> response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken,
      );
      if (isLoading) {
        LoadingTool.dismissLoading();
      }
      if (response.data is Map) {
        final Map<String, dynamic> map = response.data!;
        BaseEntity<T> model = BaseEntity<T>.fromJson(map);
        if (model.code != NetCodeHandle.success && isToastErrorMsg) {
          if (model.code == NetCodeHandle.unauthorized) {
            //token失效, 或者未登录
            // AppCommonUtils.logout();
          } else {
            showToast(model.message);
          }
        }
        return model;
      } else {
        var error = NetCodeHandle.handleException(
          NetError(NetCodeHandle.parse_error, '数据解析错误'),
        );
        BaseEntity<T> model = BaseEntity<T>(error.code, error.msg, null);
        if (model.code == NetCodeHandle.unauthorized) {
          //token失效, 或者未登录
          // AppCommonUtils.logout();
        } else if (isToastErrorMsg) {
          showToast(model.message);
        }
        return model;
      }
    } catch (e) {
      if (isLoading) {
        LoadingTool.dismissLoading();
      }
      BaseEntity<T> model = BaseEntity<T>(
        NetCodeHandle.handleException(e).code,
        NetCodeHandle.handleException(e).msg,
        null,
      );
      if (isToastErrorMsg) {
        if (DioConfig.env == Env.product) {
          // showToast(model.message);
        } else {
          //非正式服务
          showToast(model.message + 'url: $url', closeTime: 4);
        }
      }
      if (model.code == NetCodeHandle.unauthorized) {
        //token失效, 或者未登录
        // AppCommonUtils.logout();
      }
      return model;
    }
  }

  Options _checkOptions(String method, Options? options) {
    options ??= Options();
    options.method = method;
    return options;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data) as Map<String, dynamic>;
}

enum Method { get, post, put, patch, delete, head }

extension MethodExtension on Method {
  String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
}
