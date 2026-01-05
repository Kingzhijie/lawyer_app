import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/doc_list_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class CaseRelatedCertificateWidget extends StatelessWidget {
  final List<DocListModel> docList;
  final VoidCallback onCheckDocsTap;
  const CaseRelatedCertificateWidget({
    super.key,
    required this.docList,
    required this.onCheckDocsTap,
  });

  @override
  Widget build(BuildContext context) {
    final documents = docList.take(2).toList();
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
                onTap: onCheckDocsTap,
                behavior: HitTestBehavior.opaque,
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
              return _buildDocumentItem(doc);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(DocListModel item) {
    return Container(
      padding: EdgeInsets.all(12.toW),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Row(
        children: [
          // 文档图标
          ImageUtils(
            imageUrl: Assets.home.caseDocIcon.path,
            width: 48.toW,
            height: 48.toW,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10.toW),
          // 文档信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.docTitle != null && item.docTitle!.isNotEmpty
                      ? item.docTitle!
                      : '-',
                  style: TextStyle(
                    fontSize: 15.toSp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 4.toW),
                Text(
                  '更新于: ${DateTimeUtils.formatTimestamp(item.updateTime ?? 0)}',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.toW),
          // 查看图标
          if (item.fileUrl != null && item.fileUrl!.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showToast('弹窗查看图片');
              },
              child: Icon(
                Icons.remove_red_eye_outlined,
                size: 20.toW,
                color: AppColors.color_99000000,
              ),
            ),
        ],
      ),
    );
  }
}
