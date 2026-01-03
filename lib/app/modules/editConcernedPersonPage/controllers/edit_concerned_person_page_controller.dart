import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../views/widget/choose_charge_style.dart';

class EditConcernedPersonPageController extends GetxController {
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
    // TODO: 实现提交逻辑
    Get.back();
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
        contents: [
          '类型1', '类型2', '类型3', '类型4'
        ],
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
        contents: [
          '属性1', '属性12', '属性13', '属性14'
        ],
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
        contents: [
          '男', '女'
        ],
        chooseResult: (String content) {
          genderController.text = content;
        },
      ),
    );
  }

}
