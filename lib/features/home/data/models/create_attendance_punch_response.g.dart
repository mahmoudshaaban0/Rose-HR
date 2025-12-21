// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_attendance_punch_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAttendancePunchResponse _$CreateAttendancePunchResponseFromJson(
  Map<String, dynamic> json,
) => CreateAttendancePunchResponse(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : AttendancePunchResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateAttendancePunchResponseToJson(
  CreateAttendancePunchResponse instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

AttendancePunchResult _$AttendancePunchResultFromJson(
  Map<String, dynamic> json,
) => AttendancePunchResult(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AttendancePunchResultToJson(
  AttendancePunchResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data();

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{};
