// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PermissionRequestResponseModelToJson(
  PermissionRequestResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$RequestResultToJson(RequestResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  employeeId: (json['employee_id'] as num?)?.toInt(),
  employeeName: json['employee_name'] as String?,
  requestType: json['request_type'] as String?,
  requestTypeDisplay: json['request_type_display'] as String?,
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  timeFrom: (json['time_from'] as num?)?.toInt(),
  timeTo: (json['time_to'] as num?)?.toInt(),
  reason: json['reason'] as String?,
  state: json['state'] as String?,
  stateDisplay: json['state_display'] as String?,
  requestedDuration: (json['requested_duration'] as num?)?.toDouble(),
  partialExcuse: json['partial_excuse'] as bool?,
  managerId: (json['manager_id'] as num?)?.toInt(),
  managerName: json['manager_name'] as String?,
  resAttendanceId: (json['res_attendance_id'] as num?)?.toInt(),
  shiftName: json['shift_name'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employee_id': instance.employeeId,
  'employee_name': instance.employeeName,
  'request_type': instance.requestType,
  'request_type_display': instance.requestTypeDisplay,
  'date': instance.date?.toIso8601String(),
  'time_from': instance.timeFrom,
  'time_to': instance.timeTo,
  'reason': instance.reason,
  'state': instance.state,
  'state_display': instance.stateDisplay,
  'requested_duration': instance.requestedDuration,
  'partial_excuse': instance.partialExcuse,
  'manager_id': instance.managerId,
  'manager_name': instance.managerName,
  'res_attendance_id': instance.resAttendanceId,
  'shift_name': instance.shiftName,
};
