class InviteRuleModel {
  int? inviteNum;
  int? rewardPoint;

  InviteRuleModel({this.inviteNum, this.rewardPoint});

  factory InviteRuleModel.fromJson(Map<String, dynamic> json) {
    return InviteRuleModel(
      inviteNum: json['inviteNum'] as int?,
      rewardPoint: json['rewardPoint'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'inviteNum': inviteNum,
    'rewardPoint': rewardPoint,
  };
}
