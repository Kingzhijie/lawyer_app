class AgencyFeeModel {
  int? id;
  int? caseId;
  int? feeType;
  int? agencyFee;
  String? targetObject;
  int? targetAmount;
  String? feeIntro;
  String? remark;
  int? createTime;

  AgencyFeeModel({
    this.id,
    this.caseId,
    this.feeType,
    this.agencyFee,
    this.targetObject,
    this.targetAmount,
    this.feeIntro,
    this.remark,
    this.createTime,
  });

  factory AgencyFeeModel.fromJson(Map<String, dynamic> json) {
    return AgencyFeeModel(
      id: json['id'] as int?,
      caseId: json['caseId'] as int?,
      feeType: json['feeType'] as int?,
      agencyFee: json['agencyFee'] as int?,
      targetObject: json['targetObject'] as String?,
      targetAmount: json['targetAmount'] as int?,
      feeIntro: json['feeIntro'] as String?,
      remark: json['remark'] as String?,
      createTime: json['createTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caseId': caseId,
      'feeType': feeType,
      'agencyFee': agencyFee,
      'targetObject': targetObject,
      'targetAmount': targetAmount,
      'feeIntro': feeIntro,
      'remark': remark,
      'createTime': createTime,
    };
  }
}
