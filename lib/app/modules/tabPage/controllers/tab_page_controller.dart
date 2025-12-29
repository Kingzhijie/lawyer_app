import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

import '../../../utils/app_common_instance.dart';
import '../../../utils/device_info_utils.dart';
import '../../../utils/push/pushUtil.dart';
import '../../../utils/storage_utils.dart';

class TabPageController extends GetxController {
  /// PageView 控制器
  late PageController pageController;

  /// 当前选中的 Tab 索引（0~3）
  final RxInt currentIndex = 0.obs;

  final isFinishInit = Rx<bool?>(null);

  @override
  void onInit() {
    super.onInit();
    _init();
    pageController = PageController(initialPage: currentIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// 点击底部 Tab 时切换 PageView
  void changeIndex(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// PageView 滑动时同步底部 Tab
  void onPageChanged(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
  }

  /// 中间加号按钮点击
  void onCenterTap() {
    Get.toNamed(Routes.HOME);
  }

  ///工具初始化
  void _init() async {
    if (AppCommonUtils.getIsFirstInstall) {
      isFinishInit.value = false;
    } else {
      await _initThirdSDK();
      isFinishInit.value = true;
    }
  }

  Future<void> callBack() async {
    StorageUtils.setIsFirstInstall();
    await _initThirdSDK(isFirst: true);
    isFinishInit.value = true;
  }

  ///初始化第三方工具
  Future<bool> _initThirdSDK({bool isFirst = false}) async {
    AppInfoUtils.instance.appChannel = await DeviceInfo.getChannel();

    /// 设备信息
    await DeviceInfo.appVersion();

    bool isSuc = await PushUtil.initPushSDK();
    if (isSuc) {
      PushUtil.addEventHandler();
    }

    await DeviceInfo.deviceInfo();

    return true;
  }
}
