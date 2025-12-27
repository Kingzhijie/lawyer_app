import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';

class ChooseConcernedPersonAlert extends StatefulWidget {
  const ChooseConcernedPersonAlert({super.key});

  @override
  State<ChooseConcernedPersonAlert> createState() =>
      _ChooseConcernedPersonAlertState();
}

class _ChooseConcernedPersonAlertState
    extends State<ChooseConcernedPersonAlert> {
  double viewTop = 114.toW;

  List<String> datas = ['风没血', '李鹏', '赵雷', '周杰伦', '小明', '邓紫棋'];
  List<String> selects = [];

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
            if (viewTop == 0) SizedBox(height: AppScreenUtil.statusBarHeight),
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
                    '选择当事人',
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
            ListView.builder(
              itemCount: datas.length,
              padding: EdgeInsets.symmetric(
                horizontal: 16.toW,
                vertical: 16.toW,
              ),
              itemBuilder: (context, index) {
                var name = datas[index];
                return Container(
                  height: 54.toW,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.color_line, width: 0.5))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: TextStyle(color: AppColors.color_E6000000, fontSize: 16.toSp),),
                      if (selects.contains(name))
                      Icon(Icons.check, color: AppColors.theme, size: 20.toW)
                    ],
                  ),
                ).withOnTap((){
                  if (selects.contains(name)) {
                    selects.remove(name);
                  } else {
                    selects.add(name);
                  }
                  setState(() {});
                });
              },
            ).withExpanded(),
          ],
        ),
      ).withOnTap(() {}),
    ).withOnTap(() {
      Get.back();
    });
  }
}
