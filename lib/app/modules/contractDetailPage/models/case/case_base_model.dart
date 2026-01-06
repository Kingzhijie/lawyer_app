import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_party_model.dart';

class CaseBaseModel {
  int? id;
  int? status;
  String? caseName;
  int? caseType;
  int? casePartyRole;
  int? caseProcedure;
  List<dynamic>? caseProcedureList;
  String? caseReason;
  dynamic commissionDate;
  String? receivingUnit;
  String? currentStage;
  String? caseNumber;
  num? winningAmount;
  num? actualRepayment;
  dynamic closureDate;
  dynamic archivingDate;
  String? archiveLocation;
  String? primaryLawyer;
  String? assistantLawyer;
  String? judgePhone;
  String? caseSummary;
  dynamic caseRemark;
  String? handler;
  dynamic handlerPhone;
  int? createTime;
  List<CasePartyModel>? casePartyResVos;

  CaseBaseModel({
    this.id,
    this.status,
    this.caseName,
    this.caseType,
    this.casePartyRole,
    this.caseProcedure,
    this.caseProcedureList,
    this.caseReason,
    this.commissionDate,
    this.receivingUnit,
    this.currentStage,
    this.caseNumber,
    this.winningAmount,
    this.actualRepayment,
    this.closureDate,
    this.archivingDate,
    this.archiveLocation,
    this.caseRemark,
    this.handler,
    this.handlerPhone,
    this.createTime,
    this.casePartyResVos,
    this.primaryLawyer,
    this.assistantLawyer,
    this.judgePhone,
    this.caseSummary,
  });

  factory CaseBaseModel.fromJson(Map<String, dynamic> json) => CaseBaseModel(
    id: json['id'] as int?,
    status: json['status'] as int?,
    caseName: json['caseName'] as String?,
    caseType: json['caseType'] as int?,
    casePartyRole: json['casePartyRole'] as int?,
    caseProcedure: json['caseProcedure'] as int?,
    caseProcedureList: json['caseProcedureList'] as List<dynamic>?,
    caseReason: json['caseReason'] as String?,
    receivingUnit: json['receivingUnit'] as String?,
    commissionDate: json['commissionDate'] as dynamic,
    currentStage: json['currentStage'] as String?,
    caseNumber: json['caseNumber'] as String?,
    winningAmount: json['winningAmount'] as num?,
    actualRepayment: json['actualRepayment'] as num?,
    closureDate: json['closureDate'] as dynamic,
    archivingDate: json['archivingDate'] as dynamic,
    archiveLocation: json['archiveLocation'] as String?,
    caseRemark: json['caseRemark'] as dynamic,
    handler: json['handler'] as String?,
    handlerPhone: json['handlerPhone'] as dynamic,
    createTime: json['createTime'] as int?,
    casePartyResVos: (json['casePartyResVOS'] as List<dynamic>?)
        ?.map((e) => CasePartyModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    primaryLawyer: json['primaryLawyer'] as String?,
    assistantLawyer: json['assistantLawyer'] as String?,
    judgePhone: json['judgePhone'] as String?,
    caseSummary: json['caseSummary'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'caseName': caseName,
    'caseType': caseType,
    'casePartyRole': casePartyRole,
    'caseProcedure': caseProcedure,
    'caseProcedureList': caseProcedureList,
    'caseReason': caseReason,
    'commissionDate': commissionDate,
    'receivingUnit': receivingUnit,
    'currentStage': currentStage,
    'caseNumber': caseNumber,
    'winningAmount': winningAmount,
    'actualRepayment': actualRepayment,
    'closureDate': closureDate,
    'archivingDate': archivingDate,
    'archiveLocation': archiveLocation,
    'caseRemark': caseRemark,
    'handler': handler,
    'handlerPhone': handlerPhone,
    'createTime': createTime,
    'primaryLawyer': primaryLawyer,
    'assistantLawyer': assistantLawyer,
    'judgePhone': judgePhone,
    'caseSummary': caseSummary,
    'casePartyResVOS': casePartyResVos?.map((e) => e.toJson()).toList(),
  };
}
