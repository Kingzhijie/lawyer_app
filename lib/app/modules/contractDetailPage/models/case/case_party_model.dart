class CasePartyModel {
  int? partyId;
  int? casePartyId;
  String? name;
  int? partyRole;
  int? partyType;
  int? idType;
  String? idNumber;
  String? nationality;
  int? gender;
  bool? isCustomer;
  String? phone;
  String? email;
  String? address;

  CasePartyModel({
    this.partyId,
    this.casePartyId,
    this.name,
    this.partyRole,
    this.partyType,
    this.idType,
    this.idNumber,
    this.nationality,
    this.gender,
    this.isCustomer,
    this.phone,
    this.email,
    this.address,
  });

  factory CasePartyModel.fromJson(Map<String, dynamic> json) {
    return CasePartyModel(
      partyId: json['partyId'] as int?,
      casePartyId: json['casePartyId'] as int?,
      name: json['name'] as String?,
      partyRole: json['partyRole'] as int?,
      partyType: json['partyType'] as int?,
      idType: json['idType'] as int?,
      idNumber: json['idNumber'] as String?,
      nationality: json['nationality'] as String?,
      gender: json['gender'] as int?,
      isCustomer: json['isCustomer'] as bool?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'casePartyId': casePartyId,
      'name': name,
      'partyRole': partyRole,
      'partyType': partyType,
      'idType': idType,
      'idNumber': idNumber,
      'nationality': nationality,
      'gender': gender,
      'isCustomer': isCustomer,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
