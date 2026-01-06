import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class ChooseChargeStyle extends StatefulWidget {
  final String title;
  final List<String> contents;
  final Function(String content) chooseResult;
  final String? selectStr;
  const ChooseChargeStyle({
    super.key,
    required this.title,
    required this.contents,
    required this.chooseResult,
    this.selectStr,
  });

  @override
  State<ChooseChargeStyle> createState() => _ChooseChargeStyleState();
}

class _ChooseChargeStyleState extends State<ChooseChargeStyle> {
  String? selectName;

  @override
  void initState() {
    super.initState();
    selectName = widget.selectStr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 48.toW,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50.toW,
                child: Icon(Icons.close, color: Colors.black, size: 22.toW),
              ).withOnTap(() {
                Navigator.pop(context);
              }),
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 50.toW,
                child: Text(
                  '确定',
                  style: TextStyle(color: AppColors.theme, fontSize: 14.toSp),
                ),
              ).withOnTap(() {
                widget.chooseResult(selectName ?? '');
                Navigator.pop(context);
              }),
            ],
          ),
        ),
        ListView.builder(
          itemCount: widget.contents.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            var name = widget.contents[index];
            return Container(
              height: 54.toW,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.color_line, width: 0.5),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.toW),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.black, fontSize: 16.toSp),
                  ),
                  if (name == selectName)
                    Icon(Icons.check, color: AppColors.theme, size: 22.toW),
                ],
              ),
            ).withOnTap(() {
              setState(() {
                selectName = name;
              });
            });
          },
        ).withExpanded(),
      ],
    );
  }
}
