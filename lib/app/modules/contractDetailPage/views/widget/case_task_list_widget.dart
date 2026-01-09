import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/task_list_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseTaskListWidget extends StatelessWidget {
  final List<TaskListModel> tasks;
  final VoidCallback onAddTap;
  final VoidCallback onCheckTasksTap;
  const CaseTaskListWidget({
    super.key,
    required this.tasks,
    required this.onAddTap,
    required this.onCheckTasksTap,
  });

  @override
  Widget build(BuildContext context) {
    final taskList = tasks.take(6).toList();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 8.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.toW),
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
                onTap: onCheckTasksTap,
                behavior: HitTestBehavior.opaque,
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
            itemCount: taskList.length,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => SizedBox(height: 12.toW),
            itemBuilder: (context, index) {
              final task = taskList[index];
              return _buildTaskItem(task);
            },
          ),
          SizedBox(height: 8.toW),
          // 添加按钮
          Center(
            child: GestureDetector(
              onTap: onAddTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                '添加',
                style: TextStyle(fontSize: 14.toSp, color: AppColors.theme),
              ).withPaddingSymmetric(horizontal: 20.toW, vertical: 8.toW),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskListModel item) {
    return Container(
      padding: EdgeInsets.all(12.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.toW),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [
            item.status == 0 ? Color(0xFFFFEBE8) : Color(0xFFF1FFE8),
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // 任务信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title ?? '-',
                        style: TextStyle(
                          fontSize: 15.toSp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                    ),
                    if (item.isEmergency == true) ...[
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
                    if (item.status == 0) ...[
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
                  '截止时间：${DateTimeUtils.formatTimestamp(item.dueAt ?? 0)}',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.toW),
          if (item.status != 0)
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Icon(
                    item.status == 1
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    size: 16.toW,
                    color: AppColors.color_99000000,
                  ),
                  SizedBox(width: 4.toW),
                  Text(
                    item.status == 1 ? '已完成' : '已取消',
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
