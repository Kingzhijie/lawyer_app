import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../controllers/edit_concerned_person_page_controller.dart';

class EditConcernedPersonPageView
    extends GetView<EditConcernedPersonPageController> {
  const EditConcernedPersonPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: '新增当事人/关联方'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16.toW,
                right: 16.toW,
                top: 16.toW,
                bottom: 16.toW + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownField('类型', controller.typeController),
                  SizedBox(height: 16.toW),
                  _buildSwitchField('委托方', controller.isClient, required: true),
                  SizedBox(height: 16.toW),
                  _buildTextField(
                    '姓名',
                    controller.nameController,
                    required: true,
                  ),
                  SizedBox(height: 16.toW),
                  _buildDropdownField(
                    '属性',
                    controller.attributeController,
                    required: true,
                  ),
                  SizedBox(height: 16.toW),
                  _buildTextField('民族', controller.nationalityController),
                  SizedBox(height: 16.toW),
                  _buildDropdownField('性别', controller.genderController),
                  SizedBox(height: 16.toW),
                  _buildTextField('联系方式', controller.contactMethodController),
                  SizedBox(height: 16.toW),
                  _buildTextField('身份证号码', controller.idNumberController),
                  SizedBox(height: 16.toW),
                  _buildSwitchField('同步创建客户', controller.syncCreateCustomer),
                  SizedBox(height: 16.toW),
                  _buildTextField(
                    '住所地',
                    controller.addressController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.toW),
                  _buildTextField(
                    '备注',
                    controller.remarkController,
                    maxLines: 3,
                  ),
                  // SizedBox(height: 80.toW), // 为底部按钮留出空间
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    ).unfocusWhenTap();
  }

  // 普通输入框
  Widget _buildTextField(
    String label,
    TextEditingController textController, {
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (required)
              Text(
                '* ',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.toSp,
                color: AppColors.color_E6000000,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.toW),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.toW),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
          ),
          child: TextField(
            controller: textController,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 14.toSp,
              color: AppColors.color_E6000000,
            ),
            decoration: InputDecoration(
              hintText: '请输入',
              hintStyle: TextStyle(
                fontSize: 14.toSp,
                color: AppColors.color_99000000,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.toW,
                vertical: 12.toW,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 下拉选择框
  Widget _buildDropdownField(
    String label,
    TextEditingController textController, {
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (required)
              Text(
                '* ',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.toSp,
                color: AppColors.color_E6000000,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.toW),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.toW),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
          ),
          child: TextField(
            controller: textController,
            readOnly: true,
            style: TextStyle(
              fontSize: 14.toSp,
              color: AppColors.color_E6000000,
            ),
            onTap: () {
              if (label == '类型') {
                controller.chooseStylePage();
              }
              if (label == '属性') {
                controller.chooseAttributePage();
              }
              if (label == '性别') {
                controller.chooseSexPage();
              }
            },
            decoration: InputDecoration(
              hintText: '请选择',
              hintStyle: TextStyle(
                fontSize: 14.toSp,
                color: AppColors.color_99000000,
              ),
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.color_99000000,
                size: 20.toW,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.toW,
                vertical: 12.toW,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 开关字段
  Widget _buildSwitchField(
    String label,
    RxBool value, {
    bool required = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (required)
              Text(
                '* ',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.toSp,
                color: AppColors.color_E6000000,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Obx(
          () => Transform.scale(
            scale: 0.85,
            child: CupertinoSwitch(
              value: value.value,
              onChanged: (val) => value.value = val,
              activeColor: AppColors.theme,
            ),
          ),
        ),
      ],
    );
  }

  // 底部按钮
  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16.toW),
      margin: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.onCancel,
              child: Container(
                height: 48.toW,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.toW),
                  border: Border.all(color: AppColors.theme, width: 1),
                ),
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    color: AppColors.theme,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.toW),
          Expanded(
            child: GestureDetector(
              onTap: controller.onSubmit,
              child: Container(
                height: 48.toW,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.theme,
                  borderRadius: BorderRadius.circular(8.toW),
                ),
                child: Text(
                  '立即提交',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
