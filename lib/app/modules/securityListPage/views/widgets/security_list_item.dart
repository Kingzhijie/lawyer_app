import 'package:flutter/material.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/screen_utils.dart';

class SecurityListItem extends StatelessWidget {
  final Map<String, dynamic> caseInfo;

  const SecurityListItem({super.key, required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    return _buildCaseCard(caseInfo);
  }

  /// 案件卡片
  Widget _buildCaseCard(Map<String, dynamic> caseInfo) {
    return Container(
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(12.toW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 案件标题
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  caseInfo['title'] ?? '张三诉讼李四合同纠纷案',
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
          SizedBox(height: 12.toW),
          Divider(color: AppColors.color_FFEEEEEE, height: 0.1,),
          SizedBox(height: 12.toW),
          _setRichTextWidget('案件: ', '2023粤0105民初1234号'),
          SizedBox(height: 10.toW),
          // 最近到期日
          _setRichTextWidget('最近到期日: ', '2026年10月16日'),
          SizedBox(height: 10.toW),
          _setRichTextWidget('关联保全资产: ', '8'),
          SizedBox(height: 12.toW),
          // 资产摘要
          _buildAssetSummary(caseInfo['assets'] ?? {}),
          SizedBox(height: 16.toW),
          // 操作按钮
          Row(
            children: [
              Expanded(
                child:
                    Container(
                      height: 36.toW,
                      decoration: BoxDecoration(
                        color: Color(0xFFECF2FE),
                        borderRadius: BorderRadius.circular(8.toW),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '提醒',
                        style: TextStyle(
                          fontSize: 14.toSp,
                          color: AppColors.theme,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).withOnTap(() {
                      // controller.remindAction(caseInfo);
                    }),
              ),
              SizedBox(width: 12.toW),
              Expanded(
                child:
                    Container(
                      height: 36.toW,
                      decoration: BoxDecoration(
                        color: AppColors.color_FFF3F3F3,
                        borderRadius: BorderRadius.circular(8.toW),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '备注',
                        style: TextStyle(
                          fontSize: 14.toSp,
                          color: AppColors.color_99000000,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ).withOnTap(() {
                      // controller.addNoteAction(caseInfo);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _setRichTextWidget(String name, String value){
    return RichText(text: TextSpan(
      text: name, style: TextStyle(color: AppColors.color_66000000, fontSize: 13.toSp),
      children: [
        TextSpan(text: value, style: TextStyle(color: AppColors.color_E6000000, fontSize: 13.toSp))
      ]
    ));
  }

  /// 资产摘要
  Widget _buildAssetSummary(Map<String, dynamic> assets) {
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
          if (assets['realEstate'] != null && assets['realEstate'] > 0)
            _buildAssetItem(
              icon: Assets.my.budongchanIcon.path,
              label: '不动产:',
              value: '${assets['realEstate']}处',
            ),
          if (assets['vehicles'] != null && assets['vehicles'] > 0) ...[
            _buildAssetItem(
              icon: Assets.my.cheliangIcon.path,
              label: '车辆:',
              value: '${assets['vehicles']}台',
            ),
          ],
          if (assets['funds'] != null && assets['funds'] > 0) ...[
            _buildAssetItem(
              icon: Assets.my.zijianIcon.path,
              label: '资金:',
              value: '¥${_formatMoney(assets['funds'])}',
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

  /// 格式化金额
  String _formatMoney(dynamic amount) {
    if (amount is num) {
      final value = amount.toDouble();
      final parts = value.toStringAsFixed(2).split('.');
      final integerPart = parts[0];
      final decimalPart = parts[1];

      // 添加千分位分隔符
      String formatted = '';
      for (int i = integerPart.length - 1; i >= 0; i--) {
        formatted = integerPart[i] + formatted;
        if ((integerPart.length - i) % 3 == 0 && i > 0) {
          formatted = ',' + formatted;
        }
      }

      return '$formatted.$decimalPart';
    }
    return amount.toString();
  }
}
