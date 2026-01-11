import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:image/image.dart' as img;

import '../../main.dart';
import 'permission_util.dart';

enum ImageSourceType {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

enum MyRequestType { image, video }

class ImagePickerUtil {
  /// 从相册选取或者拍摄图片
  static Future<XFile?> takePhotoOrFromLibrary({
    ImageSourceType imageSource = ImageSourceType.gallery,
    MyRequestType requestType = MyRequestType.image,
  }) async {
    // 图片
    if (imageSource == ImageSourceType.gallery &&
        await PermissionUtils.requestPhotoPickPermission()) {
      List<AssetEntity> models = await selectImages(requestType: requestType);
      if (models.isNotEmpty) {
        File? file = await models.first.originFile;
        if (file != null) {
          XFile xFile = XFile(file.path, bytes: file.readAsBytesSync());
          return xFile;
        }
      }
    }
    //相机
    if (imageSource == ImageSourceType.camera &&
        await PermissionUtils.requestCameraPermission()) {
      final ImagePicker picker = ImagePicker();
      return await picker.pickImage(source: ImageSource.camera, maxWidth: 1080);
    }
    return null;
  }

  /// 从相册选取多张图片
  static Future<List<XFile>?> takeManyPhotoOrFromLibrary({
    ImageSourceType imageSource = ImageSourceType.gallery,
    int maxCount = 9,
    MyRequestType requestType = MyRequestType.image,
  }) async {
    // 图片
    if (imageSource == ImageSourceType.gallery &&
        await PermissionUtils.requestPhotoPickPermission()) {
      List<XFile> xFiles = [];
      List<AssetEntity> models = await selectImages(
        maxCount: maxCount,
        requestType: requestType,
      );
      for (var element in models) {
        File? file = await element.originFile;
        if (file != null) {
          XFile xFile = XFile(file.path, bytes: file.readAsBytesSync());
          xFiles.add(xFile);
        }
      }
      return xFiles;
    }
    return null;
  }

  /// 图片选择
  static Future<List<AssetEntity>> selectImages({
    int maxCount = 1,
    MyRequestType requestType = MyRequestType.image,
  }) async {
    final List<AssetEntity> pickResult =
        await AssetPicker.pickAssets(
          currentContext,
          pickerConfig: AssetPickerConfig(
            requestType: requestType == MyRequestType.image
                ? RequestType.image
                : RequestType.video,
            maxAssets: maxCount,
            // 最多选择数量
            keepScrollOffset: true,
            // 记录上次滚动位置
            themeColor: Theme.of(currentContext).colorScheme.primary,
            textDelegate: const AssetPickerTextDelegate(),
          ),
        ) ??
        [];
    return pickResult;
  }
}
