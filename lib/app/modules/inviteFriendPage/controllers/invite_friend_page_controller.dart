import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/inviteFriendPage/models/invite_rule_model.dart';
import 'package:lawyer_app/app/modules/inviteFriendPage/models/invite_user_model.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

/// 邀请记录模型
class InviteRecord {
  final String? avatar;
  final String phone;
  final String time;

  InviteRecord({this.avatar, required this.phone, required this.time});
}

class InviteFriendPageController extends GetxController {
  /// 已达成人数
  final achievedCount = 0.obs;

  /// 获得积分
  final totalPoints = 0.obs;

  /// 是否显示全部记录
  final showAll = false.obs;
  var pageNo = 1;
  bool isLoading = false;
  final inviteRules = <InviteRuleModel>[].obs;

  /// 邀请记录列表
  final inviteRecords = <InviteUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getInviteActivity();
    _loadInviteInfos();
    _loadInviteRecords();
  }

  void _getInviteActivity() async {
    var result = await NetUtils.get(Apis.inviteActivity, isLoading: false);
    if (result.code == NetCodeHandle.success) {
      inviteRules.value = (result.data['rules'] as List)
          .map((e) => InviteRuleModel.fromJson(e))
          .toList();
    }
  }

  /// 加载邀请记录
  void _loadInviteRecords() async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    var result = await NetUtils.get(
      Apis.brokerageUserChildSummary,
      isLoading: false,
      queryParameters: {'pageNo': pageNo, 'pageSize': 3},
    );
    if (result.code == NetCodeHandle.success) {
      final list = (result.data['list'] as List)
          .map((e) => InviteUserModel.fromJson(e))
          .toList();
      final total = result.data['total'] as int? ?? 0;
      if (pageNo == 1) {
        inviteRecords.value = list;
      } else {
        inviteRecords.value.addAll(list);
      }
      if (pageNo > 1) {
        showAll.value = inviteRecords.length >= total;
      }
    }
    isLoading = false;
  }

  void _loadInviteInfos() async {
    var result = await NetUtils.get(
      Apis.brokerageUserSummary,
      isLoading: false,
    );
    if (result.code == NetCodeHandle.success) {
      achievedCount.value = result.data['brokerageUserCount'] as int? ?? 0;
      totalPoints.value = result.data['totalPoints'] as int? ?? 0;
    }
  }

  /// 切换显示全部
  void toggleShowAll() {
    if (isLoading) {
      return;
    }

    pageNo += 1;
    _loadInviteRecords();
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
                    style: TextStyle(fontSize: 15.toSp, color: Colors.white),
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
