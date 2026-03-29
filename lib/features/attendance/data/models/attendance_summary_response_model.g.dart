// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AttendanceSummaryToJson(AttendanceSummary instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'result': instance.result,
    };

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
