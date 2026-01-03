import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';


class ChooseTypeModel {
  String? name;
  int? id;
  ChooseTypeModel({this.name, this.id});
}

class ChooseConcernedPersonAlert extends StatefulWidget {
  final List<ChooseTypeModel>? models;
  final String? title;
  final Function(ChooseTypeModel? model)? chooseAction;
  const ChooseConcernedPersonAlert({super.key, this.models, this.title, this.chooseAction});

  @override
  State<ChooseConcernedPersonAlert> createState() =>
      _ChooseConcernedPersonAlertState();
}

class _ChooseConcernedPersonAlertState
    extends State<ChooseConcernedPersonAlert> {
  double viewTop = 114.toW;

  ChooseTypeModel? selectModel;

  @override
  void initState() {
    super.initState();

  }

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
                    widget.title ?? '请选择',
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
                  ).withOnTap((){
                    if (widget.chooseAction!=null){
                      widget.chooseAction!(selectModel);
                    }
                    Navigator.pop(context);
                  }),
                ],
              ),
            ),
            ListView.builder(
              itemCount: widget.models?.length ?? 0,
              padding: EdgeInsets.symmetric(
                horizontal: 16.toW,
                vertical: 16.toW,
              ),
              itemBuilder: (context, index) {
                var model = widget.models![index];
                return Container(
                  height: 54.toW,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.color_line, width: 0.5))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(model.name ?? '', style: TextStyle(color: AppColors.color_E6000000, fontSize: 16.toSp),),
                      if (selectModel == model)
                      Icon(Icons.check, color: AppColors.theme, size: 20.toW)
                    ],
                  ),
                ).withOnTap((){
                  if (selectModel == model) {
                    selectModel = null;
                  } else {
                    selectModel = model;
                  }
                  setState(() {});
                });
              },
            ).withExpanded(),
          ],
        ),
      ),
    ).withOnTap(() {
      Get.back();
    });
  }
}
