import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/dialog.dart';
import 'package:lawyer_app/app/config/app_config.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_party_model.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/device_calendar_util.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../http/apis.dart';
import '../../../http/net/net_utils.dart';
import '../../../http/net/tool/error_handle.dart';
import '../../../utils/object_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/toast_utils.dart';
import '../../addTaskPage/views/widgets/choose_concerned_person_alert.dart';
import '../../newHomePage/models/case_task_model.dart';
import '../../newHomePage/views/widgets/add_case_remark_widget.dart';
import '../../newHomePage/views/widgets/create_case_widget.dart';

class AgencyCenterPageController extends GetxController {
  final int? caseId;
  AgencyCenterPageController({this.caseId});

  /// 顶部筛选 tab 下标：0 全部、1 紧急任务、2 今日到期, 3. 已逾期
  final RxInt tabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  int pageNo = 1;

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final caseTaskList = RxList<CaseTaskModel>([]);
  List<CasePartyModel> casePartyList = <CasePartyModel>[];

  var taskTypeModel = Rx<ChooseTypeModel?>(null);
  var casePartyIdModel = Rx<ChooseTypeModel?>(null);
  //任务类型（1行程任务 2诉讼缴费 3开庭 4提交证据 5质证意见 6答辩状 7举证 8保全裁定 9保全 10判决上诉 11非诉任务 12判决生效）

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    var index = 0;
    if (arguments is Map) {
      index = arguments['index'] ?? 0;
    } else {
      index = arguments ?? 0;
    }
    if (index > 0) {
      tabIndex.value = index;
    }
  }

  @override
  void onReady() {
    super.onReady();
    getCaseListData(true);
    getCasePartyList();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getCasePartyList() async {
    var result = await NetUtils.get(Apis.casePartyList, isLoading: false);
    if (result.code == NetCodeHandle.success) {
      casePartyList = (result.data['list'] as List)
          .map((e) => CasePartyModel.fromJson(e))
          .toList();
    }
  }

  ///获取数据
  Future<void> getCaseListData(bool isRefresh) async {
    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      'tabStatus': tabIndex.value,
      'taskType': taskTypeModel.value?.id,
      'caseId': caseId,
      if (casePartyIdModel.value != null)
        'partyIds': [casePartyIdModel.value!.id],
    };
    var result = await NetUtils.get(
      Apis.getTaskPage,
      isLoading: false,
      queryParameters: parameters,
    );
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => CaseTaskModel.fromJson(e))
          .toList();
      if (isRefresh) {
        caseTaskList.value = list;
        finishRefresh();
      } else {
        caseTaskList.value.addAll(list);
      }
      bool isNoMore = caseTaskList.length >= result.data['total'];
      delay(500, () {
        finishLoad(isNoMore);
      });
    } else {
      finishRefresh();
      finishLoad(true);
    }
  }

  void onRefresh() {
    pageNo = 1;
    getCaseListData(true);
  }

  void onLoadMore() {
    pageNo += 1;
    getCaseListData(false);
  }

  /// 下拉刷新完成
  void finishRefresh() {
    easyRefreshController.finishRefresh();
    easyRefreshController.resetFooter();
  }

  /// 上拉加载完成
  void finishLoad(bool isLast) {
    if (isLast) {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    } else {
      easyRefreshController.finishLoad();
    }
  }

  void switchTab(int index) {
    tabIndex.value = index;
    getCaseListData(true);
  }

  ///添加备注
  void addRemarkMethod(CaseTaskModel model) {
    textEditingController.text = '';
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toW,
      contentWidget: AddCaseRemarkWidget(
        sendAction: (text) {
          // FocusManager.instance.primaryFocus?.unfocus();
          Navigator.pop(currentContext);
          setTaskRemark(text, model);
        },
        textEditingController: textEditingController,
      ),
    );
  }

  void linkUserAlert() {
    final userModel =
        getFindController<NewHomePageController>()?.userModel.value;
    if (userModel == null) {
      return;
    }

    if (userModel.hasTeamOffice == false) {
      Get.toNamed(Routes.VIP_CENTER_PAGE);
      return;
    }

    ///
    BottomSheetUtils.show(
      currentContext,
      radius: 12.toW,
      isShowCloseIcon: true,
      height: AppScreenUtil.screenHeight - 217.toW,
      isSetBottomInset: false,
      contentWidget: LinkUserWidget(),
    );
  }

  ///添加任务
  void addTaskAction() {
    Get.toNamed(Routes.ADD_TASK_PAGE);
  }

  ///添加日历提醒
  Future<void> addCalendar(CaseTaskModel model) async {
    final time = DateTimeUtils.formatTimestamp(model.remindTimes ?? 0);
    logPrint('toime = $time');
    String? eventId;
    if (model.remindTimes != null && model.remindTimes != 0) {
      if (ObjectUtils.boolValue(model.isAddCalendar)) {
        if (model.addCalendarId != null) {
          bool isSuc = await DeviceCalendarUtil.deleteEvent(
            eventId: model.addCalendarId!,
          );
          logPrint('提醒删除结果===$isSuc');
        }
      } else {
        // 静默添加提醒（不跳转系统日历）
        eventId = await DeviceCalendarUtil.addReminder(
          title: model.title ?? '案件提醒',
          dateTime: DateTime.fromMillisecondsSinceEpoch(
            model.remindTimes!.toInt(),
          ),
          description: '点击连接: ${AppConfig.appSchemeFull}\n${model.content}',
          reminderMinutes: 120, // 提前2小时提醒
        );
        if (eventId != null) {
          AppDialog.singleItem(
            title: '添加日历提醒成功',
            titleStyle: TextStyle(
              color: Colors.black,
              fontSize: 17.toSp,
              fontWeight: FontWeight.w600,
            ),
            content: '事件开始前2小时, 将收到手机日历提醒, 可在系统日历中更改提醒时间',
            contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
            cancel: '我知道了',
          ).showAlert();
        }
      }
    }

    NetUtils.post(
      Apis.taskAddCalendar,
      params: {
        'addCalendar': !ObjectUtils.boolValue(model.isAddCalendar),
        'id': model.id,
        'addCalendarId': eventId,
      },
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        model.isAddCalendar = !ObjectUtils.boolValue(model.isAddCalendar);
        model.addCalendarId = eventId;
        caseTaskList.refresh();
      }
    });
  }

  ///设置备注
  void setTaskRemark(String text, CaseTaskModel model) {
    if (text.isEmpty) {
      showToast('请输入备注');
      return;
    }
    NetUtils.post(
      Apis.setTaskRemark,
      params: {'content': text, 'id': model.id},
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        showToast('备注添加成功');
        getCaseListData(true);
      }
    });
  }

  /// 更新任务状态
  void updateTaskStatus(CaseTaskModel model) {
    NetUtils.put(
      Apis.updateTaskStatus,
      params: {'title': model.title, 'id': model.id, 'status': 1},
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        reloadTaskUI(model);
      }
    });
  }

  /// 删除任务
  void deleteTask(CaseTaskModel model) {
    AppDialog.doubleItem(
      title: '温馨提示',
      titleStyle: TextStyle(
        color: Colors.black,
        fontSize: 17.toSp,
        fontWeight: FontWeight.w600,
      ),
      content: '是否确认删除当前任务？',
      contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
      cancel: '取消',
      confirm: '确认删除',
      onConfirm: () {
        onConfirmDeleteTask(model);
      },
    ).showAlert();
  }

  void onConfirmDeleteTask(CaseTaskModel model) {
    NetUtils.delete(Apis.deleteTask, queryParameters: {'id': model.id}).then((result) {
      if (result.code == NetCodeHandle.success) {
        reloadTaskUI(model);
      }
    });
  }

  void reloadTaskUI(CaseTaskModel model) {
    caseTaskList.remove(model);
    getFindController<NewHomePageController>()?.onRefresh();
  }

  void chooseConcernedAction(int type) {
    var title = '';
    List<ChooseTypeModel> models = [];
    if (type == 0) {
      for (var item in casePartyList) {
        models.add(ChooseTypeModel(name: item.name, id: item.id));
      }
      title = '选择当事人';
    } else if (type == 1) {
      models = [
        ChooseTypeModel(name: '行程任务', id: 1),
        ChooseTypeModel(name: '诉讼缴费', id: 2),
        ChooseTypeModel(name: '开庭', id: 3),
        ChooseTypeModel(name: '提交证据', id: 4),
        ChooseTypeModel(name: '质证意见', id: 5),
        ChooseTypeModel(name: '答辩状', id: 6),
        ChooseTypeModel(name: '举证', id: 7),
        ChooseTypeModel(name: '保全裁定', id: 8),
        ChooseTypeModel(name: '保全', id: 9),
        ChooseTypeModel(name: '判决上诉', id: 10),
        ChooseTypeModel(name: '非诉任务', id: 11),
        ChooseTypeModel(name: '判决生效', id: 12),
      ];
      title = '任务类型';
    }

    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      backgroundColor: Colors.transparent,
      contentWidget: ChooseConcernedPersonAlert(
        models: models,
        title: title,
        chooseAction: (model) {
          if (type == 0) {
            casePartyIdModel.value = model;
          } else {
            taskTypeModel.value = model;
          }
          getCaseListData(true);
        },
      ),
    );
  }

  ///查看合同详情
  void lookContractDetailPage(num? caseId) {
    Get.toNamed(Routes.CONTRACT_DETAIL_PAGE, arguments: caseId);
  }
}
