import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.toW),
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(14.toW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageUtils(
                imageUrl: Assets.home.anjianZongs.path,
                width: 20.toW,
                height: 20.toW,
              ),
              SizedBox(width: 8.toW),
              Text(
                '缴纳诉讼费',
                style: TextStyle(
                  fontSize: 15.toSp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color_E6000000,
                ),
              ),
              SizedBox(width: 6.toW),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.toW, vertical: 3.toW),
                decoration: BoxDecoration(
                  color: Color(0xFFFDECEE),
                  borderRadius: BorderRadius.circular(4.toW),
                ),
                child: Text(
                  '紧急',
                  style: TextStyle(
                    fontSize: 10.toSp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE34D59),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.toW, vertical: 5.toW),
                decoration: BoxDecoration(
                  color: AppColors.color_FFFDECEE,
                  borderRadius: BorderRadius.circular(12.toW),
                ),
                child: Text(
                  '原告',
                  style: TextStyle(
                    fontSize: 11.toSp,
                    color: AppColors.color_FF1F2937,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.toW),
          _infoRow('案件：', '张三诉讼李四合同纠纷案'),
          SizedBox(height: 6.toW),
          _infoRow('截止：', '2025-12-31'),
          SizedBox(height: 6.toW),
          _infoRow('承办人（法官）：', '李世斌'),
          SizedBox(height: 6.toW),
          _infoRow('电话：', '13759200942'),
          SizedBox(height: 12.toW),
          Row(
            children: [
              _avatar(Assets.home.yuangaoIcon.path),
              SizedBox(width: 8.toW),
              _avatar(Assets.home.beigaoIcon.path),
              const Spacer(),
              _smallButton('备注'),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.toSp,
            color: AppColors.color_66000000,
          ),
        ),
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

  Widget _avatar(String asset) {
    return Container(
      width: 32.toW,
      height: 32.toW,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber.shade50),
    );
  }

  Widget _smallButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toW, vertical: 5.toW),
      decoration: BoxDecoration(
        color: AppColors.color_FFEEEEEE,
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.toSp,
          color: AppColors.color_E6000000,
        ),
      ),
    );
  }
}

