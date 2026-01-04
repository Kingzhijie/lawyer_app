import 'case_base_model.dart';
import 'doc_list_model.dart';
import 'task_list_model.dart';

class CaseDetailModel {
  CaseBaseModel? caseBase;
  List<TaskListModel>? taskList;
  List<DocListModel>? docList;
  List<dynamic>? presAssetList;

  CaseDetailModel({
    this.caseBase,
    this.taskList,
    this.docList,
    this.presAssetList,
  });

  factory CaseDetailModel.fromJson(Map<String, dynamic> json) =>
      CaseDetailModel(
        caseBase: json['caseBase'] == null
            ? null
            : CaseBaseModel.fromJson(json['caseBase'] as Map<String, dynamic>),
        taskList: (json['taskList'] as List<dynamic>?)
            ?.map((e) => TaskListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        docList: (json['docList'] as List<dynamic>?)
            ?.map((e) => DocListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        presAssetList: json['presAssetList'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'caseBase': caseBase?.toJson(),
    'taskList': taskList?.map((e) => e.toJson()).toList(),
    'docList': docList?.map((e) => e.toJson()).toList(),
    'presAssetList': presAssetList,
  };
}
