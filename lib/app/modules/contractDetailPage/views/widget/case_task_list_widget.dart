import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseTaskListWidget extends StatelessWidget {
  const CaseTaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟任务数据
    final tasks = [
      {
        'title': '缴纳诉讼费',
        'deadline': '2025-12-31',
        'hasUrgent': true,
        'hasAlert': true,
      },
      {
        'title': '催促保全结果',
        'deadline': '2025-12-31',
        'hasUrgent': true,
        'hasAlert': true,
      },
      {
        'title': '第一次开庭',
        'deadline': '2025-12-31',
        'hasUrgent': false,
        'hasAlert': true,
      },
      {
        'title': '判决上诉',
        'deadline': '2025-12-31',
        'hasUrgent': true,
        'hasAlert': true,
      },
      {
        'title': '判决生效日',
        'deadline': '2025-12-31',
        'hasUrgent': true,
        'hasAlert': true,
      },
      {
        'title': '判决上诉',
        'deadline': '2025-12-31',
        'hasUrgent': true,
        'hasAlert': true,
      },
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
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '任务列表',
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      '查看全部',
                      style: TextStyle(
                        fontSize: 14.toSp,
                        color: AppColors.theme,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.toW,
                      color: AppColors.theme,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.toW),
          // 任务列表
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => SizedBox(height: 12.toW),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItem(
                task['title'] as String,
                task['deadline'] as String,
                hasUrgent: task['hasUrgent'] as bool,
                hasAlert: task['hasAlert'] as bool,
              );
            },
          ),
          SizedBox(height: 16.toW),
          // 添加按钮
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                '添加',
                style: TextStyle(fontSize: 14.toSp, color: AppColors.theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    String title,
    String deadline, {
    bool hasUrgent = false,
    bool hasAlert = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.toW),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [Color(0xFFFFEBE8), Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: const Offset(0, 0),
          ),
        ]
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 32.toW,
            height: 32.toW,
            decoration: BoxDecoration(
              color: AppColors.theme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.toW),
            ),
            child: Icon(
              Icons.people_outline,
              size: 20.toW,
              color: AppColors.theme,
            ),
          ),
          SizedBox(width: 12.toW),
          // 任务信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.toSp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color_E6000000,
                      ),
                    ),
                    if (hasUrgent) ...[
                      SizedBox(width: 8.toW),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.toW,
                          vertical: 2.toW,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFF4D4F),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(4.toW),
                        ),
                        child: Text(
                          '紧急',
                          style: TextStyle(
                            fontSize: 10.toSp,
                            color: const Color(0xFFFF4D4F),
                          ),
                        ),
                      ),
                    ],
                    if (hasAlert) ...[
                      SizedBox(width: 6.toW),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.toW,
                          vertical: 2.toW,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFFFA940),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(4.toW),
                        ),
                        child: Text(
                          '待办',
                          style: TextStyle(
                            fontSize: 10.toSp,
                            color: const Color(0xFFFFA940),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 6.toW),
                Text(
                  '截止时间：$deadline',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
              ],
            ),
          ),
          // 完成按钮
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16.toW,
                  color: AppColors.color_99000000,
                ),
                SizedBox(width: 4.toW),
                Text(
                  '完成',
                  style: TextStyle(
                    fontSize: 13.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
