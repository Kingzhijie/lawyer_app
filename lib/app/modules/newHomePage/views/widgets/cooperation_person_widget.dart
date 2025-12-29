
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';
import '../../../casePage/models/case_base_info_model.dart';
///关联用户
class CooperationPersonWidget extends StatelessWidget {
  final Function() linkUserAction;
  final List<RelateUsers>? relateUsers;
  const CooperationPersonWidget({super.key, required this.linkUserAction, this.relateUsers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (!ObjectUtils.isEmptyList(relateUsers))
          Row(
            children: relateUsers!.map((e)=>_avatar(model: e)).toList(),
          ),
          _avatar(isAdd: true),
        ],
      ),
    );
  }

  Widget _avatar({bool isAdd = false, RelateUsers? model}) {
    return Column(
      children: [
        Stack(
          children: [
            ImageUtils(
              imageUrl: isAdd
                  ? Assets.home.addCrileIcon.path
                  : model?.avatar ?? Assets.home.defaultUserIcon.path,
              width: 32.toW,
              height: 32.toW,
              circularRadius: 16.toW,
              borderColor: Colors.white,
              borderWidth: 1,
              placeholderImagePath: Assets.home.defaultUserIcon.path,
            ).withOnTap((){
              if (isAdd) {
                linkUserAction();
              }
            }),
            if (ObjectUtils.boolValue(model?.isSponsor))
              Positioned(
                left: 3.toW,
                right: 3.toW,
                bottom: 0,
                child: Container(
                  height: 10.toW,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.toW),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFE9CD), Color(0xFFE0AF7D)],
                    ),
                  ),
                  child: Text(
                    '发起人',
                    style: TextStyle(
                      color: Color(0xFF603619),
                      fontSize: 6.toSp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (isAdd)
          SizedBox(height: 12.toW)
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 32.toW),
            child: Text(
              '腰动力',
              maxLines: 1,
              style: TextStyle(
                color: AppColors.color_42000000,
                fontSize: 9.toSp,
              ),
            ),
          ),
      ],
    );
  }

}
