import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case_timeline_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class CaseProgressWidget extends StatelessWidget {
  final List<CaseTimelineModel> progressList;
  const CaseProgressWidget({super.key, required this.progressList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            '案件进展',
            style: TextStyle(
              fontSize: 16.toSp,
              fontWeight: FontWeight.w600,
              color: AppColors.color_E6000000,
            ),
          ),
          SizedBox(height: 16.toW),
          // 时间轴列表
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: progressList.length,
            itemBuilder: (context, index) {
              final item = progressList[index];
              final isLast = index == progressList.length - 1;
              return _buildTimelineItem(item, isLast: isLast);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(CaseTimelineModel item, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 时间轴左侧
        Column(
          children: [
            // 圆点
            Container(
              width: 8.toW,
              height: 8.toW,
              decoration: BoxDecoration(
                color: AppColors.theme,
                shape: BoxShape.circle,
              ),
            ),
            // 连接线
            if (!isLast)
              Container(width: 1.toW, height: 60.toW, color: AppColors.theme),
          ],
        ).withPaddingOnly(top: 5.toW),
        SizedBox(width: 12.toW),
        // 内容区域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日期
              Text(
                DateTimeUtils.formatTimestamp(item.eventTime ?? 0),
                style: TextStyle(
                  fontSize: 12.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              SizedBox(height: 6.toW),
              // 内容卡片
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (item.relatedTaskId != null) {
                    showToast('查看任务--暂时没有接口');
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.toW,
                    vertical: 10.toW,
                  ),
                  decoration: BoxDecoration(
                    color: item.relatedTaskId != null
                        ? const Color(0xFFFFF5E6)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(8.toW),
                  ),
                  child: Row(
                    children: [
                      ImageUtils(
                        imageUrl: item.relatedTaskId != null
                            ? Assets.home.caseProgressTaskIcon.path
                            : Assets.home.susongfeiIcon.path,
                        width: 24.toW,
                        height: 24.toW,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8.toW),
                      Expanded(
                        child: Text(
                          item.eventTitle != null && item.eventTitle!.isNotEmpty
                              ? item.eventTitle!
                              : '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.toSp,
                            color: AppColors.color_E6000000,
                          ),
                        ),
                      ),
                      if (item.relatedTaskId != null)
                        ImageUtils(
                          imageUrl: Assets.home.caseProgressArrowIcon.path,
                          width: 14.toW,
                          height: 14.toW,
                          fit: BoxFit.cover,
                        ),
                    ],
                  ),
                ),
              ),
              if (!isLast) SizedBox(height: 4.toW),
            ],
          ),
        ),
      ],
    );
  }
}
