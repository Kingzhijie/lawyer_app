/// id : 26584
/// status : 2
/// caseName : "赵六"
/// caseType : 1
/// casePartyRole : 0
/// caseProcedure : 0
/// caseNumber : ""
/// createTime : ""
/// todoTaskCount : 0
/// emergencyTaskCount : 0
/// relateUsers : [{"id":26584,"mobile":"15601691300","nickname":"李四","avatar":"https://www.iocoder.cn/x.png"}]
/// casePartyResVOS : [{"id":26584,"name":"李四","partyRole":0}]

class CaseBaseInfoModel {
  CaseBaseInfoModel({
    this.id,
    this.status,
    this.caseName,
    this.caseType,
    this.casePartyRole,
    this.caseProcedure,
    this.caseNumber,
    this.createTime,
    this.todoTaskCount,
    this.emergencyTaskCount,
    this.relateUsers,
    this.casePartyResVOS,
  });

  CaseBaseInfoModel.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    caseName = json['caseName'];
    caseType = json['caseType'];
    casePartyRole = json['casePartyRole'];
    caseProcedure = json['caseProcedure'];
    caseNumber = json['caseNumber'];
    createTime = json['createTime'];
    todoTaskCount = json['todoTaskCount'];
    emergencyTaskCount = json['emergencyTaskCount'];
    if (json['relateUsers'] != null) {
      relateUsers = [];
      json['relateUsers'].forEach((v) {
        relateUsers?.add(RelateUsers.fromJson(v));
      });
    }
    if (json['casePartyResVOS'] != null) {
      casePartyResVOS = [];
      json['casePartyResVOS'].forEach((v) {
        casePartyResVOS?.add(CasePartyResVos.fromJson(v));
      });
    }
  }

  num? id;
  num? status; //0-待更新 1-进行中 2-已归档
  String? caseName;
  num? caseType;
  num? casePartyRole;
  num? caseProcedure;
  String? caseNumber;
  num? createTime;
  num? todoTaskCount;
  num? emergencyTaskCount;
  List<RelateUsers>? relateUsers;
  List<CasePartyResVos>? casePartyResVOS;

  CaseBaseInfoModel copyWith({
    num? id,
    num? status,
    String? caseName,
    num? caseType,
    num? casePartyRole,
    num? caseProcedure,
    String? caseNumber,
    num? createTime,
    num? todoTaskCount,
    num? emergencyTaskCount,
    List<RelateUsers>? relateUsers,
    List<CasePartyResVos>? casePartyResVOS,
  }) => CaseBaseInfoModel(
    id: id ?? this.id,
    status: status ?? this.status,
    caseName: caseName ?? this.caseName,
    caseType: caseType ?? this.caseType,
    casePartyRole: casePartyRole ?? this.casePartyRole,
    caseProcedure: caseProcedure ?? this.caseProcedure,
    caseNumber: caseNumber ?? this.caseNumber,
    createTime: createTime ?? this.createTime,
    todoTaskCount: todoTaskCount ?? this.todoTaskCount,
    emergencyTaskCount: emergencyTaskCount ?? this.emergencyTaskCount,
    relateUsers: relateUsers ?? this.relateUsers,
    casePartyResVOS: casePartyResVOS ?? this.casePartyResVOS,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['caseName'] = caseName;
    map['caseType'] = caseType;
    map['casePartyRole'] = casePartyRole;
    map['caseProcedure'] = caseProcedure;
    map['caseNumber'] = caseNumber;
    map['createTime'] = createTime;
    map['todoTaskCount'] = todoTaskCount;
    map['emergencyTaskCount'] = emergencyTaskCount;
    if (relateUsers != null) {
      map['relateUsers'] = relateUsers?.map((v) => v.toJson()).toList();
    }
    if (casePartyResVOS != null) {
      map['casePartyResVOS'] = casePartyResVOS?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 26584
/// name : "李四"
/// partyRole : 0

class CasePartyResVos {
  CasePartyResVos({this.id, this.name, this.partyRole});

  CasePartyResVos.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    partyRole = json['partyRole'];
  }

  num? id;
  String? name;
  num? partyRole;

  CasePartyResVos copyWith({num? id, String? name, num? partyRole}) =>
      CasePartyResVos(
        id: id ?? this.id,
        name: name ?? this.name,
        partyRole: partyRole ?? this.partyRole,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['partyRole'] = partyRole;
    return map;
  }
}

/// id : 26584
/// mobile : "15601691300"
/// nickname : "李四"
/// avatar : "https://www.iocoder.cn/x.png"

class RelateUsers {
  RelateUsers({
    this.id,
    this.mobile,
    this.nickname,
    this.avatar,
    this.isSponsor, //是否发起人 true-是 false-否
  });

  RelateUsers.fromJson(dynamic json) {
    id = json['id'];
    mobile = json['mobile'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    isSponsor = json['isSponsor'];
  }

  num? id;
  String? mobile;
  String? nickname;
  String? avatar;
  bool? isSponsor;

  RelateUsers copyWith({
    num? id,
    String? mobile,
    String? nickname,
    String? avatar,
    bool? isSponsor,
  }) => RelateUsers(
    id: id ?? this.id,
    mobile: mobile ?? this.mobile,
    nickname: nickname ?? this.nickname,
    avatar: avatar ?? this.avatar,
    isSponsor: isSponsor ?? this.isSponsor,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['mobile'] = mobile;
    map['nickname'] = nickname;
    map['avatar'] = avatar;
    map['isSponsor'] = isSponsor;
    return map;
  }
}
