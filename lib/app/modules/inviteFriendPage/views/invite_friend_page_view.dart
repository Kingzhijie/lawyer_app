import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/invite_friend_page_controller.dart';

class InviteFriendPageView extends GetView<InviteFriendPageController> {
  const InviteFriendPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 顶部渐变背景
          _buildTopBackground(),
          // 内容
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        Height(20.toW),
                        _buildRewardSection(),
                        Height(20.toW),
                        _buildActionButtons(),
                        Height(20.toW),
                        _buildInviteRecordSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 顶部渐变背景
  Widget _buildTopBackground() {
    return Container(
      height: 350.toW,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E8),
            Color(0xFFFFFBF3),
            Colors.white,
          ],
        ),
      ),
    );
  }

  /// 导航栏
  Widget _buildAppBar() {
    return SizedBox(
      height: 44.toW,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ),
          // 右侧礼物图标
          Image.asset(
            Assets.my.inviteFriend.path,
            width: 100.toW,
            height: 100.toW,
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
        style: TextStyle(
          fontSize: 11.toSp,
          color: const Color(0xFFE8A849),
        ),
      ),
    ).withOnTap(() {
      // 显示规则弹窗
      controller.showRuleDialog();
    });
  }

  /// 奖励区域
  Widget _buildRewardSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Column(
        children: [
          // 奖励卡片
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRewardCard('10积分', '达成1人', 0),
              _buildRewardCard('20积分', '达成3人', 1),
              _buildRewardCard('30积分', '达成10人', 2),
              _buildSurpriseCard('惊喜福利', '达成50人'),
            ],
          ),
        ],
      ),
    );
  }

  /// 奖励卡片
  Widget _buildRewardCard(String points, String target, int index) {
    final isAchieved = controller.achievedCount.value >= [1, 3, 10][index];
    return Column(
      children: [
        Container(
          width: 75.toW,
          height: 75.toW,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isAchieved
                  ? [const Color(0xFFFFD700), const Color(0xFFFFA500)]
                  : [const Color(0xFFFFF5E0), const Color(0xFFFFEBC8)],
            ),
            borderRadius: BorderRadius.circular(12.toW),
            border: Border.all(
              color: const Color(0xFFFFD700),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                points,
                style: TextStyle(
                  fontSize: 16.toSp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8B4513),
                ),
              ),
              Height(4.toW),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.toW, vertical: 2.toW),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8.toW),
                ),
                child: Text(
                  isAchieved ? '已领取' : '未领取',
                  style: TextStyle(
                    fontSize: 9.toSp,
                    color: const Color(0xFF8B4513),
                  ),
                ),
              ),
            ],
          ),
        ),
        Height(8.toW),
        Text(
          target,
          style: TextStyle(
            fontSize: 12.toSp,
            color: AppColors.color_66000000,
          ),
        ),
      ],
    );
  }

  /// 惊喜福利卡片
  Widget _buildSurpriseCard(String title, String target) {
    return Column(
      children: [
        Container(
          width: 75.toW,
          height: 75.toW,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF5E0), Color(0xFFFFEBC8)],
            ),
            borderRadius: BorderRadius.circular(12.toW),
            border: Border.all(
              color: const Color(0xFFFFD700),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.card_giftcard,
                size: 28.toW,
                color: const Color(0xFFE8A849),
              ),
              Height(4.toW),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.toSp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8B4513),
                ),
              ),
            ],
          ),
        ),
        Height(8.toW),
        Text(
          target,
          style: TextStyle(
            fontSize: 12.toSp,
            color: AppColors.color_66000000,
          ),
        ),
      ],
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
          style: TextStyle(
            fontSize: 15.toSp,
            color: AppColors.color_E6000000,
          ),
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
          style: TextStyle(
            fontSize: 15.toSp,
            color: Colors.white,
          ),
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
          Height(16.toW),
          Divider(height: 1, color: AppColors.color_line),
          Height(8.toW),
          _buildInviteList(),
        ],
      ),
    );
  }

  /// 统计行
  Widget _buildStatisticsRow() {
    return Obx(() => Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '${controller.achievedCount.value}人',
                style: TextStyle(
                  fontSize: 22.toSp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color_E6000000,
                ),
              ),
              Height(4.toW),
              Text(
                '已达成人数',
                style: TextStyle(
                  fontSize: 13.toSp,
                  color: AppColors.color_66000000,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 40.toW,
          color: AppColors.color_line,
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
    ));
  }

  /// 邀请列表
  Widget _buildInviteList() {
    return Obx(() {
      final records = controller.inviteRecords;
      final showCount = controller.showAll.value ? records.length : 3.clamp(0, records.length);
      
      return Column(
        children: [
          ...records.take(showCount).map((record) => _buildInviteItem(record)),
          if (records.length > 3)
            _buildShowMoreButton(),
        ],
      );
    });
  }

  /// 邀请项
  Widget _buildInviteItem(InviteRecord record) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.toW),
      child: Row(
        children: [
          // 头像
          ClipOval(
            child: record.avatar != null
                ? Image.network(
                    record.avatar!,
                    width: 40.toW,
                    height: 40.toW,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                  )
                : _buildDefaultAvatar(),
          ),
          Width(12.toW),
          // 手机号
          Expanded(
            child: Text(
              record.phone,
              style: TextStyle(
                fontSize: 15.toSp,
                color: AppColors.color_E6000000,
              ),
            ),
          ),
          // 时间
          Text(
            record.time,
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
      child: Icon(
        Icons.person,
        size: 24.toW,
        color: AppColors.color_99000000,
      ),
    );
  }

  /// 显示更多按钮
  Widget _buildShowMoreButton() {
    return Obx(() => Padding(
      padding: EdgeInsets.only(top: 8.toW),
      child: Row(
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
    ));
  }
}
