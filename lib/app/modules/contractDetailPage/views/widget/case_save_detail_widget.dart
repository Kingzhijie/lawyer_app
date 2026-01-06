import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/pres_asset_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class CaseSaveDetailWidget extends StatelessWidget {
  final List<PresAssetModel> presAssetList;
  final VoidCallback onCheckAssetsTap;
  const CaseSaveDetailWidget({
    super.key,
    required this.presAssetList,
    required this.onCheckAssetsTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveToList = presAssetList.map((item) {
      final effectiveTo = item.effectiveTo ?? 0;
      return effectiveTo;
    }).toList();
    final max = effectiveToList.reduce((a, b) => a > b ? a : b);
    final min = effectiveToList.reduce((a, b) => a < b ? a : b);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '保全明细',
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
              GestureDetector(
                onTap: onCheckAssetsTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Text(
                      '${presAssetList.length}处关联保全资产',
                      style: TextStyle(
                        fontSize: 14.toSp,
                        color: AppColors.theme,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.toW,
                      color: AppColors.theme,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.toW),

          Container(
            padding: EdgeInsets.all(12.toW),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.toW),
              color: AppColors.color_FFF5F7FA,
            ),
            child: Wrap(
              children: [
                ...presAssetList.map((item) {
                  final assetType = item.assetType ?? 0;
                  var icon = '';
                  var label = '';
                  var value = '';
                  switch (assetType) {
                    case 1:
                      icon = Assets.my.budongchanIcon.path;
                      label = '不动产：';
                      value = '${item.quantity ?? 1}处';
                      break;
                    case 2:
                      icon = Assets.my.cheliangIcon.path;
                      label = '车辆：';
                      value = '${item.quantity ?? 1}台';
                      break;
                    case 4:
                      icon = Assets.my.zijianIcon.path;
                      label = '资金：';
                      value = '¥${(item.amount ?? 0.0).toStringAsFixed(2)}';
                      break;
                    default:
                      icon = Assets.my.zijianIcon.path;
                      label = item.assetName ?? '';
                      value = (item.quantity ?? 1).toString();
                  }
                  return _buildAssetItem(
                    icon: icon,
                    label: label,
                    value: value,
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 16.toW),
          // 截止日期
          Row(
            children: [
              Text(
                '截止日期: ',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              Text(
                DateTimeUtils.formatTimestamp(min),
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_E6000000,
                ),
              ),
              SizedBox(width: 8.toW),
              Text(
                '——',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              SizedBox(width: 8.toW),
              Text(
                DateTimeUtils.formatTimestamp(max),
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_E6000000,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssetItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        ImageUtils(imageUrl: icon, width: 20.toW, height: 20.toW),
        SizedBox(width: 2.toW),
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_66000000,
            ),
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  color: AppColors.color_E6000000,
                  fontSize: 13.toSp,
                ),
              ),
            ],
          ),
        ),
      ],
    ).withWidth(135.toW);
  }
}
