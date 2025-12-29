import 'package:flutter/material.dart';
import 'package:flutter_advanced_calendar/flutter_advanced_calendar.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/calendarPage/views/widgets/today_wait_work_widget.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/calendar_page_controller.dart';

class CalendarPageView extends GetView<CalendarPageController> {
  const CalendarPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(isShowLeading: false, leadingWidth: 200,leftActionWidget: Container(
        padding: EdgeInsets.only(left: 10.toW),
        child: Obx((){
          // 通过访问 selectedDate 来触发更新，然后获取当前月份
          final date = controller.currentDisplayMonth.value;
          return Row(
            children: [
              // Icon(Icons.arrow_back_ios, size: 22.toW, color: Colors.black).withMarginOnly(left: 6.toW),
              Width(10.toW),
              Text('${date.year}年${date.month}月', style: TextStyle(color: Colors.black, fontSize: 17.toSp, fontWeight: FontWeight.w600))
            ],
          );
        }).withOnTap((){
          Get.back();
        }),
      )),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 12.toW, bottom: AppScreenUtil.bottomBarHeight + 50.toW),
        child: Column(children: [_buildCalendarSection(), _buildTodoList()]),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      color: AppColors.color_white,
      padding: EdgeInsets.symmetric(horizontal: 6.toW),
      child: _buildExpandedCalendar(),
    );
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
              fontSize: 20.toSp,
              fontWeight: FontWeight.w600,
              color: AppColors.color_E6000000,
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.color_FFF3F3F3,
              borderRadius: BorderRadius.circular(16.toW)
            ),
            width: 120.toW,
            height: 32.toW,
            padding: EdgeInsets.symmetric(horizontal: 16.toW),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('搜索', style: TextStyle(color: AppColors.color_42000000, fontSize: 14.toSp),),
                ImageUtils(
                  imageUrl: Assets.home.searchIcon.path,
                  width: 16.toW,
                  height: 16.toW,
                ),
              ],
            ),
          ).withOnTap((){
            controller.searchAction();
          })
        ],
      ),
    );
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
        bottom: 40.toW,
      ),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TodayWaitWorkWidget(task: tasks[index], addRemarkAction: (){
          controller.addRemarkAction();
        },);
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
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
