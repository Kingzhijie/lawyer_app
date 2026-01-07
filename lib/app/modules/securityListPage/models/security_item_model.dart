import 'party.dart';

class SecurityItemModel {
  int? caseId;
  String? caseName;
  String? caseNumber;
  String? caseReason;
  String? receivingUnit;
  List<Party>? parties;
  int? nearestExpiryDate;
  int? assetCount;
  int? realEstateCount;
  int? vehicleCount;
  double? fundAmount;
  int? otherAssetCount;
  bool? isAddCalendar;
  String? addCalendarId;

  SecurityItemModel({
    this.caseId,
    this.caseName,
    this.caseNumber,
    this.caseReason,
    this.receivingUnit,
    this.parties,
    this.nearestExpiryDate,
    this.assetCount,
    this.realEstateCount,
    this.vehicleCount,
    this.fundAmount,
    this.otherAssetCount,
    this.isAddCalendar,
    this.addCalendarId,
  });

  factory SecurityItemModel.fromJson(Map<String, dynamic> json) {
    return SecurityItemModel(
      caseId: json['caseId'] as int?,
      caseName: json['caseName'] as String?,
      caseNumber: json['caseNumber'] as String?,
      caseReason: json['caseReason'] as String?,
      receivingUnit: json['receivingUnit'] as String?,
      parties: (json['parties'] as List<dynamic>?)
          ?.map((e) => Party.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearestExpiryDate: json['nearestExpiryDate'] as int?,
      assetCount: json['assetCount'] as int?,
      realEstateCount: json['realEstateCount'] as int?,
      vehicleCount: json['vehicleCount'] as int?,
      fundAmount: json['fundAmount'] as double?,
      otherAssetCount: json['otherAssetCount'] as int?,
      isAddCalendar: json['isAddCalendar'] as bool?,
      addCalendarId: json['addCalendarId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caseId': caseId,
      'caseName': caseName,
      'caseNumber': caseNumber,
      'caseReason': caseReason,
      'receivingUnit': receivingUnit,
      'parties': parties?.map((e) => e.toString()).toList(),
      'nearestExpiryDate': nearestExpiryDate,
      'assetCount': assetCount,
      'realEstateCount': realEstateCount,
      'vehicleCount': vehicleCount,
      'fundAmount': fundAmount,
      'otherAssetCount': otherAssetCount,
      'isAddCalendar': isAddCalendar,
      'addCalendarId': addCalendarId,
    };
  }
}
