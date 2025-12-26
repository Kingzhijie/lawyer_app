import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker2/flutter_cupertino_datetime_picker2.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../../../common/constants/app_colors.dart';

class DateYMDPicker extends StatelessWidget {
  final DateTime initDateTime;
  final String dateFormat;
  final Function(DateTime dateTime, List<int> selectedIndex) onChange;

  const DateYMDPicker(
      {super.key, required this.initDateTime, this.dateFormat = 'yyyy年-MM月-dd日', required this.onChange});

  @override
  Widget build(BuildContext context) {
    return DateTimePickerWidget(
        dateFormat: dateFormat,
        initDateTime: initDateTime,
        locale: DateTimePickerLocale.zh_cn,
        // maxDateTime: DateTime.now(),
        onChange: onChange,
        pickerTheme: DateTimePickerTheme(
            showTitle: false,
            pickerHeight: 220.toW,
            itemHeight: 44.toH,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal:
                  BorderSide(color: Colors.transparent, width: 0.8),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            itemTextStyle: TextStyle(
                color: AppColors.color_E6000000, fontSize: 16.toSp)));
    }
}
