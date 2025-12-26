import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/components/image_text_button.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';
import '../../../newHomePage/views/widgets/cooperation_person_widget.dart';

class AddTaskItem extends StatelessWidget {
  final Function()? closeCardCallBack;
  final bool? isChoose;
  final bool isSelect;

  const AddTaskItem({
    super.key,
    this.closeCardCallBack,
    this.isChoose,
    this.isSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildTodoItemWithTimeline();
  }

  Widget _buildTodoItemWithTimeline() {
    final bool isPlaintiff = false;
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
            isPlaintiff
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
          Positioned(
            right: 10.toW,
            top: 13.toW,
            child: ImageUtils(
              imageUrl: isPlaintiff
                  ? Assets.home.yuangaoIcon.path
                  : Assets.home.beigaoIcon.path,
              width: 58.toW,
            ),
          ),
          if (isChoose == true)
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
          else
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.toW,
                        vertical: 4.toW,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F7F2),
                        borderRadius: BorderRadius.circular(4.toW),
                      ),
                      child: Text(
                        '进行中',
                        style: TextStyle(
                          color: Color(0xFF05A870),
                          fontSize: 10.toSp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.toW),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 170.toW),
                      child: Text(
                        '张三诉讼李四合同纠纷案',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15.toSp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.toW),
                _infoRow('案号：', '2023粤0102民初1234号'),
                SizedBox(height: 6.toW),
                _infoRow('当事人：', '张三原告, 李四被告'),
                SizedBox(height: 8.toW),
                Row(
                  children: [
                    ImageText(
                      position: Position.left,
                      imgUrl: Assets.common.daibanRenwuIcon.path,
                      width: 20.toW,
                      space: 6.toW,
                      title: '待办任务: 4',
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
                      title: '紧急: 4',
                      style: TextStyle(
                        color: AppColors.color_E6000000,
                        fontSize: 13.toSp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.toW),
                Row(
                  children: [
                    CooperationPersonWidget(
                      linkUserAction: () {},
                    ).withExpanded(),
                    Width(30.toW),
                    Text(
                      '我参与的',
                      style: TextStyle(
                        color: AppColors.color_66000000,
                        fontSize: 14.toSp,
                      ),
                    ),
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
    );
  }
}
