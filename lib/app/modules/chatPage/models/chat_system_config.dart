/// createTime : 1767511169000
/// updateTime : 1767511165000
/// creator : "1"
/// updater : "1"
/// deleted : false
/// id : 64
/// field : "sys_def_agent"
/// remark : "系统默认AI智能体ID"
/// value : "64"

class ChatSystemConfig {
  ChatSystemConfig({
      this.createTime, 
      this.updateTime, 
      this.creator, 
      this.updater, 
      this.deleted, 
      this.id, 
      this.field, 
      this.remark, 
      this.value,});

  ChatSystemConfig.fromJson(dynamic json) {
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    creator = json['creator'];
    updater = json['updater'];
    deleted = json['deleted'];
    id = json['id'];
    field = json['field'];
    remark = json['remark'];
    value = json['value'];
  }
  num? createTime;
  num? updateTime;
  String? creator;
  String? updater;
  bool? deleted;
  num? id;
  String? field;
  String? remark;
  String? value;
ChatSystemConfig copyWith({  num? createTime,
  num? updateTime,
  String? creator,
  String? updater,
  bool? deleted,
  num? id,
  String? field,
  String? remark,
  String? value,
}) => ChatSystemConfig(  createTime: createTime ?? this.createTime,
  updateTime: updateTime ?? this.updateTime,
  creator: creator ?? this.creator,
  updater: updater ?? this.updater,
  deleted: deleted ?? this.deleted,
  id: id ?? this.id,
  field: field ?? this.field,
  remark: remark ?? this.remark,
  value: value ?? this.value,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    map['creator'] = creator;
    map['updater'] = updater;
    map['deleted'] = deleted;
    map['id'] = id;
    map['field'] = field;
    map['remark'] = remark;
    map['value'] = value;
    return map;
  }

}