/// caseCount : 5
/// pendingTaskCount : 5
/// urgentTaskCount : 10
/// nonLitigationTaskCount : 125
/// preservationListCount : 21
/// abnormalTaskCount : 21

class HomeStatistics {
  HomeStatistics({
      this.caseCount, 
      this.pendingTaskCount, 
      this.urgentTaskCount, 
      this.nonLitigationTaskCount, 
      this.preservationListCount, 
      this.abnormalTaskCount, this.myjoinTaskCount, this.yuqiTaskCount});

  HomeStatistics.fromJson(dynamic json) {
    caseCount = json['caseCount'];
    pendingTaskCount = json['pendingTaskCount'];
    urgentTaskCount = json['urgentTaskCount'];
    nonLitigationTaskCount = json['nonLitigationTaskCount'];
    preservationListCount = json['preservationListCount'];
    abnormalTaskCount = json['abnormalTaskCount'];
    myjoinTaskCount = json['myjoinTaskCount'];
    yuqiTaskCount = json['yuqiTaskCount'];
  }
  num? caseCount;
  num? pendingTaskCount;
  num? urgentTaskCount;
  num? nonLitigationTaskCount;
  num? preservationListCount;
  num? abnormalTaskCount;
  num? myjoinTaskCount;
  num? yuqiTaskCount;
  num? wddbCount;
HomeStatistics copyWith({  num? caseCount,
  num? pendingTaskCount,
  num? urgentTaskCount,
  num? nonLitigationTaskCount,
  num? preservationListCount,
  num? abnormalTaskCount,
  num? yuqiTaskCount,
  num? myjoinTaskCount
}) => HomeStatistics(  caseCount: caseCount ?? this.caseCount,
  pendingTaskCount: pendingTaskCount ?? this.pendingTaskCount,
  urgentTaskCount: urgentTaskCount ?? this.urgentTaskCount,
  nonLitigationTaskCount: nonLitigationTaskCount ?? this.nonLitigationTaskCount,
  preservationListCount: preservationListCount ?? this.preservationListCount,
  abnormalTaskCount: abnormalTaskCount ?? this.abnormalTaskCount,
  yuqiTaskCount: yuqiTaskCount ?? this.yuqiTaskCount,
  myjoinTaskCount: myjoinTaskCount ?? this.myjoinTaskCount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['caseCount'] = caseCount;
    map['pendingTaskCount'] = pendingTaskCount;
    map['urgentTaskCount'] = urgentTaskCount;
    map['myjoinTaskCount'] = myjoinTaskCount;
    map['yuqiTaskCount'] = yuqiTaskCount;
    map['nonLitigationTaskCount'] = nonLitigationTaskCount;
    map['preservationListCount'] = preservationListCount;
    map['abnormalTaskCount'] = abnormalTaskCount;
    return map;
  }

}