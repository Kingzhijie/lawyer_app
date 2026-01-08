import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/easy_refresher.dart';
import 'package:lawyer_app/app/common/components/empty_content_widget.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../calendarPage/views/widgets/today_wait_work_widget.dart';
import '../controllers/search_case_rsult_sub_page_controller.dart';

class SearchCaseRsultSubPageView
    extends GetView<SearchCaseRsultSubPageController> {
  final String? tagName;
  const SearchCaseRsultSubPageView({super.key, this.tagName});
  @override
  Widget build(BuildContext context) {
    final vc = getFindController<SearchCaseRsultSubPageController>(
      tag: tagName,
    );
    return Container(
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 16.toW,
        top: 10.toW,
        bottom: AppScreenUtil.bottomBarHeight + 10.toW,
      ),
      child: MSEasyRefresher(
        controller: vc!.easyRefreshController,
        onRefresh: () {
          vc.onRefresh();
        },
        onLoad: () {
          vc.onLoadMore();
        },
        childBuilder: (context, physics) {
          return Obx(
            () => vc.caseTaskList.value.isEmpty
                ? EmptyContentWidget()
                : ListView.builder(
                    itemCount: vc.caseTaskList.value.length,
                    physics: physics,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final task = vc.caseTaskList[index];
                      return TodayWaitWorkWidget(
                        task: task,
                        isShowTime: false,
                        addRemarkAction: () => vc.addRemarkAction(task),
                      ).withOnTap(() => vc.onContractDetail(task.caseId));
                    },
                  ),
          );
        },
      ),
    );
  }
}
