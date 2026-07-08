// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_leave_types_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlleaveTypesResponseModel _$AlleaveTypesResponseModelFromJson(
  Map<String, dynamic> json,
) => AlleaveTypesResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : LeaveTypesResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AlleaveTypesResponseModelToJson(
  AlleaveTypesResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

LeaveTypesResult _$LeaveTypesResultFromJson(Map<String, dynamic> json) =>
    LeaveTypesResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LeaveTypesResultToJson(LeaveTypesResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  technicalName: json['technical_name'] as String?,
  hasValidAllocation: json['has_valid_allocation'] as bool?,
  requiresAllocation: $enumDecodeNullable(
    _$RequiresAllocationEnumMap,
    json['requires_allocation'],
  ),
  virtualRemainingLeaves: (json['virtual_remaining_leaves'] as num?)?.toInt(),
  hasLimitedDays: json['has_limited_days'] as bool?,
  numberOfLimitedDays: (json['number_of_limited_days'] as num?)?.toInt(),
  requireAttachment: json['require_attachment'] as bool?,
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'technical_name': instance.technicalName,
  'has_valid_allocation': instance.hasValidAllocation,
  'requires_allocation':
      _$RequiresAllocationEnumMap[instance.requiresAllocation],
  'virtual_remaining_leaves': instance.virtualRemainingLeaves,
  'has_limited_days': instance.hasLimitedDays,
  'number_of_limited_days': instance.numberOfLimitedDays,
  'require_attachment': instance.requireAttachment,
};

const _$RequiresAllocationEnumMap = {
  RequiresAllocation.NO: 'no',
  RequiresAllocation.YES: 'yes',
};
