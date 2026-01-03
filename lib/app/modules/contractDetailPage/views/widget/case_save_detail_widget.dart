import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseSaveDetailWidget extends StatelessWidget {
  const CaseSaveDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          // 标题行
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
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      '6处关联保全资产',
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
          // 保全资产信息
          Container(
            padding: EdgeInsets.all(12.toW),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(8.toW),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // 不动产
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 32.toW,
                            height: 32.toW,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.toW),
                            ),
                            child: Icon(
                              Icons.home_outlined,
                              size: 20.toW,
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                          SizedBox(width: 8.toW),
                          Text(
                            '不动产: ',
                            style: TextStyle(
                              fontSize: 14.toSp,
                              color: AppColors.color_99000000,
                            ),
                          ),
                          Text(
                            '2处',
                            style: TextStyle(
                              fontSize: 14.toSp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.color_E6000000,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 车辆
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 32.toW,
                            height: 32.toW,
                            decoration: BoxDecoration(
                              color: AppColors.theme.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.toW),
                            ),
                            child: Icon(
                              Icons.directions_car_outlined,
                              size: 20.toW,
                              color: AppColors.theme,
                            ),
                          ),
                          SizedBox(width: 8.toW),
                          Text(
                            '车辆: ',
                            style: TextStyle(
                              fontSize: 14.toSp,
                              color: AppColors.color_99000000,
                            ),
                          ),
                          Text(
                            '2台',
                            style: TextStyle(
                              fontSize: 14.toSp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.color_E6000000,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.toW),
                // 资金
                Row(
                  children: [
                    Container(
                      width: 32.toW,
                      height: 32.toW,
                      decoration: BoxDecoration(
                        color: const Color(0xFF52C41A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.toW),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 20.toW,
                        color: const Color(0xFF52C41A),
                      ),
                    ),
                    SizedBox(width: 8.toW),
                    Text(
                      '资金: ',
                      style: TextStyle(
                        fontSize: 14.toSp,
                        color: AppColors.color_99000000,
                      ),
                    ),
                    Text(
                      '¥29,920.00',
                      style: TextStyle(
                        fontSize: 14.toSp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color_E6000000,
                      ),
                    ),
                  ],
                ),
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
                '2026-02-15',
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
                '2026-02-28',
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
}
