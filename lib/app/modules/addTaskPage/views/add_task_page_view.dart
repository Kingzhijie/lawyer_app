import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/add_task_page_controller.dart';
import 'widgets/add_task_item.dart';

class AddTaskPageView extends GetView<AddTaskPageController> {
  const AddTaskPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color_FFF3F3F3,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: AppScreenUtil.navigationBarHeight,
                bottom: 100.toW,
              ),
              child: Column(
                children: [
                  _buildTaskDetailsCard(),
                  SizedBox(height: 12.toW),
                  _buildAssociatedCaseCard(),
                ],
              ).withMarginOnly(left: 16.toW, right: 16.toW, top: 16.toW),
            ),
          ),
          _buildAppBar(),
          _buildSaveButton(),
        ],
      ),
    ).unfocusWhenTap();
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: AppScreenUtil.navigationBarHeight,
        padding: EdgeInsets.only(top: AppScreenUtil.statusBarHeight),
        decoration: BoxDecoration(color: AppColors.color_white),
        child: Row(
          children: [
            Container(
              width: 44.toW,
              height: 44.toW,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.toW,
                color: AppColors.color_E6000000,
              ),
            ).withOnTap(() {
              Get.back();
            }),
            Expanded(
              child: Text(
                '添加任务',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
            ),
            SizedBox(width: 44.toW),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormField(
            label: '任务名称',
            isRequired: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44.toW,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.color_line, width: 0.6),
                    borderRadius: BorderRadius.circular(8.toW),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.toW),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: controller.taskNameController,
                    style: TextStyle(
                      color: AppColors.color_E6000000,
                      fontSize: 16.toSp,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入',
                      hintStyle: TextStyle(
                        color: AppColors.color_FFC5C5C5,
                        fontSize: 16.toSp,
                      ),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(height: 8.toW),
                Text(
                  '请控制在4-20个字符',
                  style: TextStyle(
                    color: AppColors.color_66000000,
                    fontSize: 14.toSp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.toW),
          _buildFormField(
            label: '提醒时间',
            isRequired: true,
            child:
                Container(
                  height: 44.toW,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.color_line, width: 0.6),
                    borderRadius: BorderRadius.circular(8.toW),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.toW),
                  child: Obx(()=>Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.reminderTime.value.isEmpty
                              ? '请选择'
                              : controller.reminderTime.value,
                          style: TextStyle(
                            color: controller.reminderTime.value.isEmpty
                                ? AppColors.color_FFC5C5C5
                                : AppColors.color_E6000000,
                            fontSize: 16.toSp,
                          ),
                        ),
                      ),
                      if (controller.reminderTime.value.isNotEmpty)
                        ImageUtils(
                          imageUrl: Assets.common.closeBgIco.path,
                          width: 20.toW,
                          height: 20.toW,
                        ).withMarginOnly(right: 12.toW).withOnTap((){
                          controller.reminderTime.value = '';
                        }),
                      ImageUtils(
                        imageUrl: Assets.common.calendarChooseIcon.path,
                        width: 20.toW,
                        height: 20.toW,
                      ),
                    ],
                  )),
                ).withOnTap(() {
                  controller.selectReminderTime();
                }),
          ),
          SizedBox(height: 16.toW),
          _buildFormField(
            label: '是否紧急',
            isRequired: false,
            child: Obx(
              () => Row(
                children: [
                  _buildRadioButton(
                    label: '是',
                    value: true,
                    selected: controller.isUrgent.value == true,
                    onTap: () => controller.isUrgent.value = true,
                  ),
                  SizedBox(width: 24.toW),
                  _buildRadioButton(
                    label: '否',
                    value: false,
                    selected: controller.isUrgent.value == false,
                    onTap: () => controller.isUrgent.value = false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isRequired)
              Text(
                '* ',
                style: TextStyle(color: Colors.red, fontSize: 14.toSp),
              ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.color_E6000000,
                fontSize: 14.toSp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.toW),
        child,
      ],
    );
  }

  Widget _buildRadioButton({
    required String label,
    required bool value,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          ImageUtils(
            imageUrl: selected
                ? Assets.home.selectCrileIcon.path
                : Assets.home.unSelectCrileIcon.path,
            width: 24.toW,
          ),
          SizedBox(width: 4.toW),
          Text(
            label,
            style: TextStyle(
              color: AppColors.color_E6000000,
              fontSize: 16.toSp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssociatedCaseCard() {
    return Container(
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 14.toSp),
              ),
              Text(
                '关联案件',
                style: TextStyle(
                  color: AppColors.color_E6000000,
                  fontSize: 14.toSp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.toW),
          Obx(() {
            if (controller.selectModel.value == null) {
              return _buildAddCaseButton();
            } else {
              return AddTaskItem(
                type: TaskEnum.close,
                model: controller.selectModel.value,
                closeCardCallBack: () {
                  controller.selectModel.value = null;
                },
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildAddCaseButton() {
    return Container(
      height: 44.toW,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.color_FFC5C5C5, width: 0.6),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      alignment: Alignment.center,
      child: Text(
        '添加案件',
        style: TextStyle(color: AppColors.color_42000000, fontSize: 14.toSp),
      ),
    ).withOnTap(() {
      controller.selectCase();
    });
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.toW,
          right: 16.toW,
          bottom: AppScreenUtil.bottomBarHeight + 10.toW,
          top: 10.toW,
        ),
        decoration: BoxDecoration(
          color: AppColors.color_FFF3F3F3,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child:
            Container(
              height: 44.toW,
              decoration: BoxDecoration(
                color: AppColors.theme,
                borderRadius: BorderRadius.circular(8.toW),
              ),
              alignment: Alignment.center,
              child: Text(
                '保存',
                style: TextStyle(
                  color: AppColors.color_white,
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).withOnTap(() {
              controller.saveTask();
            }),
      ),
    );
  }
}
