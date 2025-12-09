import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import '../../utils/image_utils.dart';
import '../../utils/loading.dart';
import '../../utils/toast_utils.dart';
import '../apis.dart';
import '../../config/dio_config.dart';
import 'tool/base_entity.dart';
import 'package:http_parser/http_parser.dart'; // 包含MediaType类
import 'package:image_picker/image_picker.dart';

import 'tool/dio_utils.dart';

/*
await NetUtils.get('/manager', queryParameters: {'id': 12});
await NetUtils.post('/manager', params: {'id': 12});
 */

// 结合状态管理
class NetUtils {
  /*
  * get 请求
  * url: 请求的url
  * isLoading: 是否显示loading加载框
  * isToastErrorMsg: 是否弹出错误信息
  * params: body参数
  * queryParameters: query参数
  *  */
  static Future<BaseEntity> get<T>(
    String url, {
    bool isLoading = true,
    bool isToastErrorMsg = true,
    Object? params,
    Map<String, dynamic>? queryParameters,
  }) {
    return DioUtils.instance.requestNetwork(Method.get, url,
        params: params,
        queryParameters: queryParameters,
        isLoading: isLoading,
        isToastErrorMsg: isToastErrorMsg);
  }

  /*
  * post 请求
  * url: 请求的url
  * isLoading: 是否显示loading加载框
  * isToastErrorMsg: 是否弹出错误信息
  * params: body参数
  * queryParameters: query参数
  *  */
  static Future<BaseEntity> post<T>(
    String url, {
    bool isLoading = true,
    bool isToastErrorMsg = true,
    Object? params,
    Map<String, dynamic>? queryParameters,
  }) {
    return DioUtils.instance.requestNetwork(Method.post, url,
        params: params,
        queryParameters: queryParameters,
        isLoading: isLoading,
        isToastErrorMsg: isToastErrorMsg);
  }

  /*
  * patch 请求
  * url: 请求的url
  * isLoading: 是否显示loading加载框
  * isToastErrorMsg: 是否弹出错误信息
  * params: body参数
  * queryParameters: query参数
  * onSuccess: 成功回调
  * onError: 失败回调
  *  */
  static Future<BaseEntity> patch<T>(
    String url, {
    bool isLoading = true,
    bool isToastErrorMsg = true,
    Object? params,
    Map<String, dynamic>? queryParameters,
  }) {
    return DioUtils.instance.requestNetwork(Method.patch, url,
        params: params,
        queryParameters: queryParameters,
        isLoading: isLoading,
        isToastErrorMsg: isToastErrorMsg);
  }

  /*
  * put 请求
  * url: 请求的url
  * isLoading: 是否显示loading加载框
  * isToastErrorMsg: 是否弹出错误信息
  * params: body参数
  * queryParameters: query参数
  * onSuccess: 成功回调
  * onError: 失败回调
  *  */
  static Future<BaseEntity> put<T>(
    String url, {
    bool isLoading = true,
    bool isToastErrorMsg = true,
    Object? params,
    Map<String, dynamic>? queryParameters,
  }) {
    return DioUtils.instance.requestNetwork(Method.put, url,
        params: params,
        queryParameters: queryParameters,
        isLoading: isLoading,
        isToastErrorMsg: isToastErrorMsg);
  }

  /*
  * delete 请求
  * url: 请求的url
  * isLoading: 是否显示loading加载框
  * isToastErrorMsg: 是否弹出错误信息
  * params: body参数
  * queryParameters: query参数
  * onSuccess: 成功回调
  * onError: 失败回调
  *  */
  static Future<BaseEntity> delete<T>(
    String url, {
    bool isLoading = true,
    bool isToastErrorMsg = true,
    Object? params,
    Map<String, dynamic>? queryParameters,
  }) {
    return DioUtils.instance.requestNetwork(Method.delete, url,
        params: params,
        queryParameters: queryParameters,
        isLoading: isLoading,
        isToastErrorMsg: isToastErrorMsg);
  }

  /// 上传单张图片（使用Dio直接上传）
  static Future<Map<String, dynamic>?> uploadSingleImage(String filePath,
      {bool isVideo = false, XFile? xfile, Uint8List? xfileBytes}) async {
    try {
      LoadingTool.showLoading();
      final dio = DioUtils.instance.dio;
      String compressedPath = filePath;
      FormData? formData;

      // 移动端原有逻辑
      if (!isVideo) {
          if (ImageUtils.getImageType(filePath) == ImageUtilsType.asset) {
            final fileBytes = await FlutterImageCompress.compressAssetImage(
              filePath,
              quality: 100,
              minWidth: 1080,
              minHeight: 1080,
              format: CompressFormat.jpeg,
            );
            if (fileBytes != null) {
              final MultipartFile multipartFile = MultipartFile.fromBytes(
                fileBytes,
                filename: '${DateTime.now().millisecond}_compressed.jpg',
                contentType: MediaType('image', 'jpeg'),
              );
              formData = FormData.fromMap({
                'image': multipartFile,
              });
            }
          } else {
            final compressedFile =
                await FlutterImageCompress.compressAndGetFile(
              filePath,
              '${filePath}_compressed.jpg',
              quality: 100,
              minWidth: 1080,
              minHeight: 1080,
              format: CompressFormat.jpeg,
            );
            compressedPath = compressedFile?.path ?? filePath;
            formData = FormData.fromMap({
              'image': await MultipartFile.fromFile(
                compressedPath,
                filename:
                    'upload_${DateTime.now().millisecondsSinceEpoch}.${isVideo ? 'mp4' : 'jpg'}',
              ),
            });
          }
        }

      if (formData == null) {
        return null;
      }
      final response = await dio.post(
        DioConfig.baseURL + Apis.uploadSingleImage,
        data: formData,
        onSendProgress: (int sent, int total) {
          final progress = (sent / total * 100).toStringAsFixed(0);
          logPrint('上传进度: $progress%');
        },
      );
      LoadingTool.dismissLoading();
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          if (data['data'] != null) {
            logPrint("上传图片成功: " + data.toString());
            final dataImage = data['data'];
            if (dataImage['imageUrl'] != null) {
              return {
                'imageUrl': dataImage['imageUrl'],
                'imageId': dataImage['imageId'],
              };
            }
          }
        }
      } else {
        showToast('上传失败');
      }
      return null;
    } catch (e) {
      LoadingTool.dismissLoading();
      logPrint('图片上传失败: $e');
      showToast('上传失败');
      return null;
    }
  }
}
