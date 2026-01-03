import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../editConcernedPersonPage/views/widget/choose_charge_style.dart';

class AttorneysFeePageController extends GetxController {
  // 表单控制器
  final chargeMethodController = TextEditingController();
  final targetAmountController = TextEditingController();
  final targetObjectController = TextEditingController();
  final agencyFeeController = TextEditingController();
  final feeIntroController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void onClose() {
    chargeMethodController.dispose();
    targetAmountController.dispose();
    targetObjectController.dispose();
    agencyFeeController.dispose();
    feeIntroController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  // 取消
  void onCancel() {
    Get.back();
  }

  // 确认修改
  void onConfirm() {

  }

  void chooseChargeStylePage() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      height: 436.toW + AppScreenUtil.bottomBarHeight,
      radius: 12.toW,
      contentWidget: ChooseChargeStyle(
        title: '收费方式',
        selectStr: chargeMethodController.text,
        contents: [
          '定额收费', '风险收费', '计时收费', '计件收费', '免费'
        ],
        chooseResult: (String content) {
          chargeMethodController.text = content;
        },
      ),
    );
  }

}
