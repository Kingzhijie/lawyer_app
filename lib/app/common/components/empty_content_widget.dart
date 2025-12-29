import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';

import '../../utils/screen_utils.dart';
import 'image_text_button.dart';

class EmptyContentWidget extends StatelessWidget {
  final String? content;
  final double? bottom;
  final String? icon;

  const EmptyContentWidget({super.key, this.content, this.bottom, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: bottom ?? 100.toW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            ImageUtils(
              imageUrl: icon,
              width: 140.toW,
            ).withMarginOnly(bottom: 12.toW),
          Text(
            content ?? '暂无内容',
            style: TextStyle(
              color: AppColors.color_FFC5C5C5,
              fontSize: 14.toSp,
            ),
          ),
        ],
      ),
    );
  }
}
