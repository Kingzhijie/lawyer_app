import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseBaseInfoWidget extends StatelessWidget {
  const CaseBaseInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                // 质保标签
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
                    '质保',
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
                    '行政',
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
          _buildInfoRow('案号:', '2023粤0105民初1234号'),
          SizedBox(height: 12.toW),
          _buildInfoRow('案由:', '合同纠纷'),
          SizedBox(height: 12.toW),
          _buildInfoRow('受理法院:', '广州市天河区人民法院'),
          SizedBox(height: 12.toW),
          _buildInfoRow('当事人:', '张三(原告) 李四(被告)'),
          SizedBox(height: 12.toW),
          _buildInfoRow('承办人:', '李林顿'),
          SizedBox(height: 12.toW),
          _buildInfoRow('电话:', '13754398543'),
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
}
