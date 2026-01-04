// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceSummary _$AttendanceSummaryFromJson(Map<String, dynamic> json) =>
    AttendanceSummary(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: json['result'] == null
          ? null
          : AttendanceResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendanceSummaryToJson(AttendanceSummary instance) =>
    <String, dynamic>{
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
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  offDay: json['off_day'] as bool?,
  publicOff: json['public_off'] as bool?,
  leave: json['leave'] as bool?,
  incompAttend: json['incomp_attendance'] as bool?,
  absence: json['absence'] as bool?,
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'off_day': instance.offDay,
  'public_off': instance.publicOff,
  'leave': instance.leave,
  'incomp_attendance': instance.incompAttend,
  'absence': instance.absence,
};
