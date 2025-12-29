import 'package:flutter/material.dart';

import '../../utils/screen_utils.dart';
import '../constants/app_colors.dart';


class BottomSheetContentWidget extends StatelessWidget {
  final List<BottomSheetContentModel> contentModels;
  final Function(BottomSheetContentModel model) clickItemCallBack;

  const BottomSheetContentWidget(
      {super.key,
      required this.contentModels,
      required this.clickItemCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._setListContent(context),
          Container(
            height: 8.toW,
            color: AppColors.color_line,
          ),
          _setItem(
              true, context, BottomSheetContentModel(name: '取消', index: -1))
        ],
      ),
    );
  }

  List<Widget> _setListContent(BuildContext context) {
    return contentModels.map((e) => _setItem(false, context, e)).toList();
  }

  Widget _setItem(
      bool isHiddenLine, BuildContext context, BottomSheetContentModel model) {
    return InkWell(
      child: Container(
        decoration: isHiddenLine
            ? null
            : BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: AppColors.color_line,
                        width: 0.5))),
        height: 56.toW,
        alignment: Alignment.center,
        child: Text(
          model.name,
          style: TextStyle(
              color: model.name == '取消' ? Colors.grey : (model.textColor ?? Colors.black),
              fontSize: 14.toSp, fontWeight: FontWeight.w500),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        clickItemCallBack(model);
      },
    );
  }
}

class BottomSheetContentModel {
  String name;
  int? index;
  Color? textColor;

  BottomSheetContentModel({required this.name, this.index, this.textColor});
}
