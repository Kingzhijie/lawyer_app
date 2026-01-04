class TaskListModel {
  int? id;
  int? caseId;
  dynamic caseName;
  dynamic logo;
  int? taskType;
  dynamic handler;
  dynamic handlerPhone;
  String? title;
  String? content;
  int? status;
  dynamic partyRole;
  bool? isEmergency;
  int? dueAt;
  int? remindTimes;
  bool? isAddCalendar;
  dynamic notes;
  int? createTime;
  dynamic relateUsers;

  TaskListModel({
    this.id,
    this.caseId,
    this.caseName,
    this.logo,
    this.taskType,
    this.handler,
    this.handlerPhone,
    this.title,
    this.content,
    this.status,
    this.partyRole,
    this.isEmergency,
    this.dueAt,
    this.remindTimes,
    this.isAddCalendar,
    this.notes,
    this.createTime,
    this.relateUsers,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
    id: json['id'] as int?,
    caseId: json['caseId'] as int?,
    caseName: json['caseName'] as dynamic,
    logo: json['logo'] as dynamic,
    taskType: json['taskType'] as int?,
    handler: json['handler'] as dynamic,
    handlerPhone: json['handlerPhone'] as dynamic,
    title: json['title'] as String?,
    content: json['content'] as String?,
    status: json['status'] as int?,
    partyRole: json['partyRole'] as dynamic,
    isEmergency: json['isEmergency'] as bool?,
    dueAt: json['dueAt'] as int?,
    remindTimes: json['remindTimes'] as int?,
    isAddCalendar: json['isAddCalendar'] as bool?,
    notes: json['notes'] as dynamic,
    createTime: json['createTime'] as int?,
    relateUsers: json['relateUsers'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'caseId': caseId,
    'caseName': caseName,
    'logo': logo,
    'taskType': taskType,
    'handler': handler,
    'handlerPhone': handlerPhone,
    'title': title,
    'content': content,
    'status': status,
    'partyRole': partyRole,
    'isEmergency': isEmergency,
    'dueAt': dueAt,
    'remindTimes': remindTimes,
    'isAddCalendar': isAddCalendar,
    'notes': notes,
    'createTime': createTime,
    'relateUsers': relateUsers,
  };
}
