// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeListResponseModel _$EmployeeListResponseModelFromJson(
  Map<String, dynamic> json,
) => EmployeeListResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : ListResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeListResponseModelToJson(
  EmployeeListResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

ListResult _$ListResultFromJson(Map<String, dynamic> json) => ListResult(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ListResultToJson(ListResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  requestType: json['request_type'] as String?,
  requestTypeDisplay: json['request_type_display'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  state: json['state'] as String?,
  stateDisplay: json['state_display'] as String?,
  requestedDuration: (json['requested_duration'] as num?)?.toDouble(),
  partialExcuse: json['partial_excuse'] as bool?,
  canCancel: json['can_cancel'] as bool?,
  workMissionType: json['work_mission_type'],
  missionStartDate: json['mission_start_date'] == null
      ? null
      : DateTime.parse(json['mission_start_date'] as String),
  missionEndDate: json['mission_end_date'] == null
      ? null
      : DateTime.parse(json['mission_end_date'] as String),
  requestedDays: (json['requested_days'] as num?)?.toInt(),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'request_type': instance.requestType,
  'request_type_display': instance.requestTypeDisplay,
  'date': instance.date?.toIso8601String(),
  'state': instance.state,
  'state_display': instance.stateDisplay,
  'requested_duration': instance.requestedDuration,
  'partial_excuse': instance.partialExcuse,
  'can_cancel': instance.canCancel,
  'work_mission_type': instance.workMissionType,
  'mission_start_date': instance.missionStartDate?.toIso8601String(),
  'mission_end_date': instance.missionEndDate?.toIso8601String(),
  'requested_days': instance.requestedDays,
};
