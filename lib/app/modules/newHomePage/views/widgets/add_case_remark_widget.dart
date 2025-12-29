import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class AddCaseRemarkWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String remark) sendAction;
  const AddCaseRemarkWidget({super.key, required this.textEditingController, required this.sendAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.toW),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.toW),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 13.toW, vertical: 3.toW),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // 让发送按钮对齐底部
          children: [
            Expanded(
              child: TextField(
                textAlign: TextAlign.start,
                maxLines: null, // 设置为 null 允许无限行
                minLines: 1, // 最小 1 行
                maxLength: 300,
                style: TextStyle(
                  color: AppColors.color_E6000000,
                  fontSize: 16.toSp,
                ),
                controller: textEditingController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero, // 移除默认内边距
                  hintText: '请输入备注',
                  hintStyle: TextStyle(
                    color: AppColors.color_FFC5C5C5,
                    fontSize: 16.toSp,
                  ),
                ),
                onChanged: (text) {},
                onSubmitted: (text) {},
              ),
            ),
            SizedBox(width: 12.toW),
            ImageUtils(imageUrl: Assets.home.sendIcon.path, width: 36.toW).withOnTap((){
              sendAction(textEditingController.text);
            }),
          ],
        ),
      ),
    );
  }
}
