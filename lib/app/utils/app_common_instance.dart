import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';

import '../routes/app_pages.dart';
import 'object_utils.dart';

class AppInfoUtils {
  //单例
  AppInfoUtils._privateConstructor();

  static final AppInfoUtils _instance = AppInfoUtils._privateConstructor();

  static AppInfoUtils get instance {
    return _instance;
  }
  ///是否已经弹出Dialog
  bool isAlertDialog = false;

  ///渠道
  String? appChannel;

  // app登录后,初始化push一次
  bool appLoginInitPush = false;

  /// 推送的ClientId
  String? pushClientId;
}

class AppCommonUtils {
  /// 是否已经登录
  static bool get isLogin => StorageUtils.getToken().isNotEmpty;

  /// 是否首次安装
  static bool get getIsFirstInstall => StorageUtils.getIsFirstInstall().isEmpty;

  /// 退出登录, 统一处理, 需要移除的东西
  static void logout({bool isAlert = true}) {
    StorageUtils.removeString(StorageKey.accessToken);
    if (isAlert) {
      // AppDialog.singleItem(
      //   title: S.of(currentContext).alert,
      //   titleStyle: TextStyle(
      //       color: Colors.black,
      //       fontSize: 17.toSp,
      //       fontWeight: FontWeight.w600),
      //   content: S.of(currentContext).offline_notice,
      //   contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
      //   cancel: S.of(currentContext).iKnow,
      //   firstBtnTextStyle: TextStyle(
      //       color: AppColors.theme,
      //       fontSize: 13.toSp,
      //       fontWeight: FontWeight.w500),
      //   onCancel: () {
      //     backAppRootPage();
      //   },
      // ).showAlert();
    } else {
      backAppRootPage();
    }
  }

  ///返回app主页
  static void backAppRootPage(){
    logPrint('tuichudelu');
    getFindController<TabPageController>()?.closeDrawer();
    Get.until((route) => Get.currentRoute == Routes.TAB_PAGE);
    changeTabHome();
  }


  /// 切换tab到主页
  static void changeTabHome({int index = 0}) {
    var tabController = getFindController<TabPageController>();
    tabController?.forceRefreshTab(index);
  }

}
