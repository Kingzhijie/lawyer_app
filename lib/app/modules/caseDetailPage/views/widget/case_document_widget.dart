import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../controllers/case_detail_page_controller.dart';

class CaseDocumentWidget extends StatelessWidget {
  final CaseDetailPageController controller;
  const CaseDocumentWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // 模拟文档数据
    final documents = [
      {'title': '起诉状', 'updateTime': '2026-08-12'},
      {'title': '保全结果通知书', 'updateTime': '2026-08-12'},
    ];

    return SingleChildScrollView(
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
                  '案件文档(${documents.length})',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 16.toW),
                // 文档列表
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 12.toW),
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    return _buildDocumentItem(
                      title: doc['title'] as String,
                      updateTime: doc['updateTime'] as String,
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20.toW),
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String updateTime,
  }) {
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
          // 箭头图标
          Icon(
            Icons.arrow_forward_ios,
            size: 16.toW,
            color: AppColors.color_99000000,
          ),
        ],
      ),
    );
  }
}
