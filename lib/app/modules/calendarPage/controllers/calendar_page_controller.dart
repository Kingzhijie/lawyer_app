import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/newHomePage/models/case_task_model.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../newHomePage/views/widgets/add_case_remark_widget.dart';

class CalendarPageController extends GetxController {
  late final AdvancedCalendarController calendarController;
  final TextEditingController textEditingController = TextEditingController();

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// 当前显示的月份（用于底部大数字显示）
  final Rx<DateTime> currentDisplayMonth = DateTime.now().obs;
  final RxBool isCalendarExpanded = true.obs;
  final RxList<DateTime> eventDates = <DateTime>[].obs;
  List<CaseTaskModel> monthsTodoTaskList = [];
  final RxList<CaseTaskModel> todoTaskList = <CaseTaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    calendarController = AdvancedCalendarController.today();
    calendarController.addListener(_onCalendarChanged);
    getTaskList();
  }

  Future<void> getTaskList({
    bool isClickCalendar = false,
    bool isOnlyShowEventDates = false,
  }) async {
    NetUtils.post(
      Apis.todoCaseList,
      params: {
        'dueAtStart': DateTime(
          currentDisplayMonth.value.year,
          currentDisplayMonth.value.month,
          01,
        ).toString().replaceAll('.000', ''),
        'dueAtEnd': DateTime(
          currentDisplayMonth.value.year,
          currentDisplayMonth.value.month,
          currentDisplayMonth.value.daysInMonth(),
        ).toString().replaceAll('.000', ''),
      },
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        monthsTodoTaskList = (result.data as List)
            .map((e) => CaseTaskModel.fromJson(e))
            .toList();
        List<DateTime> dates = [];
        var taskList = monthsTodoTaskList.where((item) {
          final dueAt = DateTime.fromMillisecondsSinceEpoch(
            (item.dueAt ?? 0).toInt(),
          );
          final isMonth = dueAt.isMonth(currentDisplayMonth.value);
          if (isMonth) {
            dates.add(DateTime(dueAt.year, dueAt.month, dueAt.day));
          }
          final isDay = dueAt.isDay(currentDisplayMonth.value);
          return isDay;
        }).toList();
        if (!isOnlyShowEventDates) {
          taskList.sort(
            (a, b) => (a.createTime ?? 0).compareTo((b.createTime ?? 0)),
          );
          if (isClickCalendar) {
            debugPrint('点击了日历上不同月份的，');
            todoTaskList.addAll(taskList);
            eventDates.addAll(dates);
          } else {
            debugPrint('正常月份');
            todoTaskList.assignAll(taskList);
            eventDates.assignAll(dates);
          }
        }
      }
    });
  }

  @override
  void onClose() {
    calendarController.removeListener(_onCalendarChanged);
    calendarController.dispose();
    super.onClose();
  }

  void _onCalendarChanged() async {
    selectedDate.value = calendarController.value;
    if (currentDisplayMonth.value.year != selectedDate.value.year ||
        currentDisplayMonth.value.month != selectedDate.value.month) {
      currentDisplayMonth.value = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
      );
      await getTaskList(isClickCalendar: true);
    }
    if (selectedDate.value.month == currentDisplayMonth.value.month) {
      var taskList = monthsTodoTaskList.where((item) {
        final dueAt = DateTime.fromMillisecondsSinceEpoch(
          (item.dueAt ?? 0).toInt(),
        );
        final isDay = dueAt.isDay(selectedDate.value);
        return isDay;
      }).toList();
      taskList.sort(
        (a, b) => (a.createTime ?? 0).compareTo((b.createTime ?? 0)),
      );
      todoTaskList.value = taskList;
    }
  }

  /// 处理日历水平滚动（月份切换）
  void onMonthChanged(DateTime monthDate) {
    currentDisplayMonth.value = DateTime(
      monthDate.year,
      monthDate.month,
      selectedDate.value.day,
    );
    getTaskList(isOnlyShowEventDates: true);
  }

  /// 判断日期是否有事件
  bool hasEvent(DateTime date) {
    return eventDates.any(
      (eventDate) =>
          eventDate.year == date.year &&
          eventDate.month == date.month &&
          eventDate.day == date.day,
    );
  }

  /// 切换日历展开/收起状态
  void toggleCalendarExpanded() {
    isCalendarExpanded.value = !isCalendarExpanded.value;
  }

  ///搜索
  void searchAction() {
    Get.toNamed(Routes.SEARCH_CASE_PAGE);
  }

  void addRemarkAction(CaseTaskModel model) {
    textEditingController.text = '';
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toW,
      contentWidget: AddCaseRemarkWidget(
        sendAction: (text) => setTaskRemark(text, model),
        textEditingController: textEditingController,
      ),
    );
  }

  ///设置备注
  void setTaskRemark(String text, CaseTaskModel model) {
    NetUtils.post(
      Apis.setTaskRemark,
      params: {'content': text, 'id': model.id},
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        showToast('备注添加成功');
        Navigator.pop(currentContext);
      }
    });
  }
}
