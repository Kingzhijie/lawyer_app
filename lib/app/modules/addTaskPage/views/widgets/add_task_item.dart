import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/components/image_text_button.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';
import '../../../casePage/models/case_base_info_model.dart';
import '../../../newHomePage/views/widgets/cooperation_person_widget.dart';

enum TaskEnum { choose, close, none }

class AddTaskItem extends StatelessWidget {
  final Function()? closeCardCallBack;
  final Function()? onLinkUserTap;
  final TaskEnum type;
  final bool isSelect;
  final CaseBaseInfoModel? model;

  const AddTaskItem({
    super.key,
    this.closeCardCallBack,
    this.onLinkUserTap,
    this.type = TaskEnum.none,
    this.isSelect = false,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTodoItemWithTimeline();
  }

  Widget _buildTodoItemWithTimeline() {
    final num casePartyRole = model?.casePartyRole ?? 0; // 1:被告2原告
    return Container(
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
            casePartyRole == 2
                ? Assets.home.yuangaoBg.path
                : Assets.home.beigaoBg.path,
          ),
        ),
        border: isSelect == true
            ? Border.all(color: AppColors.theme, width: 0.5)
            : null,
      ),
      child: Stack(
        children: [
          // 右上角角标
          if (casePartyRole > 0)
            Positioned(
              right: 10.toW,
              top: 13.toW,
              child: ImageUtils(
                imageUrl: casePartyRole == 2
                    ? Assets.home.yuangaoIcon.path
                    : Assets.home.beigaoIcon.path,
                width: 58.toW,
              ),
            ),
          if (type == TaskEnum.choose)
            Positioned(
              top: 0,
              right: 0,
              child: ImageUtils(
                imageUrl: isSelect == true
                    ? Assets.common.xuanzhongAnjian.path
                    : Assets.common.weixuanzhongAnjian.path,
                width: 32.toW,
                height: 32.toW,
              ),
            )
          else if (type == TaskEnum.close)
            Positioned(
              right: 4.toW,
              top: 4.toW,
              child:
                  ImageUtils(
                    imageUrl: Assets.common.closeBgIco.path,
                    width: 24.toW,
                    height: 24.toW,
                  ).withOnTap(() {
                    if (closeCardCallBack != null) {
                      closeCardCallBack!();
                    }
                  }),
            ),
          // 卡片内容
          Padding(
            padding: EdgeInsets.all(14.toW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (getStatusName().isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.toW,
                          vertical: 4.toW,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusBgColor(),
                          borderRadius: BorderRadius.circular(4.toW),
                        ),
                        child: Text(
                          getStatusName(),
                          style: TextStyle(
                            color: getStatusTextColor(),
                            fontSize: 10.toSp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ).withMarginOnly(right: 8.toW),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: AppScreenUtil.screenWidth - 162.toW,
                      ),
                      child: Text(
                        model?.caseName ?? '',
                        style: TextStyle(
                          fontSize: 15.toSp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.toW),
                if (!ObjectUtils.isEmptyString(model?.caseNumber))
                  _infoRow('案号：', model!.caseNumber!),
                if (!ObjectUtils.isEmptyList(model?.casePartyResVOS))
                  _infoRow('当事人：', getDangshirenName()),
                if (model?.status != 0)
                  Row(
                    children: [
                      ImageText(
                        position: Position.left,
                        imgUrl: Assets.common.daibanRenwuIcon.path,
                        width: 20.toW,
                        space: 6.toW,
                        title: '待办任务: ${model?.todoTaskCount ?? 0}',
                        style: TextStyle(
                          color: AppColors.color_E6000000,
                          fontSize: 13.toSp,
                        ),
                      ),
                      Width(20.toW),
                      ImageText(
                        position: Position.left,
                        imgUrl: Assets.common.jinjiRenwuIcon.path,
                        width: 20.toW,
                        space: 6.toW,
                        title: '紧急: ${model?.emergencyTaskCount ?? 0}',
                        style: TextStyle(
                          color: AppColors.color_E6000000,
                          fontSize: 13.toSp,
                        ),
                      ),
                    ],
                  ).withMarginOnly(top: 8.toW)
                else if (model?.createTime != null)
                  RichText(
                    text: TextSpan(
                      text: '创建时间: ',
                      style: TextStyle(
                        color: AppColors.color_66000000,
                        fontSize: 13.toSp,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${DateTimeUtils.getFormatData(time: model!.createTime!.toInt(), format: 'yyyy-MM-dd')}',
                          style: TextStyle(
                            color: AppColors.color_E6000000,
                            fontSize: 13.toSp,
                          ),
                        ),
                      ],
                    ),
                  ).withMarginOnly(top: 8.toW),
                SizedBox(height: 16.toW),
                Row(
                  children: [
                    CooperationPersonWidget(
                      relateUsers: model?.relateUsers,
                      linkUserAction: () {
                        if (onLinkUserTap != null) {
                          onLinkUserTap!();
                        }
                      },
                    ).withExpanded(),
                    if (_isMyJoin())
                      Text(
                        '我参与的',
                        style: TextStyle(
                          color: AppColors.color_66000000,
                          fontSize: 14.toSp,
                        ),
                      ).withMarginOnly(left: 30.toW),
                  ],
                ),
              ],
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
    ).withMarginOnly(top: 6.toW);
  }

  String getStatusName() {
    if (model?.status == 0) {
      return '待更新';
    }
    if (model?.status == 1) {
      return '进行中';
    }
    if (model?.status == 2) {
      return '已归档';
    }
    return '';
  }

  Color getStatusBgColor() {
    if (model?.status == 0) {
      return Color(0xFFFEF3E6);
    }
    if (model?.status == 1) {
      return Color(0xFFE8F7F2);
    }
    if (model?.status == 2) {
      return Color(0xFFFEF3E6);
    }
    return Color(0xFFFEF3E6);
  }

  Color getStatusTextColor() {
    if (model?.status == 0) {
      return Color(0xFFED7B2F);
    }
    if (model?.status == 1) {
      return Color(0xFF05A870);
    }
    if (model?.status == 2) {
      return Color(0xFFED7B2F);
    }
    return Color(0xFFED7B2F);
  }

  String getDangshirenName() {
    String type = '';
    if (!ObjectUtils.isEmptyList(model?.casePartyResVOS)) {
      for (var e in model!.casePartyResVOS!) {
        if (!ObjectUtils.isEmptyString(e.name)) {
          type =
              '${type.isEmpty ? '' : '$type '}${e.name}(${getPartyRole(e.partyRole ?? 0)})';
        }
      }
    }
    return type;
  }

  String getPartyRole(num index) {
    switch (index) {
      case 1:
        return '原告';
      case 2:
        return '被告';
      case 3:
        return '第三人 ';
      case 4:
        return '申请人';
      case 5:
        return '被申请人 ';
      case 6:
        return '委托人';
      default:
        return '';
    }
  }

  bool _isMyJoin() {
    var currentUserId = StorageUtils.getString(StorageKey.userId);
    bool isCurrentUserInList =
        model?.relateUsers?.any(
          (user) =>
              user.id.toString() == currentUserId && user.isSponsor == false,
        ) ??
        false;
    return isCurrentUserInList;
  }
}
