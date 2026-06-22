import 'package:json_annotation/json_annotation.dart';

part 'account_response_model.g.dart';

@JsonSerializable(createFactory: false)
class AccountResponseModel {
  AccountResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });
  factory AccountResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return AccountResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? AccountResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AccountResult? result;

  Map<String, dynamic> toJson() => _$AccountResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class AccountResult {
  AccountResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AccountResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AccountResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? Data.fromJson(rawData) : null,
    );
  }

  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$AccountResultToJson(this);
}

@JsonSerializable(createFactory: false)
class Data {
  Data({
    this.name,
    this.pin,
    this.gender,
    this.workEmail,
    this.privateEmail,
    this.marital,
    this.birthday,
    this.phone,
    this.countryId,
    this.iqamaNumber,
    this.iqamaExpiryDate,
    this.buildingNumber,
    this.joinDate,
    this.jobPosition,
    this.department,
    this.businessUnit,
    this.workLocation,
    this.directManager,
    this.street,
    this.street2,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.religion,
    this.basicSalary,
    this.housingAllowance,
    this.transportationAllowance,
    this.communicationAllowance,
    this.supervisionAllowance,
    this.excellenceAllowance,
    this.transportationSupportAllowance,
    this.assignmentAllowance,
    this.otherAllowance,
    this.totalSalary,
    this.bankAccount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final rawBankAccount = json['bank_account'];
    return Data(
      name: json['name'],
      pin: json['pin'],
      gender: json['gender'],
      workEmail: json['work_email'],
      privateEmail: json['private_email'],
      marital: json['marital'],
      birthday: json['birthday'],
      phone: json['phone'],
      countryId: json['country_id'],
      iqamaNumber: json['iqama_number'],
      iqamaExpiryDate: json['iqama_expiry_date'],
      buildingNumber: json['building_number'],
      joinDate: json['join_date'],
      jobPosition: json['job_position'],
      department: json['department'],
      businessUnit: json['business_unit'],
      workLocation: json['work_location'],
      directManager: json['direct_manager'],
      street: json['street'],
      street2: json['street2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
      religion: json['religion'],
      basicSalary: json['basic_salary'],
      housingAllowance: json['housing_allowance'],
      transportationAllowance: json['transportation_allowance'],
      communicationAllowance: json['communication_allowance'],
      supervisionAllowance: json['supervision_allowance'],
      excellenceAllowance: json['excellence_allowance'],
      transportationSupportAllowance: json['transportation_support_allowance'],
      assignmentAllowance: json['assignment_allowance'],
      otherAllowance: json['other_allowance'],
      totalSalary: json['total_salary'],
      bankAccount:
          rawBankAccount is Map<String, dynamic> ? BankAccount.fromJson(rawBankAccount) : null,
    );
  }
  @JsonKey(name: "name")
  dynamic name;
  @JsonKey(name: "pin")
  dynamic pin;
  @JsonKey(name: "gender")
  dynamic gender;
  @JsonKey(name: "work_email")
  dynamic workEmail;
  @JsonKey(name: "private_email")
  dynamic privateEmail;
  @JsonKey(name: "marital")
  dynamic marital;
  @JsonKey(name: "birthday")
  dynamic birthday;
  @JsonKey(name: "phone")
  dynamic phone;
  @JsonKey(name: "country_id")
  dynamic countryId;
  @JsonKey(name: "iqama_number")
  dynamic iqamaNumber;
  @JsonKey(name: "iqama_expiry_date")
  dynamic iqamaExpiryDate;
  @JsonKey(name: "building_number")
  dynamic buildingNumber;
  @JsonKey(name: "join_date")
  dynamic joinDate;
  @JsonKey(name: "job_position")
  dynamic jobPosition;
  @JsonKey(name: "department")
  dynamic department;
  @JsonKey(name: "business_unit")
  dynamic businessUnit;
  @JsonKey(name: "work_location")
  dynamic workLocation;
  @JsonKey(name: "direct_manager")
  dynamic directManager;
  @JsonKey(name: "religion")
  dynamic religion;
  @JsonKey(name: "basic_salary")
  dynamic basicSalary;
  @JsonKey(name: "housing_allowance")
  dynamic housingAllowance;
  @JsonKey(name: "transportation_allowance")
  dynamic transportationAllowance;
  @JsonKey(name: "communication_allowance")
  dynamic communicationAllowance;
  @JsonKey(name: "supervision_allowance")
  dynamic supervisionAllowance;
  @JsonKey(name: "excellence_allowance")
  dynamic excellenceAllowance;
  @JsonKey(name: "transportation_support_allowance")
  dynamic transportationSupportAllowance;
  @JsonKey(name: "assignment_allowance")
  dynamic assignmentAllowance;
  @JsonKey(name: "other_allowance")
  dynamic otherAllowance;
  @JsonKey(name: "total_salary")
  dynamic totalSalary;
  @JsonKey(name: "street")
  dynamic street;
  @JsonKey(name: "street2")
  dynamic street2;
  @JsonKey(name: "city")
  dynamic city;
  @JsonKey(name: "state")
  dynamic state;
  @JsonKey(name: "zip")
  dynamic zip;
  @JsonKey(name: "country")
  dynamic country;
  @JsonKey(name: "bank_account")
  BankAccount? bankAccount;

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

@JsonSerializable()
class BankAccount {
  BankAccount({
    this.bankName,
    this.accountNumber,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);
  @JsonKey(name: "bank_name")
  dynamic bankName;
  @JsonKey(name: "account_number")
  dynamic accountNumber;

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}
