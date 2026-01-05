import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../controllers/edit_case_base_info_controller.dart';

class EditCaseBaseInfoView extends GetView<EditCaseBaseInfoController> {
  const EditCaseBaseInfoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: '编辑案件基本信息'),
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
                  _buildTextField(
                    '案件名称',
                    controller.caseNameController,
                    required: true,
                  ),
                  SizedBox(height: 16.toW),
                  _buildTextField(
                    '案号',
                    controller.caseNumberController,
                    required: true,
                  ),
                  SizedBox(height: 16.toW),
                  _buildTextField(
                    '案由',
                    controller.caseReasonController,
                    required: true,
                    maxLines: 2,
                  ),
                  SizedBox(height: 16.toW),
                  _buildTextField('承办律师', controller.primaryLawyerController),
                  SizedBox(height: 16.toW),
                  _buildTextField('协办律师', controller.assistantLawyerController),
                  SizedBox(height: 16.toW),
                  _buildTextField('法官电话', controller.judgePhoneController),
                  SizedBox(height: 16.toW),
                  _buildTextField(
                    '案件备注',
                    controller.caseRemarkController,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButtons(),
    ).unfocusWhenTap();
  }

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
