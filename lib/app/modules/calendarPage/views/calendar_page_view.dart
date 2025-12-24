import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/calendar_page_controller.dart';

class CalendarPageView extends GetView<CalendarPageController> {
  const CalendarPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color_white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [_buildCalendarSection(), _buildTodoList()]),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Obx(() {
      final isExpanded = controller.isCalendarExpanded.value;
      final selectedDate = controller.selectedDate.value;

      return Container(
        color: AppColors.color_white,
        padding: EdgeInsets.symmetric(horizontal: 6.toW),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMonthHeader(),
            // 展开时显示完整日历
            _buildExpandedCalendar(),
          ],
        ),
      );
    });
  }

  Widget _buildMonthHeader() {
    return Obx(() {
      // 通过访问 selectedDate 来触发更新，然后获取当前月份
      final _ = controller.selectedDate.value;
      final month = controller.currentMonth;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.toW),
        child: Row(
          children: [
            // 左箭头
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.chevron_left,
                size: 24.toW,
                color: AppColors.color_66000000,
              ),
            ),
            SizedBox(width: 4.toW),
            // 年月显示
            Text(
              '${month.year}年${month.month}月',
              style: TextStyle(
                fontSize: 16.toSp,
                fontWeight: FontWeight.w600,
                color: AppColors.color_E6000000,
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    });
  }

  Widget _buildExpandedCalendar() {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: AppColors.theme,
        highlightColor: AppColors.theme,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: TextStyle(
                fontSize: 14.toSp,
                color: const Color(0x42000000), // 星期标签颜色
              ),
              bodyMedium: TextStyle(
                fontSize: 12.toSp,
                color: AppColors.color_99000000,
              ),
              titleMedium: TextStyle(
                fontSize: 16.toSp,
                color: Colors.transparent, // 隐藏 Today 文本
              ),
            ),
      ),
      child: Stack(
        children: [
          // 底部大的月份数字
          Obx(() {
            final month = controller.currentDisplayMonth.value;
            return Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Text(
                    '${month.month}',
                    style: TextStyle(
                      fontSize: 132.toSp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFECF2FE), // 半透明黑色，更淡一些
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            );
          }),
          Obx(() {
            // 通过访问可观察变量来触发更新
            final _ = controller.selectedDate.value;
            final events = controller.eventDates;
            return AdvancedCalendar(
              controller: controller.calendarController,
              weekLineHeight: 50.toW,
              startWeekDay: 0, // 周日开始
              events: events, // 显示事件点
              innerDot: true, // 显示小点
              onHorizontalDrag: controller.onMonthChanged, // 监听月份切换
              headerStyle: TextStyle(
                fontSize: 0.toSp, // 隐藏默认header（我们自定义了）
              ),
              todayStyle: TextStyle(
                fontSize: 0.toSp, // 隐藏Today按钮
              ),
              calendarTextStyle: TextStyle(
                fontSize: 16.toSp,
                fontWeight: FontWeight.normal,
                color: AppColors.color_E6000000,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTodoHeader(),
        Obx(() {
          final selectedDate = controller.selectedDate.value;
          return _buildTodoItems(selectedDate);
        }),
      ],
    );
  }

  Widget _buildTodoHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 12.toW),
      child: Row(
        children: [
          Text(
            '今日待办',
            style: TextStyle(
              fontSize: 17.toSp,
              fontWeight: FontWeight.w700,
              color: AppColors.color_E6000000,
            ),
          ),
          const Spacer(),
          // 搜索图标
          ImageUtils(
            imageUrl: Assets.home.searchIcon.path,
            width: 18.toW,
            height: 18.toW,
          ),
          SizedBox(width: 16.toW),
          // 日期选择器
          Obx(
            () => GestureDetector(
              onTap: () => _showDatePicker(),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.toW,
                  vertical: 6.toW,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.color_FFC5C5C5, width: 1),
                  borderRadius: BorderRadius.circular(4.toW),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDate(controller.selectedDate.value),
                      style: TextStyle(
                        fontSize: 13.toSp,
                        color: AppColors.color_E6000000,
                      ),
                    ),
                    SizedBox(width: 4.toW),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.toW,
                      color: AppColors.color_66000000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    final result = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (result != null) {
      controller.selectDate(result);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  Widget _buildTodoItems(DateTime date) {
    final tasks = _getTasksForDate(date);

    if (tasks.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(40.toW),
        child: Center(
          child: Text(
            '暂无待办事项',
            style: TextStyle(
              fontSize: 14.toSp,
              color: AppColors.color_FFC5C5C5,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 16.toW,
        top: 8.toW,
        bottom: 40.toW,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTodoItemWithTimeline(
          tasks[index],
          index == tasks.length - 1,
        );
      },
    );
  }

  Widget _buildTodoItemWithTimeline(Map<String, dynamic> task, bool isLast) {
    final bool isPlaintiff = task['role'] == '原告';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧时间和时间轴
          SizedBox(
            width: 50.toW,
            child: Column(
              children: [
                Text(
                  task['time'],
                  style: TextStyle(
                    fontSize: 14.toSp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 8.toW),
                // 时间轴竖线
                Expanded(
                  child: Container(
                    width: 1.toW,
                    color: AppColors.color_FFC5C5C5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.toW),
          // 右侧卡片
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.toW),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.color_white,
                borderRadius: BorderRadius.circular(12.toW),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x0A000000),
                    blurRadius: 14,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 右侧渐变色块
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 60.toW,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: isPlaintiff
                              ? [
                                  Colors.white.withValues(alpha: 0),
                                  const Color(0xFFFFE4E4),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0),
                                  const Color(0xFFE4F7EF),
                                ],
                        ),
                      ),
                    ),
                  ),
                  // 右上角角标
                  Positioned(
                    right: -20.toW,
                    top: 10.toW,
                    child: Transform.rotate(
                      angle: 0.785398, // 45度
                      child: Container(
                        width: 70.toW,
                        padding: EdgeInsets.symmetric(vertical: 2.toW),
                        color: isPlaintiff
                            ? const Color(0xFFFF6B6B)
                            : const Color(0xFF4ECDC4),
                        child: Center(
                          child: Text(
                            isPlaintiff ? '原告' : '被告',
                            style: TextStyle(
                              fontSize: 10.toSp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 卡片内容
                  Padding(
                    padding: EdgeInsets.all(14.toW),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImageUtils(
                              imageUrl: task['icon'],
                              width: 20.toW,
                              height: 20.toW,
                            ),
                            SizedBox(width: 8.toW),
                            Text(
                              task['title'],
                              style: TextStyle(
                                fontSize: 15.toSp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.color_E6000000,
                              ),
                            ),
                            if (task['isUrgent'] == true) ...[
                              SizedBox(width: 6.toW),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.toW,
                                  vertical: 2.toW,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDECEE),
                                  borderRadius: BorderRadius.circular(4.toW),
                                ),
                                child: Text(
                                  '紧急',
                                  style: TextStyle(
                                    fontSize: 10.toSp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFE34D59),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 12.toW),
                        _infoRow('案件：', task['case']),
                        SizedBox(height: 6.toW),
                        _infoRow('截止：', task['deadline']),
                        SizedBox(height: 6.toW),
                        _infoRow('承办人（法官）', task['handler']),
                        SizedBox(height: 6.toW),
                        _infoRow('电话：', task['phone']),
                        SizedBox(height: 12.toW),
                        _smallButton('备注'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.toSp, color: AppColors.color_66000000),
        ),
        SizedBox(width: 4.toW),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ),
      ],
    );
  }

  Widget _smallButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.toW, vertical: 6.toW),
      decoration: BoxDecoration(
        color: AppColors.color_FFEEEEEE,
        borderRadius: BorderRadius.circular(6.toW),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.toSp, color: AppColors.color_E6000000),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    final daysFromSunday = weekday == 7 ? 0 : weekday;
    return date.subtract(Duration(days: daysFromSunday));
  }

  List<Map<String, dynamic>> _getTasksForDate(DateTime date) {
    if (_isToday(date)) {
      return [
        {
          'time': '9:00',
          'icon': Assets.home.anjianZongs.path,
          'title': '缴纳诉讼费',
          'isUrgent': true,
          'role': '原告',
          'case': '张三诉讼李四合同纠纷案',
          'deadline': '2025-12-31',
          'handler': '李世斌',
          'phone': '13759200942',
        },
        {
          'time': '11:00',
          'icon': Assets.home.bqqdIcon.path,
          'title': '催促保全结果',
          'isUrgent': true,
          'role': '被告',
          'case': '张三诉讼李四合同纠纷案',
          'deadline': '2025-12-31',
          'handler': '李世斌',
          'phone': '13759200942',
        },
        {
          'time': '13:30',
          'icon': Assets.home.anjianZongs.path,
          'title': '第一次开庭',
          'isUrgent': false,
          'role': '原告',
          'case': '张三诉讼李四合同纠纷案',
          'deadline': '2025-12-31',
          'handler': '李世斌',
          'phone': '13759200942',
        },
      ];
    }
    return [];
  }
}
