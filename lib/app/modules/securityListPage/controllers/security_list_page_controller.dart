import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/config/app_config.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/securityListPage/models/assets_tab_count_model.dart';
import 'package:lawyer_app/app/modules/securityListPage/models/security_item_model.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/device_calendar_util.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

class SecurityListPageController extends GetxController {
  /// 当前选中的标签索引
  final selectedTabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  var assetsTabCountModel = Rx<AssetsTabCountModel?>(null);
  int pageNo = 1;

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 案件列表
  final securityList = <SecurityItemModel>[].obs;
  String keyword = '';

  @override
  void onInit() {
    super.onInit();
    getAssetTabCount();
    onRefresh();
  }

  void getAssetTabCount() {
    NetUtils.get(Apis.preservationAssetTabCount, isLoading: false).then((
      result,
    ) {
      if (result.code == NetCodeHandle.success) {
        assetsTabCountModel.value = AssetsTabCountModel.fromJson(result.data);
      }
    });
  }

  ///获取数据
  Future<void> getCaseListData(bool isRefresh) async {
    int? expiryDays;
    if (selectedTabIndex.value == 1) {
      expiryDays = 60;
    } else if (selectedTabIndex.value == 2) {
      expiryDays = 45;
    } else if (selectedTabIndex.value == 3) {
      expiryDays = 30;
    }

    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      if (keyword.isNotEmpty) 'keyword': keyword,
      if (expiryDays != null) 'expiryDays': expiryDays,
    };
    var result = await NetUtils.get(
      Apis.preservationAssetList,
      isLoading: false,
      queryParameters: parameters,
    );
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => SecurityItemModel.fromJson(e))
          .toList();
      if (isRefresh) {
        securityList.value = list;
        finishRefresh();
      } else {
        securityList.value.addAll(list);
      }
      bool isNoMore = securityList.length >= result.data['total'];
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 选择标签
  void selectTab(int index) {
    selectedTabIndex.value = index;
    onRefresh();
  }

  /// 搜索
  void searchAction() {
    keyword = textEditingController.text;
    onRefresh();
  }

  /// 提醒操作
  void remindAction(SecurityItemModel item) async {
    if (ObjectUtils.boolValue(item.isAddCalendar)) {
      return;
    }

    // 静默添加提醒（不跳转系统日历）
    final eventId = await DeviceCalendarUtil.addReminder(
      title: item.caseName ?? '案件提醒',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        item.nearestExpiryDate!.toInt(),
      ),
      description: '点击连接: ${AppConfig.appSchemeFull}\n${item.caseName}最近到期了',
      reminderMinutes: 120, // 提前2小时提醒
    );
    if (eventId != null) {
      NetUtils.post(
        Apis.addCalendarPreservationAsset,
        params: {
          'caseId': item.caseId,
          'addCalendar': !ObjectUtils.boolValue(item.isAddCalendar),
          'addCalendarId': eventId,
        },
      ).then((result) {
        if (result.code == NetCodeHandle.success) {
          item.isAddCalendar = !ObjectUtils.boolValue(item.isAddCalendar);
          securityList.refresh();
          showToast('已添加提醒');
        }
      });
    }
  }

  void pushDetailPage(SecurityItemModel item) {
    Get.toNamed(Routes.SECURITY_LIST_DETAIL_PAGE, arguments: item.caseId);
  }
}
