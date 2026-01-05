import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_detail_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseDetailBaseInfo extends StatelessWidget {
  final CaseDetailModel caseDetail;
  const CaseDetailBaseInfo({super.key, required this.caseDetail});

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
    return Container(
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              // 原告标签
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
              // 案件标题
              Text(
                caseDetail.caseBase?.caseName ?? '',
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
              SizedBox(width: 8.toW),
              // 民事标签
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
            ],
          ),
          SizedBox(height: 16.toW),
          // 立项时间和立案准备
          Row(
            children: [
              Text(
                '立项时间: ',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              Text(
                DateTimeUtils.formatTimestamp(
                  caseDetail.caseBase?.createTime ?? 0,
                ),
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_E6000000,
                ),
              ),
              SizedBox(width: 16.toW),
              GestureDetector(
                onTap: () {},
                child: Text(
                  caseDetail.caseBase?.currentStage ?? '',
                  style: TextStyle(
                    fontSize: 14.toSp,
                    color: const Color(0xFFFF9800),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
