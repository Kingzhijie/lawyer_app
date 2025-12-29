
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

import '../../../../common/constants/app_colors.dart';

class EditNicknameWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(String nickName) sureAction;
  const EditNicknameWidget({super.key, required this.textEditingController, required this.sureAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 57.toH,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60.toW,
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.close, color: Colors.black, size: 22.toW),
                ).withOnTap((){
                  Navigator.pop(context);
                }),
                Text(
                  '编辑昵称',
                  style: TextStyle(
                    color: AppColors.color_E6000000,
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 60.toW,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '确定',
                    style: TextStyle(color: AppColors.theme, fontSize: 16.toSp),
                  ),
                ).withOnTap((){
                  if (textEditingController.text.isEmpty) {
                    showToast('请输入昵称');
                  } else {
                    sureAction(textEditingController.text);
                    Navigator.pop(context);
                  }
                }),
              ],
            ),
          ),
          Height(10.toW),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.toW),
              border: Border.all(color: AppColors.color_line, width: 0.5)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.toW),
            child: TextField(
              textAlign: TextAlign.start,
              maxLines: 1,
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
                hintText: '请输入昵称',
                hintStyle: TextStyle(
                  color: AppColors.color_FFC5C5C5,
                  fontSize: 16.toSp,
                ),
              ),
              onChanged: (text) {},
              onSubmitted: (text) {
                sureAction(textEditingController.text);
                Navigator.pop(context);
              },
            ),
          ),
          Height(30.toW),
        ],
      ),
    );
  }

}
