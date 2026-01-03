import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

class CaseRelatedCertificateWidget extends StatelessWidget {
  const CaseRelatedCertificateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 模拟文书数据
    final documents = [
      {'title': '起诉状', 'updateTime': '2026-08-12'},
      {'title': '起诉状', 'updateTime': '2026-08-12'},
    ];

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
                '相关文书',
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
                      '更多',
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
          // 文书列表
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: documents.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.toW),
            itemBuilder: (context, index) {
              final doc = documents[index];
              return _buildDocumentItem(
                doc['title'] as String,
                doc['updateTime'] as String,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String title, String updateTime) {
    return Container(
      padding: EdgeInsets.all(12.toW),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Row(
        children: [
          // 文档图标
          Container(
            width: 40.toW,
            height: 40.toW,
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0),
              borderRadius: BorderRadius.circular(8.toW),
            ),
            child: Icon(Icons.description, size: 24.toW, color: Colors.white),
          ),
          SizedBox(width: 12.toW),
          // 文档信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.toSp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 4.toW),
                Text(
                  '更新于: $updateTime',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
              ],
            ),
          ),
          // 查看图标
          Icon(
            Icons.remove_red_eye_outlined,
            size: 20.toW,
            color: AppColors.color_99000000,
          ),
        ],
      ),
    );
  }
}
