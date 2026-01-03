import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../controllers/case_detail_page_controller.dart';

class CaseBaseInfoContent extends StatelessWidget {
  final CaseDetailPageController controller;
  const CaseBaseInfoContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight + 12.toW),
      child: Column(
        children: [
          Height(12.toW),
          _setCaseBaseInfoWidget(),
          Height(12.toW),
          _setPartyInfoWidget(),
          Height(12.toW),
          _setCaseSummaryWidget(),
          Height(12.toW),
          _setLawyerFeeWidget(),
        ],
      ),
    );
  }

  Widget _setCaseBaseInfoWidget() {
    return Container(
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
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '案件基本信息',
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '编辑',
                  style: TextStyle(fontSize: 14.toSp, color: AppColors.theme),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.toW),
          // 分割线
          Container(height: 0.5, color: AppColors.color_line),
          SizedBox(height: 16.toW),
          // 信息列表
          _buildInfoRow('案号', '2023粤0105民初1234号'),
          SizedBox(height: 16.toW),
          _buildInfoRow('案由', '合同纠纷'),
          SizedBox(height: 16.toW),
          _buildInfoRow('立案日期', '2025-09-24'),
          SizedBox(height: 16.toW),
          _buildInfoRow('承办律师', '祝律师'),
          SizedBox(height: 16.toW),
          _buildInfoRow('协办律师', '蔡律师  王律师'),
          SizedBox(height: 16.toW),
          _buildInfoRow('客户/委托人', '浙江互品云科技'),
          SizedBox(height: 16.toW),
          _buildInfoRow('承办人', '李林顿'),
          SizedBox(height: 16.toW),
          _buildInfoRow('受理法院', '广州市天河区人民法院'),
          SizedBox(height: 16.toW),
          _buildInfoRow('法官电话', '0571-98276822'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.toW,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.toSp,
              color: AppColors.color_99000000,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ),
      ],
    );
  }

  // 当事人/关联方
  Widget _setPartyInfoWidget() {
    return Container(
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
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '当事人/关联方',
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.editConcernedPerson();
                },
                child: Text(
                  '编辑',
                  style: TextStyle(fontSize: 14.toSp, color: AppColors.theme),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.toW),
          // 当事人列表
          Obx(
            () => _buildPartyItem(
              index: 0,
              name: '林玲',
              type: '被告',
              typeColor: const Color(0xFF52C41A),
              isIndividual: true,
              contact: '13800138000',
              idCard: '330102199001011234',
              address: '浙江省杭州市上城区某某街道123号',
              gender: '女',
            ),
          ),
          SizedBox(height: 12.toW),
          Obx(
            () => _buildPartyItem(
              index: 1,
              name: '浙江燕山机场',
              type: '原告',
              typeColor: const Color(0xFFFF4D4F),
              isIndividual: false,
              contact: '15263677322',
              idCard: '220182195403073083',
              address: '浙江省乐清市乐成镇环城东街89弄8号',
              gender: '女',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyItem({
    required int index,
    required String name,
    required String type,
    required Color typeColor,
    required bool isIndividual,
    String? contact,
    String? idCard,
    String? address,
    String? gender,
  }) {
    final isExpanded = controller.partyExpandedList[index];

    return GestureDetector(
      onTap: () => controller.togglePartyExpanded(index),
      child: Container(
        padding: EdgeInsets.all(12.toW),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8.toW),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部信息行
            Row(
              children: [
                // 类型标签
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.toW,
                    vertical: 4.toW,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(4.toW),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 12.toSp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8.toW),
                // 姓名
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15.toSp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(width: 8.toW),
                // 个人/公司标签
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.toW,
                    vertical: 2.toW,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isIndividual
                          ? AppColors.theme
                          : const Color(0xFFFF9800),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(4.toW),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isIndividual
                            ? Icons.person_outline
                            : Icons.business_outlined,
                        size: 12.toW,
                        color: isIndividual
                            ? AppColors.theme
                            : const Color(0xFFFF9800),
                      ),
                      SizedBox(width: 2.toW),
                      Text(
                        isIndividual ? '个人' : '公司',
                        style: TextStyle(
                          fontSize: 10.toSp,
                          color: isIndividual
                              ? AppColors.theme
                              : const Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // 委托人标签
                if (!isIndividual)
                  Container(
                    padding: EdgeInsets.all(4.toW),
                    decoration: BoxDecoration(
                      color: const Color(0xFF52C41A),
                      borderRadius: BorderRadius.circular(4.toW),
                    ),
                    child: Text(
                      '委托人',
                      style: TextStyle(fontSize: 10.toSp, color: Colors.white),
                    ),
                  ),
                SizedBox(width: 8.toW),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20.toW,
                  color: AppColors.color_99000000,
                ),
              ],
            ),
            // 展开的详细信息
            if (isExpanded && contact != null) ...[
              SizedBox(height: 12.toW),
              _buildDetailRow('联系方式', contact),
              SizedBox(height: 8.toW),
              _buildDetailRow('身份证号码', idCard ?? ''),
              SizedBox(height: 8.toW),
              _buildDetailRow('地址', address ?? ''),
              SizedBox(height: 8.toW),
              _buildDetailRow('性别', gender ?? ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.toW,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_99000000,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ),
      ],
    );
  }


  // 案件摘要
  Widget _setCaseSummaryWidget() {
    return Container(
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
            '案件摘要',
            style: TextStyle(
              fontSize: 16.toSp,
              fontWeight: FontWeight.w600,
              color: AppColors.color_E6000000,
            ),
          ),
          SizedBox(height: 16.toW),
          // 分割线
          Container(height: 0.5, color: AppColors.color_line),
          SizedBox(height: 16.toW),
          // 争议焦点
          _buildSummarySection(
            '争议焦点',
            '案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题',
          ),
          SizedBox(height: 16.toW),
          // 事实概述
          _buildSummarySection(
            '事实概述',
            '案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题',
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, String content) {
    return Container(
      padding: EdgeInsets.all(12.toW),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.toSp,
              fontWeight: FontWeight.w600,
              color: AppColors.color_E6000000,
            ),
          ),
          SizedBox(height: 8.toW),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_99000000,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

// 代理律师费
  Widget _setLawyerFeeWidget() {
    return Container(
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
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '代理律师费',
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.color_E6000000,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.attorneysFeePage();
                },
                child: Text(
                  '编辑',
                  style: TextStyle(fontSize: 14.toSp, color: AppColors.theme),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.toW),
          // 信息列表
          _buildInfoRow('收费方式:', '定额收费'),
          SizedBox(height: 16.toW),
          _buildInfoRow('代理费:', '¥12,727,838'),
          SizedBox(height: 16.toW),
          _buildInfoRow('我的标:', '¥12,727,838'),
          SizedBox(height: 16.toW),
          _buildInfoRow('标的物', '汽车'),
          SizedBox(height: 16.toW),
          // 收费标准
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '收费标准',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              SizedBox(height: 8.toW),
              Text(
                '案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问题案件核心法律问',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_E6000000,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}


