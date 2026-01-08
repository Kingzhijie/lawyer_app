import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/extension/string_extension.dart';
import 'package:lawyer_app/app/modules/securityListPage/models/security_item_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';

class SecurityListItem extends StatelessWidget {
  final SecurityItemModel caseInfo;
  final Function(SecurityItemModel caseInfo) onRemindAction;
  const SecurityListItem({
    super.key,
    required this.caseInfo,
    required this.onRemindAction,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCaseCard(caseInfo);
  }

  /// 案件卡片
  Widget _buildCaseCard(SecurityItemModel caseInfo) {
    return Container(
      // padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.toW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          ...setChildren(),
          Padding(
            padding: EdgeInsets.all(16.toW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 案件标题
                Container(
                  padding: EdgeInsets.only(right: 30.toW),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          caseInfo.caseName ?? '',
                          style: TextStyle(
                            fontSize: 16.toSp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.color_E6000000,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.toW,
                        color: AppColors.color_FFC5C5C5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.toW),
                Divider(color: AppColors.color_FFEEEEEE, height: 0.1),
                SizedBox(height: 12.toW),
                _setRichTextWidget('案号: ', caseInfo.caseNumber ?? '-'),
                SizedBox(height: 10.toW),
                // 最近到期日
                _setRichTextWidget(
                  '最近到期日: ',
                  DateTimeUtils.formatTimestamp(
                    caseInfo.nearestExpiryDate ?? 0,
                  ),
                ),
                SizedBox(height: 10.toW),
                _setRichTextWidget('关联保全资产: ', '${caseInfo.assetCount ?? 0}'),
                SizedBox(height: 12.toW),
                // 资产摘要
                _buildAssetSummary(caseInfo),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child:
                Container(
                  width: 50.toW,
                  height: 50.toW,
                  alignment: Alignment.topRight,
                  child: ImageUtils(
                    imageUrl: ObjectUtils.boolValue(caseInfo.isAddCalendar)
                        ? Assets.home.noticeNormalIcon.path
                        : Assets.home.unNoticeIcon.path,
                    width: 30.toW,
                    height: 30.toW,
                  ),
                ).withOnTap(() {
                  onRemindAction(caseInfo);
                }),
          ),
        ],
      ),
    );
  }

  List<Widget> setChildren() {
    return [
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: Container(
          width: 100.toW,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.toW),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: ImageUtils(
          imageUrl: true
              ? Assets.home.yuangaoNoticeBg.path
              : Assets.home.beigaoNoticeBg.path,
          width: 300.toW,
          fit: BoxFit.contain,
        ),
      ),
    ];
  }

  Widget _setRichTextWidget(String name, String value) {
    return RichText(
      text: TextSpan(
        text: name,
        style: TextStyle(color: AppColors.color_66000000, fontSize: 13.toSp),
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
    );
  }

  /// 资产摘要
  Widget _buildAssetSummary(SecurityItemModel assets) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_FFF5F7FA,
        borderRadius: BorderRadius.circular(8.toW),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(12.toW),
      child: Wrap(
        runSpacing: 9.toW,
        spacing: 8.toW,
        children: [
          if ((assets.realEstateCount ?? 0) > 0)
            _buildAssetItem(
              icon: Assets.my.budongchanIcon.path,
              label: '不动产:',
              value: '${assets.realEstateCount}处',
            ),
          if ((assets.vehicleCount ?? 0) > 0) ...[
            _buildAssetItem(
              icon: Assets.my.cheliangIcon.path,
              label: '车辆:',
              value: '${assets.vehicleCount}台',
            ),
          ],
          if ((assets.fundAmount ?? 0) > 0) ...[
            _buildAssetItem(
              icon: Assets.my.zijianIcon.path,
              label: '资金:',
              value: (assets.fundAmount! / 100).toString().toRMBPrice(
                fractionDigits: 2,
              ),
            ),
          ],
          if ((assets.otherAssetCount ?? 0) > 0) ...[
            _buildAssetItem(
              icon: Assets.my.zijianIcon.path,
              label: '其他资产:',
              value: '${assets.otherAssetCount}处',
            ),
          ],
        ],
      ),
    );
  }

  /// 资产项
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
