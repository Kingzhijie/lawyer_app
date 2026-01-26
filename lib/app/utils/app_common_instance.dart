import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';

import '../common/components/dialog.dart';
import '../common/constants/app_colors.dart';
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
    StorageUtils.removeString(StorageKey.refreshToken);
    StorageUtils.removeString(StorageKey.tokenExpiresTime);
    StorageUtils.removeString(StorageKey.userId);
    if (isAlert) {
      AppDialog.singleItem(
        title: '温馨提示',
        titleStyle: TextStyle(
            color: Colors.black,
            fontSize: 17.toSp,
            fontWeight: FontWeight.w600),
        content: '您当前账号已下线, 请重新登录\n如非本人操作请及时修改密码或联系客服',
        contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
        cancel: '我知道了',
        firstBtnTextStyle: TextStyle(
            color: AppColors.theme,
            fontSize: 13.toSp,
            fontWeight: FontWeight.w500),
        onCancel: () {
          backAppRootPage();
        },
      ).showAlert();
    } else {
      backAppRootPage();
    }
  }

  ///返回app主页
  static void backAppRootPage(){
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
