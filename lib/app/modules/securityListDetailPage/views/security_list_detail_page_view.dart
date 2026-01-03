import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../utils/image_utils.dart';
import '../controllers/security_list_detail_page_controller.dart';

class SecurityListDetailPageView
    extends GetView<SecurityListDetailPageController> {
  const SecurityListDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ImageUtils(
              imageUrl: Assets.home.homeBg.path,
              width: AppScreenUtil.screenWidth,
            ),
          ),
          _buildTopBar(),

          SingleChildScrollView(
            child: Column(
              children: [_buildCaseInfoCard(), _buildSecurityListSection()],
            ),
          ).withMarginOnly(top: AppScreenUtil.navigationBarHeight)
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: AppScreenUtil.navigationBarHeight,
      padding: EdgeInsets.only(top: AppScreenUtil.statusBarHeight),
      child: Row(
        children: [
          Container(
            width: 44.toW,
            height: 44.toW,
            padding: EdgeInsets.only(left: 5.toW),
            child: Icon(
              Icons.arrow_back_ios,
              size: 22.toW,
              color: AppColors.color_E6000000,
            ),
          ).withOnTap(() => Get.back()),
          Expanded(
            child: Obx(
              () => Text(
                controller.caseInfo['title'] ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
            ),
          ),
          SizedBox(width: 44.toW),
        ],
      ),
    );
  }

  Widget _buildCaseInfoCard() {
    return Obx(() {
      final caseInfo = controller.caseInfo;
      if (caseInfo.isEmpty) return const SizedBox.shrink();
      return Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 8.toW),
            padding: EdgeInsets.all(16.toW),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(14.toW),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  Assets.home.yuangaoBg.path,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '案件基本信息',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 16.toW),
                _buildInfoRow('案号：', caseInfo['caseNumber'] ?? ''),
                SizedBox(height: 10.toW),
                _buildInfoRow('案由：', caseInfo['caseReason'] ?? ''),
                SizedBox(height: 10.toW),
                _buildInfoRow('受理法院：', caseInfo['court'] ?? ''),
                SizedBox(height: 10.toW),
                _buildInfoRow('当事人：', caseInfo['parties'] ?? ''),
              ],
            ),
          ),
          // 右上角印章
          Positioned(
            right: 19.toW,
            top: 10.toW,
            child: ImageUtils(imageUrl: Assets.home.yuangaoIcon.path, width: 58.toW),
          ),
        ],
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.toSp, color: AppColors.color_66000000),
        ),
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

  Widget _buildSecurityListSection() {
    return Obx(() {
      final list = controller.securityList;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.toW),
        padding: EdgeInsets.all(16.toW),
        decoration: BoxDecoration(
          color: AppColors.color_white,
          borderRadius: BorderRadius.circular(12.toW),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 16,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '保全事项(${list.length})',
              style: TextStyle(
                fontSize: 16.toSp,
                fontWeight: FontWeight.w600,
                color: AppColors.color_E6000000,
              ),
            ),
            SizedBox(height: 12.toW),
            ListView.builder(
              itemCount: list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index){
                  var entry = list.asMap()[index];
                  final isLast = index == list.length - 1;
              return _buildSecurityItem(entry!, isLast);
            })
          ],
        ),
      );
    });
  }

  Widget _buildSecurityItem(Map<String, dynamic> item, bool isLast) {
    return Container(
      padding: EdgeInsets.all(14.toW),
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12.toW),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemRow('保全对象：', item['target'] ?? ''),
          SizedBox(height: 8.toW),
          _buildItemRow('涉及账户/资产：', item['account'] ?? ''),
          SizedBox(height: 8.toW),
          _buildItemRow('实际冻结金额：', item['amount'] ?? ''),
          SizedBox(height: 8.toW),
          _buildItemRow('到期日：', item['dueDate'] ?? ''),
        ],
      ),
    );
  }

  Widget _buildItemRow(String label, String value) {
    final isAmount = label.contains('金额');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.toSp, color: AppColors.color_99000000),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.toSp,
              color: isAmount
                  ? const Color(0xFFE34D59)
                  : AppColors.color_E6000000,
              fontWeight: isAmount ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
