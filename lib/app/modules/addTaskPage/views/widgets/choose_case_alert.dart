import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../common/extension/widget_extension.dart';
import 'add_task_item.dart';

class ChooseCaseAlert extends StatefulWidget {
  const ChooseCaseAlert({super.key});

  @override
  State<ChooseCaseAlert> createState() => _ChooseCaseAlertState();
}

class _ChooseCaseAlertState extends State<ChooseCaseAlert> {
  double viewTop = 114.toW;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppScreenUtil.screenHeight,
      padding: EdgeInsets.only(top: viewTop),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.toW)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            if (viewTop == 0)
              SizedBox(height: AppScreenUtil.statusBarHeight),
            Container(
              height: 48.toW,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100.toW,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.toW),
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 22.toW,
                        ).withOnTap(() {
                          Navigator.pop(context);
                        }),
                        Width(10.toW),
                        if (viewTop == 0)
                          Icon(
                            Icons.close_fullscreen,
                            color: Colors.black,
                            size: 19.toW,
                          ).withOnTap(() {
                            setState(() {
                              viewTop = 114.toW;
                            });
                          })
                        else
                          ImageUtils(
                            imageUrl: Assets.common.quanpingIcon.path,
                            width: 20.toW,
                          ).withOnTap(() {
                            setState(() {
                              viewTop = 0;
                            });
                          }),
                      ],
                    ),
                  ),
                  Text(
                    '选择案件',
                    style: TextStyle(
                      color: AppColors.color_E6000000,
                      fontSize: 16.toSp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 100.toW,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.toW),
                    child: Text(
                      '确定',
                      style: TextStyle(
                        color: AppColors.theme,
                        fontSize: 16.toSp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _setFilterWidget(),
            ListView.builder(
              itemCount: 10,
                padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 16.toW),
                itemBuilder: (context, index) {
              return AddTaskItem(isChoose: true);
            }).withExpanded()
          ],
        ),
      ),
    );
  }

  Widget _setFilterWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.toW, horizontal: 16.toW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _setFilterItemWidget('当事人'),
          _setFilterItemWidget('任务类型'),
          Container(
            width: 44.toW,
            height: 44.toW,
            alignment: Alignment.center,
            child: ImageUtils(
              imageUrl: Assets.home.searchIcon.path,
              width: 22.toW,
              height: 22.toW,
            ),
          ),
        ],
      ),
    );
  }

  Widget _setFilterItemWidget(String name) {
    return Container(
      width: 140.toW,
      height: 44.toW,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
        border: Border.all(color: AppColors.color_line, width: 0.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColors.color_66000000,
              fontSize: 14.toSp,
            ),
          ).withExpanded(),
          ImageUtils(
            imageUrl: Assets.common.careDownQs.path,
            width: 16.toW,
            height: 16.toW,
          ),
        ],
      ),
    );
  }
}
