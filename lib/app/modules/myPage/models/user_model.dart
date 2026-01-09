/// id : 1
/// nickname : "芋艿"
/// avatar : "https://www.iocoder.cn/xxx.png"
/// mobile : "15601691300"
/// sex : 1
/// point : 10
/// experience : 1024
/// level : {"id":1,"name":"芋艿","level":1,"icon":"https://www.iocoder.cn/yudao.jpg"}
/// brokerageEnabled : true
/// hasTeamOffice : true
/// hasNonLitigation : true
/// pkgEffectiveTime : ""

class UserModel {
  UserModel({
    num? id,
    String? nickname,
    String? avatar,
    String? mobile,
    num? sex, //1男性, 2女性, 0未填写
    num? point,
    num? experience,
    Level? level,
    bool? brokerageEnabled,
    bool? hasTeamOffice,
    bool? hasNonLitigation,
    int? pkgEffectiveTime,
  }) {
    _id = id;
    _nickname = nickname;
    _avatar = avatar;
    _mobile = mobile;
    _sex = sex;
    _point = point;
    _experience = experience;
    _level = level;
    _brokerageEnabled = brokerageEnabled;
    _hasTeamOffice = hasTeamOffice;
    _hasNonLitigation = hasNonLitigation;
    _pkgEffectiveTime = pkgEffectiveTime;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _nickname = json['nickname'];
    _avatar = json['avatar'];
    _mobile = json['mobile'];
    _sex = json['sex'];
    _point = json['point'];
    _experience = json['experience'];
    _level = json['level'] != null ? Level.fromJson(json['level']) : null;
    _brokerageEnabled = json['brokerageEnabled'];
    _hasTeamOffice = json['hasTeamOffice'];
    _hasNonLitigation = json['hasNonLitigation'];
    _pkgEffectiveTime = json['pkgEffectiveTime'];
  }
  num? _id;
  String? _nickname;
  String? _avatar;
  String? _mobile;
  num? _sex;
  num? _point;
  num? _experience;
  Level? _level;
  bool? _brokerageEnabled;
  bool? _hasTeamOffice;
  bool? _hasNonLitigation;
  int? _pkgEffectiveTime;
  UserModel copyWith({
    num? id,
    String? nickname,
    String? avatar,
    String? mobile,
    num? sex,
    num? point,
    num? experience,
    Level? level,
    bool? brokerageEnabled,
    bool? hasTeamOffice,
    bool? hasNonLitigation,
    int? pkgEffectiveTime,
  }) => UserModel(
    id: id ?? _id,
    nickname: nickname ?? _nickname,
    avatar: avatar ?? _avatar,
    mobile: mobile ?? _mobile,
    sex: sex ?? _sex,
    point: point ?? _point,
    experience: experience ?? _experience,
    level: level ?? _level,
    brokerageEnabled: brokerageEnabled ?? _brokerageEnabled,
    hasTeamOffice: hasTeamOffice ?? _hasTeamOffice,
    hasNonLitigation: hasNonLitigation ?? _hasNonLitigation,
    pkgEffectiveTime: pkgEffectiveTime ?? _pkgEffectiveTime,
  );
  num? get id => _id;
  String? get nickname => _nickname;
  String? get avatar => _avatar;
  String? get mobile => _mobile;
  num? get sex => _sex;
  num? get point => _point;
  num? get experience => _experience;
  Level? get level => _level;
  bool? get brokerageEnabled => _brokerageEnabled;
  bool? get hasTeamOffice => _hasTeamOffice;
  bool? get hasNonLitigation => _hasNonLitigation;
  int? get pkgEffectiveTime => _pkgEffectiveTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['nickname'] = _nickname;
    map['avatar'] = _avatar;
    map['mobile'] = _mobile;
    map['sex'] = _sex;
    map['point'] = _point;
    map['experience'] = _experience;
    if (_level != null) {
      map['level'] = _level?.toJson();
    }
    map['brokerageEnabled'] = _brokerageEnabled;
    map['hasTeamOffice'] = _hasTeamOffice;
    map['hasNonLitigation'] = _hasNonLitigation;
    map['pkgEffectiveTime'] = _pkgEffectiveTime;
    return map;
  }
}

/// id : 1
/// name : "芋艿"
/// level : 1
/// icon : "https://www.iocoder.cn/yudao.jpg"

class Level {
  Level({num? id, String? name, num? level, String? icon}) {
    _id = id;
    _name = name;
    _level = level;
    _icon = icon;
  }

  Level.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _level = json['level'];
    _icon = json['icon'];
  }
  num? _id;
  String? _name;
  num? _level;
  String? _icon;
  Level copyWith({num? id, String? name, num? level, String? icon}) => Level(
    id: id ?? _id,
    name: name ?? _name,
    level: level ?? _level,
    icon: icon ?? _icon,
  );
  num? get id => _id;
  String? get name => _name;
  num? get level => _level;
  String? get icon => _icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['level'] = _level;
    map['icon'] = _icon;
    return map;
  }
}
