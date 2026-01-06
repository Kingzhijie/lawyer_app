import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/caseDetailPage/controllers/case_detail_page_controller.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/controllers/contract_detail_page_controller.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_base_model.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

class EditCaseBaseInfoController extends GetxController {
  int? caseId;
  CaseBaseModel? caseBase;
  final caseNameController = TextEditingController();
  final caseReasonController = TextEditingController();
  final caseNumberController = TextEditingController();
  final primaryLawyerController = TextEditingController();
  final assistantLawyerController = TextEditingController();
  final judgePhoneController = TextEditingController();
  final caseRemarkController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      caseBase = arguments['caseBase'];
      caseId = arguments['caseId'];
      if (caseBase != null) {
        caseNameController.text = caseBase!.caseName ?? '';
        caseNumberController.text = caseBase!.caseNumber ?? '';
        caseReasonController.text = caseBase!.caseReason ?? '';
        primaryLawyerController.text = caseBase!.primaryLawyer ?? '';
        assistantLawyerController.text = caseBase!.assistantLawyer ?? '';
        judgePhoneController.text = caseBase!.judgePhone ?? '';
        caseRemarkController.text = caseBase!.caseRemark ?? '';
      }
    }
  }

  void onSubmit() async {
    final caseName = caseNameController.text;
    if (caseName.isEmpty) {
      showToast('请输入案件名称');
      return;
    }

    final caseNumber = caseNumberController.text;
    if (caseNumber.isEmpty) {
      showToast('请输入案号');
      return;
    }

    final caseReason = caseReasonController.text;
    if (caseReason.isEmpty) {
      showToast('请输入案由');
      return;
    }

    final primaryLawyer = primaryLawyerController.text;
    final assistantLawyer = assistantLawyerController.text;
    final judgePhone = judgePhoneController.text;
    final caseRemark = caseRemarkController.text;
    final data = {
      'id': caseId,
      'caseName': caseName,
      'caseNumber': caseNumber,
      'caseReason': caseReason,
      'caseRemark': caseRemark,
      'primaryLawyer': primaryLawyer,
      'assistantLawyer': assistantLawyer,
      'judgePhone': judgePhone,
      // 'status': caseBase!.status,
      // 'caseType': caseBase!.caseType,
      // 'caseProcedure': caseBase!.caseProcedure,
      // 'casePartyRole': caseBase!.casePartyRole,
    };

    NetUtils.put(Apis.updateCaseBasicInfo, params: data).then((result) {
      if (result.code == NetCodeHandle.success) {
        getFindController<ContractDetailPageController>()
            ?.getContractDetailInfo();
        getFindController<CaseDetailPageController>()?.getCaseDetailInfo();
        delay(1, () {
          Get.back();
        });
      }
    });
  }

  // 取消
  void onCancel() {
    Get.back();
  }

  @override
  void onClose() {
    caseNameController.dispose();
    caseReasonController.dispose();
    caseNumberController.dispose();
    primaryLawyerController.dispose();
    assistantLawyerController.dispose();
    judgePhoneController.dispose();
    caseRemarkController.dispose();
    super.onClose();
  }
}
