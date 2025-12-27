import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/myPage/controllers/my_page_controller.dart';
import 'package:lawyer_app/app/modules/myPage/views/my_page_view.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/add_case_remark_widget.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../views/widgets/cooperation_person_widget.dart';
import '../views/widgets/create_case_widget.dart';

class NewHomePageController extends GetxController {
  /// 顶部筛选 tab 下标：0 我的待办、1 我参与的、2 已逾期
  final RxInt tabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  void switchTab(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void lookCalendarCaseAction() {
    Get.toNamed(Routes.CALENDAR_PAGE);
  }

  ///添加备注
  void addRemarkMethod() {
    textEditingController.text = '';
    BottomSheetUtils.show(currentContext,
        isShowCloseIcon: false,
        radius: 12.toW,
        contentWidget: AddCaseRemarkWidget(sendAction: (text){

        },textEditingController: textEditingController));
  }

  void linkUserAlert(){
    BottomSheetUtils.show(currentContext,
        radius: 12.toW,
        isShowCloseIcon: true,
        height: AppScreenUtil.screenHeight - 217.toW,
        isSetBottomInset: false,
        contentWidget: LinkUserWidget());
  }

  void searchCaseAction() {
    Get.toNamed(Routes.SEARCH_CASE_PAGE);
  }

  /// 打开我的页面底部抽屉
  void openMyPageDrawer() {
    logPrint('1111');
    getFindController<TabPageController>()?.openDrawer();
  }

}
