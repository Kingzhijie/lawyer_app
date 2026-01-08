import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/inviteFriendPage/models/invite_user_model.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/invite_friend_page_controller.dart';

class InviteFriendPageView extends GetView<InviteFriendPageController> {
  const InviteFriendPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F7FB),
      body: Stack(
        children: [
          // 顶部渐变背景
          _buildTopBackground(),
          // 内容
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 10.toW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      Height(20.toW),
                      _buildRewardSection(),
                      Height(10.toW),
                      _buildInviteRecordSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 顶部渐变背景
  Widget _buildTopBackground() {
    return ImageUtils(
      imageUrl: Assets.common.inviteBg.path,
      width: AppScreenUtil.screenWidth,
    );
  }

  /// 导航栏
  Widget _buildAppBar() {
    return Container(
      height: 44.toW,
      margin: EdgeInsets.only(top: AppScreenUtil.statusBarHeight),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, size: 20.toW, color: Colors.black),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  /// 头部区域
  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.toW),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Height(10.toW),
              Text(
                '邀请好友',
                style: TextStyle(
                  fontSize: 28.toSp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color_E6000000,
                ),
              ),
              Height(4.toW),
              Text(
                '赚积分可兑换会员',
                style: TextStyle(
                  fontSize: 18.toSp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.color_E6000000,
                ),
              ),
              Height(12.toW),
              Row(
                children: [
                  Text(
                    '好友首次注册，可获得积分',
                    style: TextStyle(
                      fontSize: 13.toSp,
                      color: AppColors.color_66000000,
                    ),
                  ),
                  Width(8.toW),
                  _buildRuleButton(),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: ImageUtils(
              imageUrl: Assets.common.inviteIcon.path,
              width: 184.toW,
            ),
          ),
        ],
      ),
    );
  }

  /// 规则按钮
  Widget _buildRuleButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.toW, vertical: 4.toW),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8A849), width: 1),
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Text(
        '规则',
        style: TextStyle(fontSize: 11.toSp, color: const Color(0xFFE8A849)),
      ),
    ).withOnTap(() {
      // 显示规则弹窗
      controller.showRuleDialog();
    });
  }

  /// 奖励区域
  Widget _buildRewardSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toW, vertical: 24.toW),
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.toW),
      ),
      child: Column(
        children: [
          // 奖励卡片和进度条
          _buildRewardCardsWithProgress(),
          Height(20.toW),
          // 操作按钮
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// 奖励卡片和进度条
  Widget _buildRewardCardsWithProgress() {
    return Column(
      children: [
        // 卡片行
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildRewardCard(Assets.common.jifen10.path, '达成1人', 0, 10),
            _buildRewardCard(Assets.common.jifen20.path, '达成3人', 1, 20),
            _buildRewardCard(Assets.common.jifen30.path, '达成10人', 2, 30),
            _buildRewardCard(Assets.common.jifen40.path, '达成50人', 3, 50),
          ],
        ),
        Height(16.toW),
        // 进度条
        _buildProgressBar(),
        Height(12.toW),
        // 目标文字
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTargetText('达成1人'),
            _buildTargetText('达成3人'),
            _buildTargetText('达成10人'),
            _buildTargetText('达成50人'),
          ],
        ),
      ],
    );
  }

  /// 奖励卡片
  Widget _buildRewardCard(
    String imagePath,
    String target,
    int index,
    int targetCount,
  ) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        ImageUtils(imageUrl: imagePath, width: 75.toW),
        if (index < 3)
          Positioned(
            child: Text(
              '$targetCount积分',
              style: TextStyle(
                color: Color(0xFFB16000),
                fontSize: 16.toSp,
                fontWeight: FontWeight.w600,
              ),
            ).withPaddingOnly(bottom: 3.toW),
          )
        else
          Positioned(
            child: Column(
              children: [
                ImageUtils(
                  imageUrl: Assets.common.jisxiIcon.path,
                  width: 38.toW,
                ),
                Text(
                  '惊喜福利',
                  style: TextStyle(
                    color: Color(0xFFB16000),
                    fontSize: 11.toSp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ).withPaddingOnly(bottom: 7.toW),
          ),
      ],
    );
  }

  /// 进度条
  Widget _buildProgressBar() {
    return Obx(() {
      final achievedCount = controller.achievedCount.value;

      return Row(
        children: [
          // 第一段：0-1人
          _buildProgressSegment(achievedCount >= 1, 0.22),
          _buildProgressDot(achievedCount >= 1),
          // 第二段：1-3人
          _buildProgressSegment(achievedCount >= 3, 0.22),
          _buildProgressDot(achievedCount >= 3),
          // 第三段：3-10人
          _buildProgressSegment(achievedCount >= 10, 0.22),
          _buildProgressDot(achievedCount >= 10),
          // 第四段：10-50人
          _buildProgressSegment(achievedCount >= 50, 0.22),
          _buildProgressDot(achievedCount >= 50),
        ],
      );
    });
  }

  /// 进度条片段
  Widget _buildProgressSegment(bool isActive, double flex) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Container(
        height: 4.toW,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8A849) : const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(2.toW),
        ),
      ),
    );
  }

  /// 进度点
  Widget _buildProgressDot(bool isActive) {
    return Container(
      width: 12.toW,
      height: 12.toW,
      margin: EdgeInsets.symmetric(horizontal: 4.toW),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8A849) : const Color(0xFFE5E5E5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: const Color(0xFFE8A849).withValues(alpha: 0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
        ],
      ),
    );
  }

  /// 目标文字
  Widget _buildTargetText(String text) {
    return SizedBox(
      width: 75.toW,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.toSp, color: AppColors.color_66000000),
      ),
    );
  }

  /// 操作按钮
  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Row(
        children: [
          Expanded(
            child: _buildOutlineButton('发送邀请海报', () {
              controller.sendInvitePoster();
            }),
          ),
          Width(12.toW),
          Expanded(
            child: _buildFilledButton('邀请微信好友', () {
              controller.inviteWechatFriend();
            }),
          ),
        ],
      ),
    );
  }

  /// 边框按钮
  Widget _buildOutlineButton(String text, VoidCallback onTap) {
    return Container(
      height: 48.toW,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.color_line, width: 1),
        borderRadius: BorderRadius.circular(24.toW),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 15.toSp, color: AppColors.color_E6000000),
        ),
      ),
    ).withOnTap(onTap);
  }

  /// 填充按钮
  Widget _buildFilledButton(String text, VoidCallback onTap) {
    return Container(
      height: 48.toW,
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(24.toW),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 15.toSp, color: Colors.white),
        ),
      ),
    ).withOnTap(onTap);
  }

  /// 邀请记录区域
  Widget _buildInviteRecordSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      padding: EdgeInsets.all(16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '邀请记录',
            style: TextStyle(
              fontSize: 16.toSp,
              fontWeight: FontWeight.w600,
              color: AppColors.color_E6000000,
            ),
          ),
          Height(16.toW),
          _buildStatisticsRow(),
          Height(10.toW),
          _buildInviteList(),
        ],
      ),
    );
  }

  /// 统计行
  Widget _buildStatisticsRow() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8.toW),
      ),
      padding: EdgeInsets.symmetric(vertical: 6.toW),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${controller.achievedCount.value}',
                        style: TextStyle(
                          fontSize: 20.toSp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                      Text(
                        '人',
                        style: TextStyle(
                          fontSize: 14.toSp,
                          color: AppColors.color_66000000,
                        ),
                      ).withPaddingOnly(top: 3.toW),
                    ],
                  ),
                  Height(4.toW),
                  Text(
                    '已达成人数',
                    style: TextStyle(
                      fontSize: 14.toSp,
                      color: AppColors.color_66000000,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${controller.totalPoints.value}',
                    style: TextStyle(
                      fontSize: 22.toSp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color_E6000000,
                    ),
                  ),
                  Height(4.toW),
                  Text(
                    '获得积分',
                    style: TextStyle(
                      fontSize: 13.toSp,
                      color: AppColors.color_66000000,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 邀请列表
  Widget _buildInviteList() {
    return Obx(() {
      final records = controller.inviteRecords;
      final showCount = controller.showAll.value
          ? records.length
          : 3.clamp(0, records.length);

      return Column(
        children: [
          ...records.map((record) => _buildInviteItem(record)),
          if (records.length > 3) _buildShowMoreButton(),
        ],
      );
    });
  }

  /// 邀请项
  Widget _buildInviteItem(InviteUserModel record) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.toW),
      child: Row(
        children: [
          // 头像
          ClipOval(
            child: record.avatar != null
                ? Image.network(
                    record.avatar!,
                    width: 32.toW,
                    height: 32.toW,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                  )
                : _buildDefaultAvatar(),
          ),
          Width(12.toW),
          // 手机号
          Expanded(
            child: Text(
              record.nickname ?? '',
              style: TextStyle(
                fontSize: 13.toSp,
                color: AppColors.color_E6000000,
              ),
            ),
          ),
          // 时间
          Text(
            DateTimeUtils.formatTimestamp(record.brokerageTime ?? 0),
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_99000000,
            ),
          ),
        ],
      ),
    );
  }

  /// 默认头像
  Widget _buildDefaultAvatar() {
    return Container(
      width: 40.toW,
      height: 40.toW,
      decoration: BoxDecoration(
        color: AppColors.color_FFF3F3F3,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 24.toW, color: AppColors.color_99000000),
    );
  }

  /// 显示更多按钮
  Widget _buildShowMoreButton() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: 5.toW),
        child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.showAll.value ? '收起' : '更多',
                  style: TextStyle(
                    fontSize: 13.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
                Icon(
                  controller.showAll.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16.toW,
                  color: AppColors.color_99000000,
                ),
              ],
            ).withOnTap(() {
              controller.toggleShowAll();
            }),
      ),
    );
  }
}
