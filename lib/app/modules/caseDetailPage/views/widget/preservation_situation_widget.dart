import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../controllers/case_detail_page_controller.dart';

class PreservationSituationWidget extends StatelessWidget {
  final CaseDetailPageController controller;
  const PreservationSituationWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // 模拟保全事项数据
    final preservationList = [
      {
        'target': '杭州韩秀美学医疗美容门诊部有限公司',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'date': '2026年10月16日',
      },
      {
        'target': '杭州韩秀美学医疗美容门诊部有限公司',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'date': '2026年10月16日',
      },
      {
        'target': '马星（个人）',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'date': '2026年10月16日',
      },
      {
        'target': '马星（个人）',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'date': '2026年10月16日',
      },
      {
        'target': '马星（个人）',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'date': '2026年10月16日',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight + 12.toW),
      child: Column(
        children: [
          SizedBox(height: 12.toW),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.toW),
            padding: EdgeInsets.all(16.toW),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.toW),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x0A000000),
                  blurRadius: 16,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                Text(
                  '保全事项(${preservationList.length})',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 16.toW),
                // 保全事项列表
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: preservationList.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 12.toW),
                  itemBuilder: (context, index) {
                    final item = preservationList[index];
                    return _buildPreservationItem(
                      target: item['target'] as String,
                      account: item['account'] as String,
                      amount: item['amount'] as String,
                      date: item['date'] as String,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreservationItem({
    required String target,
    required String account,
    required String amount,
    required String date,
  }) {
    return Container(
      padding: EdgeInsets.all(12.toW),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('保全对象:', target),
          SizedBox(height: 8.toW),
          _buildInfoRow('涉及账户/资产:', account),
          SizedBox(height: 8.toW),
          _buildInfoRow('实际冻结金额:', amount),
          SizedBox(height: 8.toW),
          _buildInfoRow('到期日:', date),
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
          style: TextStyle(fontSize: 13.toSp, color: AppColors.color_99000000),
        ),
        SizedBox(width: 4.toW),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ),
      ],
    );
  }
}
