// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AccountResponseModelToJson(
  AccountResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$AccountResultToJson(AccountResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

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
