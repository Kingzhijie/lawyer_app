class CasePartyModel {
  int? id;
  String? name;
  int? partyType;
  int? idType;
  String? idNumber;
  String? nationality;
  int? gender;
  bool? isCustomer;
  String? phone;
  String? email;
  String? address;
  String? legalRepresentative;
  String? remark;
  int? createTime;

  CasePartyModel({
    this.id,
    this.name,
    this.partyType,
    this.idType,
    this.idNumber,
    this.nationality,
    this.gender,
    this.isCustomer,
    this.phone,
    this.email,
    this.address,
    this.legalRepresentative,
    this.remark,
    this.createTime,
  });

  factory CasePartyModel.fromId23NamePartyType1IdType1IdNumberNationalityGender0IsCustomerFalsePhoneEmailAddressLegalRepresentativeRemarkCreateTime1767605374000(
    Map<String, dynamic> json,
  ) {
    return CasePartyModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      partyType: json['partyType'] as int?,
      idType: json['idType'] as int?,
      idNumber: json['idNumber'] as String?,
      nationality: json['nationality'] as String?,
      gender: json['gender'] as int?,
      isCustomer: json['isCustomer'] as bool?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      legalRepresentative: json['legalRepresentative'] as String?,
      remark: json['remark'] as String?,
      createTime: json['createTime'] as int?,
    );
  }

  Map<String, dynamic>
  toId23NamePartyType1IdType1IdNumberNationalityGender0IsCustomerFalsePhoneEmailAddressLegalRepresentativeRemarkCreateTime1767605374000() {
    return {
      'id': id,
      'name': name,
      'partyType': partyType,
      'idType': idType,
      'idNumber': idNumber,
      'nationality': nationality,
      'gender': gender,
      'isCustomer': isCustomer,
      'phone': phone,
      'email': email,
      'address': address,
      'legalRepresentative': legalRepresentative,
      'remark': remark,
      'createTime': createTime,
    };
  }
}
