import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class NoFindCaseWidget extends StatefulWidget {
  const NoFindCaseWidget({super.key});

  @override
  State<NoFindCaseWidget> createState() => _NoFindCaseWidgetState();
}

class _NoFindCaseWidgetState extends State<NoFindCaseWidget> {
  int? selectedIndex;
  final TextEditingController searchController = TextEditingController();

  final List<CaseItem> pendingCases = [
    CaseItem(title: '王伟与李强的合同争议案'),
    CaseItem(title: '张伟与李强的合同纠纷案件'),
    CaseItem(title: '王伟与李强的合同争议案'),
  ];

  final List<CaseItem> ongoingCases = [
    CaseItem(title: '王伟诉李强合同争议案浙明初【2025】456号'),
    CaseItem(title: '张伟诉李强合同纠纷案浙明初【2025】789号'),
    CaseItem(title: '王伟诉李强合同争议案秦大哥好几十怀旧服电浙明初【2025】456号'),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.toW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部提示文字
          Text(
            '未查询到案件相关信息，请选择需要更新的案件：',
            style: TextStyle(
              fontSize: 18.toSp,
              color: AppColors.color_E6000000,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.toW),
          // 搜索框
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 12.toW),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.toW),
              border: Border.all(color: Color(0xFFEEEEEE), width: 0.5),
            ),
            child: Row(
              children: [
                ImageUtils(
                  imageUrl: Assets.home.searchIcon.path,
                  width: 15.toW,
                ),
                SizedBox(width: 8.toW),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: '请输入案件信息',
                      hintStyle: TextStyle(
                        fontSize: 14.toSp,
                        color: AppColors.color_66000000,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontSize: 14.toSp,
                      color: AppColors.color_E6000000,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.toW),
          // 待更新列表
          _setStatusWidget('待更新', pendingCases),
          _setStatusWidget('进行中', ongoingCases),
          SizedBox(height: 12.toW),
          // 确认按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: selectedIndex != null ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.theme,
                disabledBackgroundColor: AppColors.theme.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                '确认',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _setStatusWidget(String name, List<CaseItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 14.toSp, color: AppColors.color_99000000),
        ),
        SizedBox(height: 6.toW),
        ListView.builder(
          itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
          return _buildCaseItem(items[index].title, index, false);
        })
      ],
    );
  }

  Widget _buildCaseItem(String title, int index, bool isOngoing) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.toW),
        padding: EdgeInsets.symmetric(horizontal: 8.toW, vertical: 6.toW),
        decoration: BoxDecoration(
          color: Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12.toW),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageUtils(
              imageUrl: isSelected
                  ? Assets.home.selectCrileIcon.path
                  : Assets.home.unSelectCrileIcon.path,
              width: 20.toW,
            ),
            SizedBox(width: 6.toW),
            // 案件标题
            Text(
              title,
              style: TextStyle(fontSize: 14.toSp, color: Colors.black),
            ).withExpanded(),
          ],
        ),
      ),
    );
  }
}

class CaseItem {
  final String title;

  CaseItem({required this.title});
}
