import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/cooperation_person_widget.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../models/case_task_model.dart';
import 'remark_case_widget.dart';

enum TaskOperatorType { completed, reamrk, delete }

class TaskCard extends StatelessWidget {
  final Function(int type) clickItemType; //0: 备注, 1:关联用户, 2: 添加任务到日历提醒
  final CaseTaskModel? model;
  final Function(TaskOperatorType type)? onTaskOperatorTap;
  const TaskCard({
    super.key,
    required this.clickItemType,
    this.onTaskOperatorTap,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('${model?.id}'),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (c) {
              if (onTaskOperatorTap != null) {
                onTaskOperatorTap!(TaskOperatorType.completed);
              }
            },
            backgroundColor: const Color(0xFF025FFF),
            foregroundColor: Colors.white,
            label: '完成',
          ),
          SlidableAction(
            onPressed: (c) {
              if (onTaskOperatorTap != null) {
                onTaskOperatorTap!(TaskOperatorType.reamrk);
              }
            },
            backgroundColor: Color(0xFFFF6225),
            foregroundColor: Colors.white,
            label: '备注',
          ),
          SlidableAction(
            onPressed: (c) {
              if (onTaskOperatorTap != null) {
                onTaskOperatorTap!(TaskOperatorType.delete);
              }
            },
            backgroundColor: Color(0xFFF12304),
            foregroundColor: Colors.white,
            label: '删除',
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 8.toW),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14.toW),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            ...setChildren(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ImageUtils(
                      imageUrl: model?.logo,
                      width: 32.toW,
                      height: 32.toW,
                      placeholderColor: AppColors.color_FFF8F8F8,
                      circularRadius: 6.toW,
                    ),
                    SizedBox(width: 8.toW),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppScreenUtil.screenWidth - 170.toW,
                      ),
                      child: Text(
                        model?.title ?? '',
                        style: TextStyle(
                          fontSize: 16.toSp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.toW),
                    if (ObjectUtils.boolValue(model?.isEmergency))
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.toW,
                          vertical: 3.toW,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFDECEE),
                          borderRadius: BorderRadius.circular(4.toW),
                        ),
                        child: Text(
                          '紧急',
                          style: TextStyle(
                            fontSize: 10.toSp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFE34D59),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.toW),
                _infoRow('案件：', '${model?.caseName ?? ''}'),
                if (model?.dueAt != null)
                  _infoRow(
                    '截止：',
                    '${DateTimeUtils.formatTimestamp(model?.dueAt ?? 0)}',
                  ),
                if (!ObjectUtils.isEmptyString(model?.handler))
                  _infoRow('承办人（法官）：', model?.handler ?? ''),
                if (model?.handlerPhone != null)
                  _infoRow('电话：', model?.handlerPhone ?? ''),
                SizedBox(height: 8.toW),
                Row(
                  children: [
                    CooperationPersonWidget(
                      relateUsers: model?.relateUsers,
                      linkUserAction: () {
                        clickItemType(1);
                      },
                    ).withExpanded(),
                    Width(30.toW),
                    _smallButton('备注'),
                  ],
                ),
                if (!ObjectUtils.isEmpty(model?.notes))
                  RemarkCaseWidget(notes: model?.notes),
              ],
            ).withPaddingAll(14.toW),
            Positioned(
              top: 0,
              right: 0,
              child:
                  Container(
                    width: 50.toW,
                    height: 50.toW,
                    alignment: Alignment.topRight,
                    child: ImageUtils(
                      imageUrl: ObjectUtils.boolValue(model?.isAddCalendar)
                          ? Assets.home.noticeNormalIcon.path
                          : Assets.home.unNoticeIcon.path,
                      width: 30.toW,
                      height: 30.toW,
                    ),
                  ).withOnTap(() {
                    clickItemType(2);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> setChildren() {
    return [
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: Container(
          width: 100.toW,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.toW),
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 130.toW,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.toW),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: ImageUtils(
          imageUrl: model?.partyRole == 1
              ? Assets.home.yuangaoNoticeBg.path
              : Assets.home.beigaoNoticeBg.path,
          width: 300.toW,
          fit: BoxFit.contain,
        ),
      ),
      Positioned(
        top: 16.toW,
        right: 13.toW,
        child: ImageUtils(
          imageUrl: model?.partyRole == 1
              ? Assets.home.yuangaoIcon.path
              : Assets.home.beigaoIcon.path,
          width: 69.toW,
        ),
      ),
    ];
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.toSp, color: AppColors.color_66000000),
        ),
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
    ).withMarginOnly(bottom: 8.toW);
  }

  Widget _smallButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toW, vertical: 5.toW),
      decoration: BoxDecoration(
        color: AppColors.color_FFEEEEEE,
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.toSp, color: AppColors.color_E6000000),
      ),
    ).withOnTap(() {
      clickItemType(0);
    });
  }
}
