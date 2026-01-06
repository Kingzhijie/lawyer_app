import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/caseDetailPage/controllers/case_detail_page_controller.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/agency_fee_model.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../editConcernedPersonPage/views/widget/choose_charge_style.dart';

class AttorneysFeePageController extends GetxController {
  int? caseId;
  AgencyFeeModel? agencyFeeInfo;
  // 表单控制器
  final chargeMethodController = TextEditingController();
  final targetAmountController = TextEditingController();
  final targetObjectController = TextEditingController();
  final agencyFeeController = TextEditingController();
  final feeIntroController = TextEditingController();
  final remarksController = TextEditingController();

  final typeMap = {
    '1': '定额收费',
    '2': '风险收费',
    '3': '计时收费',
    '4': '计件收费',
    '5': '免费',
  };

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      agencyFeeInfo = arguments['agencyFee'];
      caseId = arguments['caseId'];
      if (agencyFeeInfo != null) {
        chargeMethodController.text =
            typeMap[(agencyFeeInfo!.feeType ?? 1).toString()] ?? '定额收费';
        targetAmountController.text = ((agencyFeeInfo?.targetAmount ?? 0) / 100)
            .toString();
        targetObjectController.text = agencyFeeInfo?.targetObject ?? '';
        agencyFeeController.text = ((agencyFeeInfo?.agencyFee ?? 0) / 100)
            .toString();
        feeIntroController.text = agencyFeeInfo?.feeIntro ?? '';
        remarksController.text = agencyFeeInfo?.remark ?? '';
      }
    }
  }

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
  void onConfirm() async {
    final type = chargeMethodController.text;
    if (type.isEmpty) {
      showToast('请选择收费方式');
      return;
    }

    var feeType = '1';
    for (var item in typeMap.keys) {
      final value = typeMap[item];
      if (type == value) {
        feeType = item;
      }
    }

    final targetAmount = targetAmountController.text;
    final targetAmountValue = double.tryParse(targetAmount) ?? 0;
    if (targetAmount.isEmpty || targetAmountValue <= 0) {
      showToast('请输入标的额');
      return;
    }

    final targetObject = targetObjectController.text;
    final agencyFee = agencyFeeController.text;
    final feeIntro = feeIntroController.text;
    final remark = remarksController.text;
    final data = {
      'caseId': caseId,
      'feeType': feeType,
      'agencyFee': ((double.tryParse(agencyFee) ?? 0) * 100).toInt(),
      'targetObject': targetObject,
      'targetAmount': (targetAmountValue * 100).toInt(),
      'feeIntro': feeIntro,
      'remark': remark,
    };

    if (agencyFeeInfo == null) {
      NetUtils.post(Apis.createAgencyFee, params: data).then((result) {
        if (result.code == NetCodeHandle.success) {
          reloadCaseInfo();
        }
      });
      return;
    }

    data['id'] = agencyFeeInfo!.id;
    NetUtils.put(Apis.updateAgencyFee, params: data).then((result) {
      if (result.code == NetCodeHandle.success) {
        reloadCaseInfo();
      }
    });
  }

  void reloadCaseInfo() {
    getFindController<CaseDetailPageController>()?.getCaseDetailInfo();
    delay(1, () {
      Get.back();
    });
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
        contents: ['定额收费', '风险收费', '计时收费', '计件收费', '免费'],
        chooseResult: (String content) {
          chargeMethodController.text = content;
        },
      ),
    );
  }
}
