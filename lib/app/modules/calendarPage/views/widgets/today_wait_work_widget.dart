import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/newHomePage/models/case_task_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../http/net/tool/logger.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/object_utils.dart';
import '../../../../utils/screen_utils.dart';
import '../../../newHomePage/views/widgets/remark_case_widget.dart';

class TodayWaitWorkWidget extends StatelessWidget {
  final CaseTaskModel task;
  final bool isShowTime;
  final Function()? addRemarkAction;
  const TodayWaitWorkWidget({
    super.key,
    required this.task,
    this.isShowTime = true,
    this.addRemarkAction,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTodoItemWithTimeline();
  }

  Widget _buildTodoItemWithTimeline() {
    final bool isPlaintiff = task.partyRole == 2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧时间和时间轴
        if (isShowTime)
          Container(
            width: 42.toW,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 23.toW),
            child: Text(
              DateTimeUtils.formatTimestamp(
                task.createTime ?? 0,
                format: 'HH:mm',
              ),
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
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 14,
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
                            imageUrl: Assets.home.anjianZongs.path,
                            width: 20.toW,
                            height: 20.toW,
                          ),
                          SizedBox(width: 8.toW),
                          Text(
                            task.caseName ?? '-',
                            style: TextStyle(
                              fontSize: 15.toSp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.color_E6000000,
                            ),
                          ),
                          if (task.isEmergency == true) ...[
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
                      _infoRow('案件：', task.title ?? '-'),
                      SizedBox(height: 6.toW),
                      _infoRow(
                        '截止：',
                        DateTimeUtils.formatTimestamp(task.dueAt ?? 0),
                      ),
                      SizedBox(height: 6.toW),
                      _infoRow('承办人（法官）:', task.handler ?? '-'),
                      SizedBox(height: 6.toW),
                      _infoRow('电话：', task.handlerPhone ?? '-'),
                      SizedBox(height: 12.toW),
                      _smallButton('备注'),
                      // if (!ObjectUtils.isEmpty(task.notes))
                      //   RemarkCaseWidget(notes: task.notes),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
    ).withOnTap(() {
      if (addRemarkAction != null) {
        addRemarkAction!();
      }
    });
  }
}
