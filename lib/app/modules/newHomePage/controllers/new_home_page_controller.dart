import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/extension/string_extension.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/myPage/controllers/my_page_controller.dart';
import 'package:lawyer_app/app/modules/myPage/models/user_model.dart';
import 'package:lawyer_app/app/modules/myPage/views/my_page_view.dart';
import 'package:lawyer_app/app/modules/newHomePage/models/home_statistics.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/add_case_remark_widget.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../../common/components/bottom_sheet_content_widget.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../common/components/dialog.dart';
import '../../../common/constants/app_colors.dart';
import '../../../config/app_config.dart';
import '../../../utils/device_calendar_util.dart';
import '../../../utils/screen_utils.dart';
import '../models/case_task_model.dart';
import '../views/widgets/cooperation_person_widget.dart';
import '../views/widgets/create_case_widget.dart';

class NewHomePageController extends GetxController {
  /// 顶部筛选 tab 下标：0 我的待办、1 我参与的、2 已逾期
  final RxInt tabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  ///用户信息
  var userModel = Rx<UserModel?>(null);

  ///首页数据看板
  var homeStatistics = Rx<HomeStatistics?>(null);

  int pageNo = 1;

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final caseTaskList = RxList<CaseTaskModel>([]);

  void switchTab(int index) {
    tabIndex.value = index;
    getCaseListData(true);
  }

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    loadHomeStatistics();
    getCaseListData(true);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void lookCalendarCaseAction() {
    getFindController<TabPageController>()?.changeIndex(2);
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

  void linkUserAlert(CaseTaskModel model) {
    if (userModel.value == null) {
      return;
    }

    if (userModel.value!.hasTeamOffice == false) {
      Get.toNamed(Routes.VIP_CENTER_PAGE);
      return;
    }

    BottomSheetUtils.show(
      currentContext,
      radius: 12.toW,
      isShowCloseIcon: true,
      height: AppScreenUtil.screenHeight - 217.toW,
      isSetBottomInset: false,
      contentWidget: LinkUserWidget(
        manageId: model.id!,
        relevanceSuccess: (m) {
          getCaseListData(true);
        },
      ),
    );
  }

  void searchCaseAction() {
    Get.toNamed(Routes.SEARCH_CASE_PAGE);
  }

  /// 打开我的页面底部抽屉
  void openMyPageDrawer() {
    getFindController<TabPageController>()?.openDrawer();
  }

  ///查看合同详情
  void lookContractDetailPage(num? caseId) {
    Get.toNamed(Routes.CONTRACT_DETAIL_PAGE, arguments: caseId);
  }

  ///获取用户信息
  void getUserInfo() {
    NetUtils.get(Apis.getUserInfo, isLoading: false).then((result) {
      if (result.code == NetCodeHandle.success) {
        userModel.value = UserModel.fromJson(result.data);
      }
    });
  }

  ///加载首页数据看板
  void loadHomeStatistics() {
    //1: 本周, 2: 本月
    NetUtils.get(
      Apis.homeStatistics,
      queryParameters: {'cycle': 1},
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        homeStatistics.value = HomeStatistics.fromJson(result.data ?? {});
        getTaskCount();
      }
    });
  }

  ///加载首页数据看板
  void getTaskCount() {
    NetUtils.get(Apis.getTaskCount, isLoading: false).then((result) {
      if (result.code == NetCodeHandle.success) {
        if (result.data != null) {
          homeStatistics.value?.yuqiTaskCount = result.data['2']
              .toString()
              .toInt();
          homeStatistics.value?.myjoinTaskCount = result.data['1']
              .toString()
              .toInt();
          homeStatistics.value?.wddbCount = result.data['0'].toString().toInt();
          homeStatistics.refresh();
        }
      }
    });
  }

  ///获取数据
  Future<void> getCaseListData(bool isRefresh) async {
    int? tabStatus;
    if (tabIndex.value == 0) {
      tabStatus = 0;
    } else if (tabIndex.value == 2) {
      tabStatus = 3;
    }

    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      'tabStatus': tabStatus,
    };
    if (tabIndex.value == 1) {
      parameters['isSponsor'] = false;
    }
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
    loadHomeStatistics();
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

  ///添加日历提醒
  Future<void> addCalendar(CaseTaskModel model) async {
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

  void chooseDateFilter() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toR,
      isSetBottomInset: false,
      backgroundColor: Colors.white,
      contentWidget: BottomSheetContentWidget(
        contentModels: [
          BottomSheetContentModel(
            name: '本周',
            index: 1,
            textColor: AppColors.color_E6000000,
          ),
          BottomSheetContentModel(
            name: '本月',
            index: 2,
            textColor: AppColors.color_E6000000,
          ),
        ],
        clickItemCallBack: (contentModel) async {},
      ),
    );
  }
}
