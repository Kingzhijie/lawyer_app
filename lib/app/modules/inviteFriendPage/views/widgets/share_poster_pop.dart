import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharePosterPop extends StatefulWidget {
  const SharePosterPop({super.key});

  @override
  State<SharePosterPop> createState() => _SharePosterPopState();
}

class _SharePosterPopState extends State<SharePosterPop> {
  final GlobalKey _containerKey = GlobalKey();

  Future<void> onSavePicture() async {
    final result = await requestStoragePermission();
    if (!result) {
      await openAppSettings();
      return;
    }

    try {
      final boundary =
          _containerKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        return;
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData == null) {
        return;
      }

      final result = await ImageGallerySaverPlus.saveImage(
        byteData.buffer.asUint8List(),
        quality: 100,
      );
      bool? isSuccess = result['isSuccess'];
      if (isSuccess == true) {
        showToast('保存成功');
      }
    } catch (e) {
      debugPrint('截图错误: $e');
    }
  }

  Future<bool> requestStoragePermission() async {
    if (GetPlatform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        var status = await Permission.photos.request();
        return status.isGranted;
      } else if (sdkInt >= 30) {
        var status = await Permission.storage.request();
        return status.isGranted;
      } else {
        var status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (GetPlatform.isIOS) {
      if (await Permission.storage.request().isGranted) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo =
        getFindController<NewHomePageController>()?.userModel.value;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ImageUtils(
              imageUrl: Assets.common.shareClose.path,
              width: 32.toW,
              height: 32.toW,
            ).withOnTap(() => Get.back()),
          ),
          SizedBox(height: 12.toW),
          RepaintBoundary(
            key: _containerKey,
            child: SizedBox(
              width: 334.toW,
              height: 507.toW,
              child: Stack(
                children: [
                  ImageUtils(
                    imageUrl: Assets.common.sharePosterBack.path,
                    width: 334.toW,
                    height: 507.toW,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24.toW),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.toW),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 26.toW),
                              Text(
                                '${userInfo?.nickname ?? ''}邀请你加入灵伴',
                                style: TextStyle(
                                  fontSize: 16.toSp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.color_E6000000,
                                ),
                              ),
                              SizedBox(height: 8.toW),
                              Text(
                                '会员免费领',
                                style: TextStyle(
                                  fontSize: 24.toSp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.color_E6000000,
                                ),
                              ),
                              SizedBox(height: 8.toW),
                              Text(
                                '登录并创建案件，可解锁会员福利',
                                style: TextStyle(
                                  fontSize: 13.toSp,
                                  color: AppColors.color_99000000,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageUtils(
                                  imageUrl: Assets.common.shareLogo.path,
                                  width: 62.toW,
                                  height: 24.toW,
                                ),
                                SizedBox(height: 5.toW),
                                Text(
                                  '识别二维码 免费领会员',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.toSp,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            QrImageView(
                              data: 'dsadfasdsadsa',
                              version: QrVersions.auto,
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(5.toW),
                              size: 88.toW,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.toW),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.toW),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ImageUtils(
                    imageUrl: Assets.common.sharePyq.path,
                    width: 52.toW,
                    height: 52.toW,
                  ),
                  SizedBox(height: 10.toW),
                  Text(
                    '朋友圈',
                    style: TextStyle(fontSize: 14.toSp, color: Colors.white),
                  ),
                ],
              ).withOnTap(() {
                showToast('朋友圈');
              }),
              Column(
                children: [
                  ImageUtils(
                    imageUrl: Assets.common.shareWx.path,
                    width: 52.toW,
                    height: 52.toW,
                  ),
                  SizedBox(height: 10.toW),
                  Text(
                    '微信好友',
                    style: TextStyle(fontSize: 14.toSp, color: Colors.white),
                  ),
                ],
              ).withOnTap(() {
                showToast('微信好友');
              }),
              Column(
                children: [
                  ImageUtils(
                    imageUrl: Assets.common.shareSave.path,
                    width: 52.toW,
                    height: 52.toW,
                  ),
                  SizedBox(height: 10.toW),
                  Text(
                    '下载图片',
                    style: TextStyle(fontSize: 14.toSp, color: Colors.white),
                  ),
                ],
              ).withOnTap(() {
                onSavePicture();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
