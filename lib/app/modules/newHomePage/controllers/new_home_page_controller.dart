import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/add_case_remark_widget.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/main.dart';

import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../views/widgets/create_case_widget.dart';

class NewHomePageController extends GetxController {
  /// 顶部筛选 tab 下标：0 我的待办、1 我参与的、2 已逾期
  final RxInt tabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  void switchTab(int index) {
    tabIndex.value = index;
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
        contentWidget: CreateCaseWidget());
  }

}
