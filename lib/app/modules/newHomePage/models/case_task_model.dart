import '../../casePage/models/case_base_info_model.dart';

/// id : 19157
/// caseId : 1190
/// caseName : "赵六"
/// logo : "赵六"
/// taskType : 0
/// handler : "赵六"
/// handlerPhone : "赵六"
/// title : ""
/// content : ""
/// status : 2
/// partyRole : 0
/// isEmergency : true
/// dueAt : ""
/// remindTimes : ""
/// isAddCalendar : true
/// notes : [{"time":"","content":"","createBy":""}]
/// createTime : ""
/// relateUsers : [{"id":26584,"mobile":"15601691300","nickname":"李四","avatar":"https://www.iocoder.cn/x.png","isSponsor":false}]

class CaseTaskModel {
  CaseTaskModel({
    num? id,
    num? caseId,
    String? caseName,
    String? logo,
    num? taskType,
    String? handler,
    String? handlerPhone,
    String? title,
    String? content,
    num? status,
    num? partyRole,
    bool? isEmergency,
    num? dueAt,
    num? remindTimes,
    bool? isAddCalendar,
    String? addCalendarId,
    List<Notes>? notes,
    num? createTime,
    List<RelateUsers>? relateUsers,
  }) {
    _id = id;
    _caseId = caseId;
    _caseName = caseName;
    _logo = logo;
    _taskType = taskType;
    _handler = handler;
    _handlerPhone = handlerPhone;
    _title = title;
    _content = content;
    _status = status;
    _partyRole = partyRole;
    _isEmergency = isEmergency;
    _dueAt = dueAt;
    _remindTimes = remindTimes;
    isAddCalendar = isAddCalendar;
    addCalendarId = addCalendarId;
    _notes = notes;
    _createTime = createTime;
    _relateUsers = relateUsers;
  }

  CaseTaskModel.fromJson(dynamic json) {
    _id = json['id'];
    _caseId = json['caseId'];
    _caseName = json['caseName'];
    _logo = json['logo'];
    _taskType = json['taskType'];
    _handler = json['handler'];
    _handlerPhone = json['handlerPhone'];
    _title = json['title'];
    _content = json['content'];
    _status = json['status'];
    _partyRole = json['partyRole'];
    _isEmergency = json['isEmergency'];
    _dueAt = json['dueAt'];
    _remindTimes = json['remindTimes'];
    isAddCalendar = json['isAddCalendar'];
    addCalendarId = json['addCalendarId'];
    if (json['notes'] != null) {
      _notes = [];
      json['notes'].forEach((v) {
        _notes?.add(Notes.fromJson(v));
      });
    }
    _createTime = json['createTime'];
    if (json['relateUsers'] != null) {
      _relateUsers = [];
      json['relateUsers'].forEach((v) {
        _relateUsers?.add(RelateUsers.fromJson(v));
      });
    }
  }
  num? _id;
  num? _caseId;
  String? _caseName;
  String? _logo;
  num? _taskType;
  String? _handler;
  String? _handlerPhone;
  String? _title;
  String? _content;
  num? _status;
  num? _partyRole;
  bool? _isEmergency;
  num? _dueAt;
  num? _remindTimes;
  bool? isAddCalendar;
  String? addCalendarId;
  List<Notes>? _notes;
  num? _createTime;
  List<RelateUsers>? _relateUsers;
  CaseTaskModel copyWith({
    num? id,
    num? caseId,
    String? caseName,
    String? logo,
    num? taskType,
    String? handler,
    String? handlerPhone,
    String? title,
    String? content,
    num? status,
    num? partyRole,
    bool? isEmergency,
    num? dueAt,
    num? remindTimes,
    bool? isAddCalendar,
    String? addCalendarId,
    List<Notes>? notes,
    num? createTime,
    List<RelateUsers>? relateUsers,
  }) => CaseTaskModel(
    id: id ?? _id,
    caseId: caseId ?? _caseId,
    caseName: caseName ?? _caseName,
    logo: logo ?? _logo,
    taskType: taskType ?? _taskType,
    handler: handler ?? _handler,
    handlerPhone: handlerPhone ?? _handlerPhone,
    title: title ?? _title,
    content: content ?? _content,
    status: status ?? _status,
    partyRole: partyRole ?? _partyRole,
    isEmergency: isEmergency ?? _isEmergency,
    dueAt: dueAt ?? _dueAt,
    remindTimes: remindTimes ?? _remindTimes,
    isAddCalendar: isAddCalendar ?? isAddCalendar,
    addCalendarId: addCalendarId ?? addCalendarId,
    notes: notes ?? _notes,
    createTime: createTime ?? _createTime,
    relateUsers: relateUsers ?? _relateUsers,
  );
  num? get id => _id;
  num? get caseId => _caseId;
  String? get caseName => _caseName;
  String? get logo => _logo;
  num? get taskType => _taskType;
  String? get handler => _handler;
  String? get handlerPhone => _handlerPhone;
  String? get title => _title;
  String? get content => _content;
  num? get status => _status;
  num? get partyRole => _partyRole;
  bool? get isEmergency => _isEmergency;
  num? get dueAt => _dueAt;
  num? get remindTimes => _remindTimes;
  List<Notes>? get notes => _notes;
  num? get createTime => _createTime;
  List<RelateUsers>? get relateUsers => _relateUsers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['caseId'] = _caseId;
    map['caseName'] = _caseName;
    map['logo'] = _logo;
    map['taskType'] = _taskType;
    map['handler'] = _handler;
    map['handlerPhone'] = _handlerPhone;
    map['title'] = _title;
    map['content'] = _content;
    map['status'] = _status;
    map['partyRole'] = _partyRole;
    map['isEmergency'] = _isEmergency;
    map['dueAt'] = _dueAt;
    map['remindTimes'] = _remindTimes;
    map['isAddCalendar'] = isAddCalendar;
    map['addCalendarId'] = addCalendarId;
    if (_notes != null) {
      map['notes'] = _notes?.map((v) => v.toJson()).toList();
    }
    map['createTime'] = _createTime;
    if (_relateUsers != null) {
      map['relateUsers'] = _relateUsers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// time : ""
/// content : ""
/// createBy : ""

class Notes {
  Notes({String? time, String? content, String? createBy}) {
    _time = time;
    _content = content;
    _createBy = createBy;
  }

  Notes.fromJson(dynamic json) {
    _time = json['time'];
    _content = json['content'];
    _createBy = json['createBy'];
  }
  String? _time;
  String? _content;
  String? _createBy;
  Notes copyWith({String? time, String? content, String? createBy}) => Notes(
    time: time ?? _time,
    content: content ?? _content,
    createBy: createBy ?? _createBy,
  );
  String? get time => _time;
  String? get content => _content;
  String? get createBy => _createBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time'] = _time;
    map['content'] = _content;
    map['createBy'] = _createBy;
    return map;
  }
}
