import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/modules/addTaskPage/views/widgets/choose_case_alert.dart';
import 'package:lawyer_app/app/modules/addTaskPage/views/widgets/notice_date_choose.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../../http/net/tool/logger.dart';
import '../../../utils/screen_utils.dart';
import '../views/widgets/picker_date_utils.dart';

class AddTaskPageController extends GetxController {
  // 任务名称输入框控制器
  final TextEditingController taskNameController = TextEditingController();

  // 提醒时间
  var reminderTime = ''.obs;
  var tempTime = '';

  // 是否紧急 (null表示未选择, true表示是, false表示否)
  final isUrgent = Rx<bool?>(null);

  // 选中的案件信息
  final selectedCase = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    taskNameController.dispose();
    super.onClose();
  }

  /// 选择提醒时间
  void selectReminderTime() {
    tempTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 24.toR,
      isSetBottomInset: false,
      contentWidget: NoticeDateChoose(
        clickItem: (type) {
          if (type == 0) {
            tempTime = '';
          }
          if (type == 1) {
            reminderTime.value = tempTime;
          }
        },
        onChange: (time) {
          tempTime = time;
        },
      ),
    );
  }

  /// 选择案件
  void selectCase() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      backgroundColor: Colors.transparent,
      contentWidget: ChooseCaseAlert(),
    );
  }

  void setTestData(){
    // 临时示例数据
    selectedCase.value = {
      'title': '张三诉讼李四合同纠纷案',
      'caseNumber': '2023粤0105民初1234号',
      'parties': '张三(原告) 李四(被告)',
      'pendingTasks': 4,
      'urgent': 1,
      'participants': ['周垣君', '何艳丽', '赵彪', '郑一璇'],
    };
  }

  /// 保存任务
  void saveTask() {
    // 验证必填项
    if (taskNameController.text.trim().isEmpty) {
      showToast('请输入任务名称');
      return;
    }

    if (taskNameController.text.trim().length < 4 ||
        taskNameController.text.trim().length > 20) {
      showToast('任务名称请控制在4-20个字符');
      return;
    }

    if (reminderTime.value.isEmpty) {
      showToast('请选择提醒时间');
      return;
    }

    if (selectedCase.value == null) {
      showToast('请选择关联案件');
      return;
    }

    // TODO: 调用API保存任务
    // 保存成功后返回
    Get.snackbar('成功', '任务保存成功');
    Get.back();
  }
}
