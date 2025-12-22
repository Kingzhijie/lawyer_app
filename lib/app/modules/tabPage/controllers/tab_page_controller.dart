import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

class TabPageController extends GetxController {
  /// PageView 控制器
  late PageController pageController;

  /// 当前选中的 Tab 索引（0~3）
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
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
}
