import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/caseDetailPage/controllers/case_detail_page_controller.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/controllers/contract_detail_page_controller.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../views/widget/choose_charge_style.dart';

class PartyRuleTypeClass {
  final String name;
  final int role;
  const PartyRuleTypeClass({required this.name, required this.role});
}

class EditConcernedPersonPageController extends GetxController {
  num? caseId;
  // 表单控制器
  final typeController = TextEditingController();
  final nameController = TextEditingController();
  final attributeController = TextEditingController();
  final nationalityController = TextEditingController();
  final genderController = TextEditingController();
  final contactMethodController = TextEditingController();
  final idNumberController = TextEditingController();
  final addressController = TextEditingController();
  final remarkController = TextEditingController();

  // 委托方开关
  final RxBool isClient = false.obs;
  // 同步创建客户开关
  final RxBool syncCreateCustomer = false.obs;
  Map<String, int> roleMap = {};

  @override
  void onInit() {
    super.onInit();
    caseId = Get.arguments;
    getPartyRoleListList();
  }

  void getPartyRoleListList() {
    NetUtils.get(Apis.partyRoleList, isLoading: false).then((result) {
      if (result.code == NetCodeHandle.success) {
        final roleList = (result.data as List);
        for (var item in roleList) {
          final name = item['name'];
          final role = item['role'];
          roleMap['$name'] = role;
        }
      }
    });
  }

  @override
  void onClose() {
    typeController.dispose();
    nameController.dispose();
    attributeController.dispose();
    nationalityController.dispose();
    genderController.dispose();
    contactMethodController.dispose();
    idNumberController.dispose();
    addressController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  // 取消
  void onCancel() {
    Get.back();
  }

  // 立即提交
  void onSubmit() {
    if (caseId == null) {
      return;
    }

    final type = typeController.text;
    if (type.isEmpty) {
      showToast('请选择类型');
      return;
    }

    final name = nameController.text;
    if (name.isEmpty) {
      showToast('请输入姓名');
      return;
    }

    final attribute = attributeController.text;
    if (attribute.isEmpty) {
      showToast('请选择属性');
      return;
    }

    final nationality = nationalityController.text;
    final gender = genderController.text;
    final contact = contactMethodController.text;
    final idNumber = idNumberController.text;
    final address = addressController.text;
    final remark = remarkController.text;
    final data = {
      'caseId': caseId,
      'partyType': type == '个人' ? 1 : 2,
      'isClient': isClient.value,
      'name': name,
      'partyRole': roleMap[attribute],
      'idType': 1,
      'idNumber': idNumber,
      'nationality': nationality,
      'gender': gender.isNotEmpty ? (gender == '男' ? 1 : 2) : '',
      'isCustomer': syncCreateCustomer.value,
      'phone': contact,
      'address': address,
      'remark': remark,
    };

    NetUtils.post(Apis.createPartyRole, params: data).then((result) {
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

  ///选择类型
  void chooseStylePage() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      height: 436.toW + AppScreenUtil.bottomBarHeight,
      radius: 12.toW,
      contentWidget: ChooseChargeStyle(
        title: '选择类型',
        selectStr: typeController.text,
        contents: ['个人', '企业'],
        chooseResult: (String content) {
          typeController.text = content;
        },
      ),
    );
  }

  ///选择属性
  void chooseAttributePage() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      height: 436.toW + AppScreenUtil.bottomBarHeight,
      radius: 12.toW,
      contentWidget: ChooseChargeStyle(
        title: '选择属性',
        selectStr: attributeController.text,
        contents: roleMap.keys.toList(),
        chooseResult: (String content) {
          attributeController.text = content;
        },
      ),
    );
  }

  ///选择性别
  void chooseSexPage() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      height: 436.toW + AppScreenUtil.bottomBarHeight,
      radius: 12.toW,
      contentWidget: ChooseChargeStyle(
        title: '选择性别',
        selectStr: genderController.text,
        contents: ['男', '女'],
        chooseResult: (String content) {
          genderController.text = content;
        },
      ),
    );
  }
}
