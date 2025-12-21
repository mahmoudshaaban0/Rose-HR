// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountResponseModel _$AccountResponseModelFromJson(
  Map<String, dynamic> json,
) => AccountResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : AccountResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AccountResponseModelToJson(
  AccountResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

AccountResult _$AccountResultFromJson(Map<String, dynamic> json) =>
    AccountResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountResultToJson(AccountResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
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
  bankAccount: json['bank_account'] == null
      ? null
      : BankAccount.fromJson(json['bank_account'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'name': instance.name,
  'pin': instance.pin,
  'gender': instance.gender,
  'private_email': instance.privateEmail,
  'marital': instance.marital,
  'birthday': instance.birthday,
  'phone': instance.phone,
  'country_id': instance.countryId,
  'iqama_number': instance.iqamaNumber,
  'street': instance.street,
  'street2': instance.street2,
  'city': instance.city,
  'state': instance.state,
  'zip': instance.zip,
  'country': instance.country,
  'bank_account': instance.bankAccount,
};

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
  bankName: json['bank_name'],
  accountNumber: json['account_number'],
);

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
    };
