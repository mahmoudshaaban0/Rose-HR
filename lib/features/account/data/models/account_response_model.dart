import 'package:json_annotation/json_annotation.dart';

part 'account_response_model.g.dart';

@JsonSerializable()
class AccountResponseModel {
  AccountResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });
  factory AccountResponseModel.fromJson(Map<String, dynamic> json) => _$AccountResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AccountResult? result;

  Map<String, dynamic> toJson() => _$AccountResponseModelToJson(this);
}

@JsonSerializable()
class AccountResult {
  AccountResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AccountResult.fromJson(Map<String, dynamic> json) => _$AccountResultFromJson(json);
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

@JsonSerializable()
class Data {
  Data({
    this.name,
    this.pin,
    this.gender,
    this.privateEmail,
    this.marital,
    this.birthday,
    this.phone,
    this.countryId,
    this.iqamaNumber,
    this.street,
    this.street2,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.bankAccount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: "name")
  dynamic name;
  @JsonKey(name: "pin")
  dynamic pin;
  @JsonKey(name: "gender")
  dynamic gender;
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
