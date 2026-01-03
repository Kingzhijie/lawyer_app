import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/addTaskPage/views/widgets/choose_case_alert.dart';
import 'package:lawyer_app/app/modules/addTaskPage/views/widgets/notice_date_choose.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../../http/net/tool/logger.dart';
import '../../../utils/screen_utils.dart';
import '../../casePage/models/case_base_info_model.dart';
import '../views/widgets/picker_date_utils.dart';

class AddTaskPageController extends GetxController {
  // 任务名称输入框控制器
  final TextEditingController taskNameController = TextEditingController();

  // 提醒时间
  var reminderTime = ''.obs;
  var tempTime = '';

  // 是否紧急 (null表示未选择, true表示是, false表示否)
  final isUrgent = Rx<bool?>(null);

  var selectModel = Rx<CaseBaseInfoModel?>(null);

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
      contentWidget: ChooseCaseAlert(chooseCaseCallBack: (model) {
        selectModel.value = model;
      }),
    );
  }

  /// 保存任务
  void saveTask() {
    // 验证必填项
    if (taskNameController.text
        .trim()
        .isEmpty) {
      showToast('请输入任务名称');
      return;
    }

    if (taskNameController.text
        .trim()
        .length < 4 ||
        taskNameController.text
            .trim()
            .length > 20) {
      showToast('任务名称请控制在4-20个字符');
      return;
    }

    if (reminderTime.value.isEmpty) {
      showToast('请选择提醒时间');
      return;
    }

    if (selectModel.value == null) {
      showToast('请选择关联案件');
      return;
    }


    NetUtils.post(Apis.createCaseTask, params: {
      'title': taskNameController.text.trim(),
      'isEmergency': isUrgent.value,
      'remindTimes': DateTime.parse(reminderTime.value).millisecondsSinceEpoch,
      'caseId': selectModel.value?.id
    }).then((result){
      if (result.code == NetCodeHandle.success) {
        showToast('添加任务成功');
        Get.back();
      }
    });

    // TODO: 调用API保存任务
    // 保存成功后返回
    Get.snackbar('成功', '任务保存成功');
    Get.back();
  }
}
