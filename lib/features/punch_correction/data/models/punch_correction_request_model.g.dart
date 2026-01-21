// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punch_correction_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PunchCorrectionRequestModel _$PunchCorrectionRequestModelFromJson(
  Map<String, dynamic> json,
) => PunchCorrectionRequestModel(
  date: json['date'] as String,
  shiftId: (json['shift_id'] as num).toInt(),
  correctionType: json['correction_type'] as String,
  fixAttendanceMethod: json['fix_attendance_method'] as String,
  correctionTime: (json['correction_time'] as num?)?.toDouble(),
  attendanceLogId: (json['attendance_log_id'] as num?)?.toInt(),
  reason: json['reason'] as String?,
  attachmentIds: (json['attachment_ids'] as List<dynamic>?)
      ?.map((e) => AttachmentData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PunchCorrectionRequestModelToJson(
  PunchCorrectionRequestModel instance,
) => <String, dynamic>{
  'date': instance.date,
  'shift_id': instance.shiftId,
  'correction_type': instance.correctionType,
  'fix_attendance_method': instance.fixAttendanceMethod,
  'correction_time': ?instance.correctionTime,
  'attendance_log_id': ?instance.attendanceLogId,
  'reason': ?instance.reason,
  'attachment_ids': ?instance.attachmentIds,
};
