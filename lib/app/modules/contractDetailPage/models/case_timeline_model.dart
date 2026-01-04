class CaseTimelineModel {
  int? id;
  int? caseId;
  String? eventTitle;
  dynamic eventContent;
  int? eventTime;
  int? relatedDocumentId;
  dynamic relatedTaskId;
  dynamic operatorId;
  String? remark;
  int? createTime;

  CaseTimelineModel({
    this.id,
    this.caseId,
    this.eventTitle,
    this.eventContent,
    this.eventTime,
    this.relatedDocumentId,
    this.relatedTaskId,
    this.operatorId,
    this.remark,
    this.createTime,
  });

  factory CaseTimelineModel.fromJson(Map<String, dynamic> json) {
    return CaseTimelineModel(
      id: json['id'] as int?,
      caseId: json['caseId'] as int?,
      eventTitle: json['eventTitle'] as String?,
      eventContent: json['eventContent'] as dynamic,
      eventTime: json['eventTime'] as int?,
      relatedDocumentId: json['relatedDocumentId'] as int?,
      relatedTaskId: json['relatedTaskId'] as dynamic,
      operatorId: json['operatorId'] as dynamic,
      remark: json['remark'] as String?,
      createTime: json['createTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caseId': caseId,
      'eventTitle': eventTitle,
      'eventContent': eventContent,
      'eventTime': eventTime,
      'relatedDocumentId': relatedDocumentId,
      'relatedTaskId': relatedTaskId,
      'operatorId': operatorId,
      'remark': remark,
      'createTime': createTime,
    };
  }
}
