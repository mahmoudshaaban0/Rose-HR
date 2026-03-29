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

  factory Data.fromJson(Map<String, dynamic> json) {
    final rawBankAccount = json['bank_account'];
    return Data(
      name: json['name'],
      pin: json['pin'],
      gender: json['gender'],
      privateEmail: json['private_email'],
      marital: json['marital'],
      birthday: json['birthday'],
      phone: json['phone'],
      countryId: json['country_id'],
      iqamaNumber: json['iqama_number'],
      street: json['street'],
      street2: json['street2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
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
