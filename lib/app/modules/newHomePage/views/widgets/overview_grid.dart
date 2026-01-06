import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

enum CaseTypeEnum {
  caseCount('案件总数', Color(0xFFECF2FE)), //案件总数
  agencyTask('待办任务', AppColors.color_FFFEF3E6), //代办任务
  urgentTask('紧急任务', AppColors.color_FFFDECEE), //紧急任务
  nonUrgentTask('非紧急任务', AppColors.color_FFE8F7F2), //非紧急任务
  securityList('保全清单', Color(0xFFEBEBF8)), //保全清单
  abnormal('异常', AppColors.color_FFFFEDEF); //异常

  const CaseTypeEnum(this.name, this.bgColor);
  final String name;
  final Color bgColor;
}

class OverviewGrid extends StatelessWidget {
  final NewHomePageController homePageController;
  const OverviewGrid({super.key, required this.homePageController});

  @override
  Widget build(BuildContext context) {
    final double cardWidth =
        (AppScreenUtil.screenWidth - 16.toW * 2 - 10.toW) / 2;

    return Obx(() {
      final cards = [
        _OverviewCardData(
          CaseTypeEnum.caseCount,
          homePageController.homeStatistics.value?.caseCount ?? 0,
          Assets.home.anjianZongs.path,
        ),
        _OverviewCardData(
          CaseTypeEnum.agencyTask,
          homePageController.homeStatistics.value?.pendingTaskCount ?? 0,
          Assets.home.dbrwIcon.path,
        ),
        _OverviewCardData(
          CaseTypeEnum.urgentTask,
          homePageController.homeStatistics.value?.urgentTaskCount ?? 0,
          Assets.home.jjrwIcon.path,
        ),
        _OverviewCardData(
          CaseTypeEnum.nonUrgentTask,
          homePageController.homeStatistics.value?.nonLitigationTaskCount ?? 0,
          Assets.home.fjjrwIcon.path,
        ),
        _OverviewCardData(
          CaseTypeEnum.securityList,
          homePageController.homeStatistics.value?.preservationListCount ?? 0,
          Assets.home.bqqdIcon.path,
        ),
        _OverviewCardData(
          CaseTypeEnum.abnormal,
          homePageController.homeStatistics.value?.abnormalTaskCount ?? 0,
          Assets.home.yichangIcon.path,
        ),
      ];
      return Wrap(
        spacing: 10.toW,
        runSpacing: 10.toW,
        children: cards
            .map((c) => _OverviewCard(data: c, width: cardWidth))
            .toList(),
      );
    });
  }
}

class _OverviewCardData {
  final CaseTypeEnum type;
  final num value;
  final String icon;
  _OverviewCardData(this.type, this.value, this.icon);
}

class _OverviewCard extends StatelessWidget {
  final _OverviewCardData data;
  final double width;
  const _OverviewCard({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 11.toW,
        bottom: 6.toW,
        top: 12.toW,
      ),
      decoration: BoxDecoration(
        color: data.type.bgColor,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data.type.name,
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              Width(4.toW),
              Icon(
                Icons.arrow_forward_ios,
                size: 13.toW,
                color: AppColors.color_FFC5C5C5,
              ),
            ],
          ),
          SizedBox(height: 12.toW),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data.value}',
                style: TextStyle(
                  fontSize: 20.toSp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color_FF1F2937,
                ),
              ),
              ImageUtils(imageUrl: data.icon, width: 30.toW),
            ],
          ),
        ],
      ),
    ).withOnTap(() {
      switch (data.type) {
        case CaseTypeEnum.caseCount:
          getFindController<TabPageController>()?.changeIndex(1);
        case CaseTypeEnum.agencyTask:
          Get.toNamed(Routes.AGENCY_CENTER_PAGE);
        case CaseTypeEnum.urgentTask:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CaseTypeEnum.nonUrgentTask:
          // TODO: Handle this case.
          throw UnimplementedError();
        case CaseTypeEnum.securityList:
          Get.toNamed(Routes.SECURITY_LIST_PAGE);
        case CaseTypeEnum.abnormal:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }
}
