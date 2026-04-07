// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_logs_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceLogsResponseModel _$AttendanceLogsResponseModelFromJson(
  Map<String, dynamic> json,
) => AttendanceLogsResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : AttendanceResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AttendanceLogsResponseModelToJson(
  AttendanceLogsResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

AttendanceResult _$AttendanceResultFromJson(Map<String, dynamic> json) =>
    AttendanceResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AttendanceResultToJson(AttendanceResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  actionDatetime: json['action_datetime'] == null
      ? null
      : DateTime.parse(json['action_datetime'] as String),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'action_datetime': instance.actionDatetime?.toIso8601String(),
};
