
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/app/modules/addTaskPage/views/widgets/picker_date_utils.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../utils/screen_utils.dart';

class NoticeDateChoose extends StatelessWidget {
  final Function(int type) clickItem;
  final Function(String time) onChange;
  const NoticeDateChoose({super.key, required this.clickItem, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 57.toH,
          padding: EdgeInsets.symmetric(horizontal: 22.toW),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  clickItem(0);
                  Navigator.pop(context);
                },
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: AppColors.color_66000000,
                    fontSize: 16.toSp,
                  ),
                ),
              ),
              Text(
                '选择日期',
                style: TextStyle(
                  color: AppColors.color_E6000000,
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () async {
                  clickItem(1);
                  Navigator.pop(context);
                },
                child: Text(
                  '确定',
                  style: TextStyle(color: AppColors.theme, fontSize: 16.toSp),
                ),
              ),
            ],
          ),
        ),
        DateYMDPicker(
          onChange: (dateTime, list) {
            var ymd = DateFormat('yyyy-MM-dd').format(dateTime);
            onChange(ymd);
          },
          initDateTime: DateTime.now(),
        ),
        Height(20.toW)
      ],
    );
  }
}
