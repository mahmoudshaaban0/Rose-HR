// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'result': instance.result,
    };

Map<String, dynamic> _$HomeResultToJson(HomeResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
  projectedCheckout: json['projected_checkout'],
  leaveBalances:
      (json['leave_balances'] as List<dynamic>?)
          ?.map((e) => LeaveBalance.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
  'projected_checkout': instance.projectedCheckout,
  'leave_balances': instance.leaveBalances,
};

LeaveBalance _$LeaveBalanceFromJson(Map<String, dynamic> json) => LeaveBalance(
  label: json['label'] as String?,
  balance: (json['balance'] as num?)?.toDouble(),
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$LeaveBalanceToJson(LeaveBalance instance) =>
    <String, dynamic>{
      'label': instance.label,
      'balance': instance.balance,
      'unit': instance.unit,
    };
