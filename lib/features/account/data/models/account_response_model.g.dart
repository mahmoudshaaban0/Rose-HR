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
  'work_email': instance.workEmail,
  'private_email': instance.privateEmail,
  'marital': instance.marital,
  'birthday': instance.birthday,
  'phone': instance.phone,
  'country_id': instance.countryId,
  'iqama_number': instance.iqamaNumber,
  'iqama_expiry_date': instance.iqamaExpiryDate,
  'building_number': instance.buildingNumber,
  'join_date': instance.joinDate,
  'job_position': instance.jobPosition,
  'department': instance.department,
  'business_unit': instance.businessUnit,
  'work_location': instance.workLocation,
  'direct_manager': instance.directManager,
  'religion': instance.religion,
  'basic_salary': instance.basicSalary,
  'housing_allowance': instance.housingAllowance,
  'transportation_allowance': instance.transportationAllowance,
  'communication_allowance': instance.communicationAllowance,
  'supervision_allowance': instance.supervisionAllowance,
  'excellence_allowance': instance.excellenceAllowance,
  'transportation_support_allowance': instance.transportationSupportAllowance,
  'assignment_allowance': instance.assignmentAllowance,
  'other_allowance': instance.otherAllowance,
  'total_salary': instance.totalSalary,
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
