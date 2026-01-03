import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseProgressWidget extends StatelessWidget {
  const CaseProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟进展数据
    final progressList = [
      {'date': '2025-01-20', 'title': '案件立案', 'isTask': false},
      {'date': '2025-01-20', 'title': '缴纳诉讼费用', 'isTask': false},
      {'date': '2025-01-20', 'title': '传票', 'isTask': false},
      {'date': '2025-01-20', 'title': '质证意见', 'isTask': false},
      {'date': '2025-01-20', 'title': '保全裁定书', 'isTask': false},
      {'date': '2025-01-20', 'title': '保全送果书', 'isTask': false},
      {'date': '2025-01-20 12:00:00', 'title': '任务名称', 'isTask': true},
      {'date': '2025-01-20', 'title': '判决通知书', 'isTask': false},
      {'date': '2025-01-20', 'title': '执行期间', 'isTask': false},
      {'date': '2025-01-20', 'title': '发起申请执行', 'isTask': false},
      {'date': '2025-01-20', 'title': '申请执行案号', 'isTask': false},
      {'date': '2025-01-20', 'title': '归档', 'isTask': false},
      {'date': '2025-01-20', 'title': '案件创建', 'isTask': false},
    ];

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
            '案件进展（原告）',
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
              return _buildTimelineItem(
                item['date'] as String,
                item['title'] as String,
                isTask: item['isTask'] as bool,
                isLast: isLast,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String date,
    String title, {
    bool isTask = false,
    bool isLast = false,
  }) {
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
        ).withPaddingOnly(top: 7.toW),
        SizedBox(width: 12.toW),
        // 内容区域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日期
              Text(
                date,
                style: TextStyle(
                  fontSize: 12.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              SizedBox(height: 6.toW),
              // 内容卡片
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.toW,
                  vertical: 10.toW,
                ),
                decoration: BoxDecoration(
                  color: isTask
                      ? const Color(0xFFFFF5E6)
                      : const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(8.toW),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16.toW,
                      color: isTask ? const Color(0xFFFF9800) : AppColors.theme,
                    ),
                    SizedBox(width: 8.toW),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.toSp,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                    ),
                    if (isTask)
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.toW,
                        color: const Color(0xFFFF9800),
                      ),
                  ],
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
