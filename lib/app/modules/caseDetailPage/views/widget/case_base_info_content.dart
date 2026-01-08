import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/empty_content_widget.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/string_extension.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_detail_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_party_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../../controllers/case_detail_page_controller.dart';

class CaseBaseInfoContent extends StatelessWidget {
  final CaseDetailPageController controller;
  const CaseBaseInfoContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight + 12.toW),
      child: Obx(() {
        final caseDetail = controller.caseDetail.value!;
        return Column(
          children: [
            Height(12.toW),
            _setCaseBaseInfoWidget(caseDetail),
            Height(12.toW),
            _setPartyInfoWidget(caseDetail),
            Height(12.toW),
            _setCaseSummaryWidget(caseDetail),
            Height(12.toW),
            _setLawyerFeeWidget(caseDetail),
          ],
        );
      }),
    );
  }

  Widget _setCaseBaseInfoWidget(CaseDetailModel caseDetail) {
    final roles = caseDetail.caseBase!.casePartyResVos ?? [];
    var roleText = '';
    for (var item in roles) {
      if (item.name != null && item.name!.isNotEmpty) {
        if (roleText.isEmpty) {
          roleText += '${item.name}';
        } else {
          roleText += '/${item.name}';
        }
      }
    }
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
              if (caseDetail.caseBase?.status != 2)
                GestureDetector(
                  onTap: () {
                    controller.onCaseBaseInfoEdit();
                  },
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
          _buildInfoRow(
            '案号',
            controller.caseDetail.value?.caseBase?.caseNumber ?? '-',
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '案由',
            controller.caseDetail.value?.caseBase?.caseReason != null &&
                    controller
                        .caseDetail
                        .value!
                        .caseBase!
                        .caseReason!
                        .isNotEmpty
                ? controller.caseDetail.value!.caseBase!.caseReason!
                : '-',
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '立案日期',
            DateTimeUtils.formatTimestamp(
              controller.caseDetail.value!.caseBase?.createTime ?? 0,
            ),
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '承办律师',
            controller.caseDetail.value?.caseBase?.primaryLawyer != null &&
                    controller
                        .caseDetail
                        .value!
                        .caseBase!
                        .primaryLawyer!
                        .isNotEmpty
                ? controller.caseDetail.value!.caseBase!.primaryLawyer!
                : '-',
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '协办律师',
            controller.caseDetail.value?.caseBase?.assistantLawyer != null &&
                    controller
                        .caseDetail
                        .value!
                        .caseBase!
                        .assistantLawyer!
                        .isNotEmpty
                ? controller.caseDetail.value!.caseBase!.assistantLawyer!
                : '-',
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow('客户/委托人', roleText),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '承办人',
            controller.caseDetail.value!.caseBase?.handler != null &&
                    controller.caseDetail.value!.caseBase!.handler!.isNotEmpty
                ? controller.caseDetail.value!.caseBase!.handler!
                : '-',
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '受理法院',
            controller.caseDetail.value!.caseBase?.receivingUnit != null &&
                    controller
                        .caseDetail
                        .value!
                        .caseBase!
                        .receivingUnit!
                        .isNotEmpty
                ? controller.caseDetail.value!.caseBase!.receivingUnit!
                : '-',
          ),
          SizedBox(height: 16.toW),
          _buildInfoRow(
            '法官电话',
            controller.caseDetail.value!.caseBase?.judgePhone != null &&
                    controller
                        .caseDetail
                        .value!
                        .caseBase!
                        .judgePhone!
                        .isNotEmpty
                ? controller.caseDetail.value!.caseBase!.judgePhone!
                : '-',
          ),
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
  Widget _setPartyInfoWidget(CaseDetailModel caseDetail) {
    final casePartyResVOS = caseDetail.caseBase?.casePartyResVos ?? [];
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
              if (caseDetail.caseBase?.status != 2)
                GestureDetector(
                  onTap: () {
                    controller.editConcernedPerson();
                  },
                  child: Text(
                    '新增',
                    style: TextStyle(fontSize: 14.toSp, color: AppColors.theme),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.toW),
          if (casePartyResVOS.isEmpty)
            EmptyContentWidget()
          else
            ...casePartyResVOS.asMap().entries.map((item) {
              return _buildPartyItem(index: item.key, item: item.value);
            }),
        ],
      ),
    );
  }

  Widget _buildPartyItem({required int index, required CasePartyModel item}) {
    return Obx(() {
      final isExpanded = controller.partyExpandedList[index];

      return item.name != null && item.name!.isNotEmpty
          ? GestureDetector(
              onTap: () => controller.togglePartyExpanded(index),
              child: Container(
                margin: EdgeInsets.only(bottom: 12.toW),
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
                        if (item.partyRole == 1 || item.partyRole == 2)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.toW,
                              vertical: 4.toW,
                            ),
                            decoration: BoxDecoration(
                              color: item.partyRole == 2
                                  ? const Color(0xFF52C41A)
                                  : const Color(0xFFFF4D4F),
                              borderRadius: BorderRadius.circular(4.toW),
                            ),
                            child: Text(
                              item.partyRole == 2 ? '被告' : '原告',
                              style: TextStyle(
                                fontSize: 12.toSp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        SizedBox(width: 8.toW),
                        // 姓名
                        Expanded(
                          child: Text(
                            item.name != null && item.name!.isNotEmpty
                                ? item.name!
                                : '-',
                            style: TextStyle(
                              fontSize: 15.toSp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.color_E6000000,
                            ),
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
                              color: item.partyType == 1
                                  ? AppColors.theme
                                  : const Color(0xFFFF9800),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(4.toW),
                          ),
                          child: Text(
                            item.partyType == 1 ? '个人' : '公司',
                            style: TextStyle(
                              fontSize: 10.toSp,
                              color: item.partyType == 1
                                  ? AppColors.theme
                                  : const Color(0xFFFF9800),
                            ),
                          ),
                        ),
                        // 委托人标签
                        if (item.partyRole == 6)
                          Container(
                            margin: EdgeInsets.only(left: 6.toW),
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.toW,
                              vertical: 3.toW,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF52C41A),
                              borderRadius: BorderRadius.circular(4.toW),
                            ),
                            child: Text(
                              '委托人',
                              style: TextStyle(
                                fontSize: 10.toSp,
                                color: Colors.white,
                              ),
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
                    if (isExpanded) ...[
                      SizedBox(height: 12.toW),
                      if (item.phone != null && item.phone!.isNotEmpty) ...[
                        _buildDetailRow('联系方式', item.phone!),
                      ],
                      if (item.idNumber != null &&
                          item.idNumber!.isNotEmpty) ...[
                        SizedBox(height: 8.toW),
                        _buildDetailRow('身份证号码', item.idNumber!),
                      ],
                      if (item.address != null && item.address!.isNotEmpty) ...[
                        SizedBox(height: 8.toW),
                        _buildDetailRow('地址', item.address!),
                      ],
                      if ((item.gender ?? 0) > 0) ...[
                        SizedBox(height: 8.toW),
                        _buildDetailRow('性别', item.gender == 1 ? '男' : '女'),
                      ],
                    ],
                  ],
                ),
              ),
            )
          : SizedBox.shrink();
    });
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
  Widget _setCaseSummaryWidget(CaseDetailModel caseDetail) {
    final summaryObj = json.decode(caseDetail.caseBase?.caseSummary ?? '{}');
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
          _buildSummarySection('争议焦点', summaryObj['争议焦点'] ?? '-'),
          SizedBox(height: 16.toW),
          // 事实概述
          _buildSummarySection('事实概述', summaryObj['事实概述'] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, String content) {
    return Container(
      width: double.infinity,
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
  Widget _setLawyerFeeWidget(CaseDetailModel caseDetail) {
    final feeInfo = caseDetail.agencyFeeInfo;
    var type = '';
    // 1定额收费 2风险收费 3计时收费 4计件收费 5免费
    switch (feeInfo?.feeType) {
      case 1:
        type = '定额收费';
        break;
      case 2:
        type = '风险收费';
        break;
      case 3:
        type = '计时收费';
        break;
      case 4:
        type = '计件收费';
        break;
      case 5:
        type = '免费';
        break;
      default:
    }

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
              if (caseDetail.caseBase?.status != 2)
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

          if (feeInfo != null) ...[
            SizedBox(height: 16.toW),
            // 信息列表
            _buildInfoRow('收费方式:', type),
            SizedBox(height: 16.toW),
            _buildInfoRow(
              '代理费:',
              ((feeInfo.agencyFee ?? 0) / 100).toString().toRMBPrice(
                fractionDigits: 2,
              ),
            ),
            SizedBox(height: 16.toW),
            _buildInfoRow(
              '我的标:',
              ((feeInfo.targetAmount ?? 0) / 100).toString().toRMBPrice(
                fractionDigits: 2,
              ),
            ),
            SizedBox(height: 16.toW),
            _buildInfoRow('标的物', feeInfo.targetObject ?? '-'),
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
                  feeInfo.feeIntro ?? '-',
                  style: TextStyle(
                    fontSize: 14.toSp,
                    color: AppColors.color_E6000000,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ] else
            EmptyContentWidget(),
        ],
      ),
    );
  }

  String getPartyRole(num index) {
    switch (index) {
      case 1:
        return '原告';
      case 2:
        return '被告';
      case 3:
        return '第三人 ';
      case 4:
        return '申请人';
      case 5:
        return '被申请人 ';
      case 6:
        return '委托人';
      default:
        return '';
    }
  }
}
