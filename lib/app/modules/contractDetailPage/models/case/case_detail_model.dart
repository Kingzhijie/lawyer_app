import 'package:lawyer_app/app/modules/casePage/models/case_base_info_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/agency_fee_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/pres_asset_model.dart';

import 'case_base_model.dart';
import 'doc_list_model.dart';
import 'task_list_model.dart';

class CaseDetailModel {
  CaseBaseModel? caseBase;
  AgencyFeeModel? agencyFeeInfo;
  List<TaskListModel>? taskList;
  List<DocListModel>? docList;
  List<PresAssetModel>? presAssetList;
  List<RelateUsers>? relateUsers;

  CaseDetailModel({
    this.caseBase,
    this.agencyFeeInfo,
    this.taskList,
    this.docList,
    this.presAssetList,
    this.relateUsers,
  });

  factory CaseDetailModel.fromJson(Map<String, dynamic> json) =>
      CaseDetailModel(
        caseBase: json['caseBase'] == null
            ? null
            : CaseBaseModel.fromJson(json['caseBase'] as Map<String, dynamic>),
        agencyFeeInfo: json['agencyFeeRespVO'] == null
            ? null
            : AgencyFeeModel.fromJson(
                json['agencyFeeRespVO'] as Map<String, dynamic>,
              ),
        taskList: (json['taskList'] as List<dynamic>?)
            ?.map((e) => TaskListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        docList: (json['docList'] as List<dynamic>?)
            ?.map((e) => DocListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        presAssetList: (json['presAssetList'] as List<dynamic>?)
            ?.map((e) => PresAssetModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        relateUsers: (json['relateUsers'] as List<dynamic>?)
            ?.map((e) => RelateUsers.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'caseBase': caseBase?.toJson(),
    'agencyFeeInfo': agencyFeeInfo?.toJson(),
    'taskList': taskList?.map((e) => e.toJson()).toList(),
    'docList': docList?.map((e) => e.toJson()).toList(),
    'presAssetList': presAssetList,
    'relateUsers': relateUsers?.map((e) => e.toJson()).toList(),
  };
}
