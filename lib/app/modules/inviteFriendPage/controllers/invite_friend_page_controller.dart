import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

/// 邀请记录模型
class InviteRecord {
  final String? avatar;
  final String phone;
  final String time;

  InviteRecord({
    this.avatar,
    required this.phone,
    required this.time,
  });
}

class InviteFriendPageController extends GetxController {
  /// 已达成人数
  final achievedCount = 3.obs;
  
  /// 获得积分
  final totalPoints = 20.obs;
  
  /// 是否显示全部记录
  final showAll = false.obs;
  
  /// 邀请记录列表
  final inviteRecords = <InviteRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInviteRecords();
  }

  /// 加载邀请记录
  void _loadInviteRecords() {
    // 模拟数据
    inviteRecords.value = [
      InviteRecord(
        phone: '177****3342',
        time: '2025/09/17 12:21:22',
      ),
      InviteRecord(
        phone: '177****3342',
        time: '2025/09/17 12:21:22',
      ),
      InviteRecord(
        phone: '177****3342',
        time: '2025/09/17 12:21:22',
      ),
      InviteRecord(
        phone: '138****5566',
        time: '2025/09/16 10:30:00',
      ),
      InviteRecord(
        phone: '159****7788',
        time: '2025/09/15 09:15:30',
      ),
    ];
  }

  /// 切换显示全部
  void toggleShowAll() {
    showAll.value = !showAll.value;
  }

  /// 显示规则弹窗
  void showRuleDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.toW),
        ),
        child: Container(
          padding: EdgeInsets.all(20.toW),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '邀请规则',
                    style: TextStyle(
                      fontSize: 18.toSp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color_E6000000,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 16.toW),
              _buildRuleItem('1. 邀请好友首次注册成功，您可获得10积分奖励'),
              _buildRuleItem('2. 累计邀请1人，额外奖励10积分'),
              _buildRuleItem('3. 累计邀请3人，额外奖励20积分'),
              _buildRuleItem('4. 累计邀请10人，额外奖励30积分'),
              _buildRuleItem('5. 累计邀请50人，可获得惊喜福利'),
              _buildRuleItem('6. 积分可用于兑换会员权益'),
              SizedBox(height: 20.toW),
              SizedBox(
                width: double.infinity,
                height: 44.toW,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.toW),
                    ),
                  ),
                  child: Text(
                    '我知道了',
                    style: TextStyle(
                      fontSize: 15.toSp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.toW),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.toSp,
          color: AppColors.color_66000000,
          height: 1.5,
        ),
      ),
    );
  }

  /// 发送邀请海报
  void sendInvitePoster() {
    showToast('生成邀请海报中...');
    // TODO: 实现生成海报并分享功能
  }

  /// 邀请微信好友
  void inviteWechatFriend() {
    showToast('正在打开微信...');
    // TODO: 实现微信分享功能
  }
}
