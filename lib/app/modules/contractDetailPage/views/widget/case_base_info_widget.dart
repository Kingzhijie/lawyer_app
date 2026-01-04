import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_detail_model.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseBaseInfoWidget extends StatelessWidget {
  final CaseDetailModel caseDetail;
  const CaseBaseInfoWidget({super.key, required this.caseDetail});

  @override
  Widget build(BuildContext context) {
    var caseTypeText = '未知';
    switch (caseDetail.caseBase!.caseType) {
      case 1:
        caseTypeText = '行政';
        break;
      case 2:
        caseTypeText = '民事';
        break;
      case 3:
        caseTypeText = '刑事';
        break;
      default:
    }
    final roles = caseDetail.caseBase!.casePartyResVos ?? [];
    var roleText = '';
    for (var item in roles) {
      if (item.name != null && item.name!.isNotEmpty) {
        roleText += '${item.name}(${getRuleText(item.partyRole ?? 0)})';
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [Color(0xFFFFEBE8), Colors.white],
        ),
      ),
      padding: EdgeInsets.all(16.toW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.color_line, width: 0.5),
              ),
            ),
            padding: EdgeInsets.only(bottom: 8.toW),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.toW,
                    vertical: 4.toW,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4F),
                    borderRadius: BorderRadius.circular(4.toW),
                  ),
                  child: Text(
                    caseDetail.caseBase?.casePartyRole == 2 ? '原告' : '被告',
                    style: TextStyle(
                      fontSize: 12.toSp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8.toW),
                Text(
                  '案件信息',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(width: 8.toW),
                // 行政标签
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.toW,
                    vertical: 2.toW,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color_FFF5F7FA,
                    borderRadius: BorderRadius.circular(4.toW),
                  ),
                  child: Text(
                    caseTypeText,
                    style: TextStyle(
                      fontSize: 12.toSp,
                      color: AppColors.color_99000000,
                    ),
                  ),
                ),
                const Spacer(),
                // 编辑案件按钮
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        '编辑案件',
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
          ),
          SizedBox(height: 8.toW),
          // 案件详细信息
          _buildInfoRow('案号:', caseDetail.caseBase?.caseNumber ?? '-'),
          SizedBox(height: 12.toW),
          _buildInfoRow(
            '案由:',
            caseDetail.caseBase?.caseReason != null &&
                    caseDetail.caseBase!.caseReason!.isNotEmpty
                ? caseDetail.caseBase!.caseReason!
                : '-',
          ),
          SizedBox(height: 12.toW),
          _buildInfoRow(
            '受理法院:',
            caseDetail.caseBase?.receivingUnit != null &&
                    caseDetail.caseBase!.receivingUnit!.isNotEmpty
                ? caseDetail.caseBase!.receivingUnit!
                : '-',
          ),
          SizedBox(height: 12.toW),
          _buildInfoRow('当事人:', roleText),
          SizedBox(height: 12.toW),
          _buildInfoRow(
            '承办人:',
            caseDetail.caseBase?.handler != null &&
                    caseDetail.caseBase!.handler!.isNotEmpty
                ? caseDetail.caseBase!.handler!
                : '-',
          ),
          SizedBox(height: 12.toW),
          _buildInfoRow('电话:', caseDetail.caseBase?.handlerPhone ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.toSp, color: AppColors.color_99000000),
        ),
        SizedBox(width: 4.toW),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ),
      ],
    );
  }

  String getRuleText(int rule) {
    switch (rule) {
      case 1:
        return '原告';
      case 2:
        return '被告';
      case 3:
        return '第三人';
      case 4:
        return '申请人';
      case 5:
        return '被申请人';
      case 6:
        return '委托人';
      default:
        return '未知';
    }
  }
}
