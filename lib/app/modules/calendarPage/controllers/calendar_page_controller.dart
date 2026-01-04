import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../newHomePage/views/widgets/add_case_remark_widget.dart';

class CalendarPageController extends GetxController {
  /// 日历控制器
  late final AdvancedCalendarController calendarController;
  final TextEditingController textEditingController = TextEditingController();

  /// 当前选中的日期
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// 当前显示的月份（用于底部大数字显示）
  final Rx<DateTime> currentDisplayMonth = DateTime.now().obs;

  /// 日历是否展开
  final RxBool isCalendarExpanded = false.obs; // 初始状态改为收起

  /// 有事件的日期列表（示例数据）
  /// 根据UI图，17、18（今日）、19、20有事件
  /// 使用固定日期，避免其他日期出现点
  final RxList<DateTime> eventDates = <DateTime>[
    // 只设置当前月份的具体日期，避免跨月问题
    // 这里需要根据实际当前日期动态计算
  ].obs;

  /// 初始化事件日期
  void _initEventDates() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // 只设置当前月份的17、18、19、20号
    eventDates.value = [
      DateTime(currentYear, currentMonth, 17),
      DateTime(currentYear, currentMonth, 18),
      DateTime(currentYear, currentMonth, 19),
      DateTime(currentYear, currentMonth, 24),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    _initEventDates();

    // 初始化日历控制器，设置为今天
    final today = DateTime.now();
    calendarController = AdvancedCalendarController.today();

    // 确保初始选中日期是今天
    selectedDate.value = today;
    currentDisplayMonth.value = DateTime(today.year, today.month, 1);

    calendarController.addListener(_onCalendarChanged);
  }

  @override
  void onClose() {
    calendarController.removeListener(_onCalendarChanged);
    calendarController.dispose();
    super.onClose();
  }

  void _onCalendarChanged() {
    selectedDate.value = calendarController.value;
    // 更新显示的月份（只更新年月，不更新日）
    final newMonth = calendarController.value;
    if (currentDisplayMonth.value.year != newMonth.year ||
        currentDisplayMonth.value.month != newMonth.month) {
      currentDisplayMonth.value = DateTime(newMonth.year, newMonth.month, 1);
    }
  }

  /// 处理日历水平滚动（月份切换）
  void onMonthChanged(DateTime monthDate) {
    // 更新显示的月份
    currentDisplayMonth.value = DateTime(monthDate.year, monthDate.month, 1);
  }

  /// 选择日期
  void selectDate(DateTime date) {
    calendarController.value = date;
    selectedDate.value = date;
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

  void addRemarkAction() {
    textEditingController.text = '';
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toW,
      contentWidget: AddCaseRemarkWidget(
        sendAction: (text) {},
        textEditingController: textEditingController,
      ),
    );
  }
}
