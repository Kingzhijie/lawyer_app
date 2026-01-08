class InviteUserModel {
  int? id;
  String? nickname;
  String? avatar;
  int? brokerageUserCount;
  int? brokerageTime;

  InviteUserModel({
    this.id,
    this.nickname,
    this.avatar,
    this.brokerageUserCount,
    this.brokerageTime,
  });

  factory InviteUserModel.fromJson(Map<String, dynamic> json) {
    return InviteUserModel(
      id: json['id'] as int?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      brokerageUserCount: json['brokerageUserCount'] as int?,
      brokerageTime: json['brokerageTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar': avatar,
      'brokerageUserCount': brokerageUserCount,
      'brokerageTime': brokerageTime,
    };
  }
}
