import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';

class TodayWaitWorkWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isShowTime;
  const TodayWaitWorkWidget({super.key, required this.task, this.isShowTime = true});

  @override
  Widget build(BuildContext context) {
    return _buildTodoItemWithTimeline();
  }

  Widget _buildTodoItemWithTimeline() {
    final bool isPlaintiff = task['role'] == '原告';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧时间和时间轴
          if (isShowTime)
          Container(
            width: 42.toW,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 23.toW),
            child: Text(
              task['time'],
              style: TextStyle(
                fontSize: 14.toSp,
                fontWeight: FontWeight.w500,
                color: AppColors.color_66000000,
              ),
            ),
          ).withMarginOnly(right: 12.toW),
          // 右侧卡片
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8.toW, bottom: 8.toW),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(14.toW),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    isPlaintiff
                        ? Assets.home.yuangaoBg.path
                        : Assets.home.beigaoBg.path,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  // 右上角角标
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ImageUtils(
                      imageUrl: isPlaintiff
                          ? Assets.home.yuangaoIcon.path
                          : Assets.home.beigaoIcon.path,
                      width: 58.toW,
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
                        _infoRow('承办人（法官）:', task['handler']),
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
}
