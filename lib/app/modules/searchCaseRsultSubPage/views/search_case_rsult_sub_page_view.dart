import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../calendarPage/views/widgets/today_wait_work_widget.dart';
import '../controllers/search_case_rsult_sub_page_controller.dart';

class SearchCaseRsultSubPageView
    extends GetView<SearchCaseRsultSubPageController> {
  final int? type;
  const SearchCaseRsultSubPageView({super.key, this.type});
  @override
  Widget build(BuildContext context) {
    final tasks = _getTasksForDate();
    return Container(
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 16.toW,
        top: 10.toW,
        bottom: AppScreenUtil.bottomBarHeight + 10.toW,
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return SizedBox();
          // return TodayWaitWorkWidget(task: tasks[index], isShowTime: false);
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getTasksForDate() {
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
}
