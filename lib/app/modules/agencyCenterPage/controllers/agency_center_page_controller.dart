import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../newHomePage/views/widgets/add_case_remark_widget.dart';
import '../../newHomePage/views/widgets/create_case_widget.dart';

class AgencyCenterPageController extends GetxController {

  /// 顶部筛选 tab 下标：0 全部、1 紧急任务、2 今日到期, 3. 已逾期
  final RxInt tabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void switchTab(int index) {
    tabIndex.value = index;
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

  ///添加任务
  void addTaskAction() {
    Get.toNamed(Routes.ADD_TASK_PAGE);
  }

}
