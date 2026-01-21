// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'punch_correction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PunchCorrectionResponseModel _$PunchCorrectionResponseModelFromJson(
  Map<String, dynamic> json,
) => PunchCorrectionResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : PunchCorrectionResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PunchCorrectionResponseModelToJson(
  PunchCorrectionResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

PunchCorrectionResult _$PunchCorrectionResultFromJson(
  Map<String, dynamic> json,
) => PunchCorrectionResult(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : PunchCorrectionData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PunchCorrectionResultToJson(
  PunchCorrectionResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

PunchCorrectionData _$PunchCorrectionDataFromJson(Map<String, dynamic> json) =>
    PunchCorrectionData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      employeeId: (json['employee_id'] as num?)?.toInt(),
      employeeName: json['employee_name'] as String?,
      correctionType: json['correction_type'] as String?,
      correctionTypeDisplay: json['correction_type_display'] as String?,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      correctionTime: (json['correction_time'] as num?)?.toDouble(),
      attendanceLogId: (json['attendance_log_id'] as num?)?.toInt(),
      reason: json['reason'] as String?,
      state: json['state'] as String?,
      stateDisplay: json['state_display'] as String?,
      managerId: (json['manager_id'] as num?)?.toInt(),
      managerName: json['manager_name'] as String?,
      resAttendanceId: (json['res_attendance_id'] as num?)?.toInt(),
      shiftName: json['shift_name'] as String?,
      fixAttendanceMethod: json['fix_attendance_method'] as String?,
    );

Map<String, dynamic> _$PunchCorrectionDataToJson(
  PunchCorrectionData instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employee_id': instance.employeeId,
  'employee_name': instance.employeeName,
  'correction_type': instance.correctionType,
  'correction_type_display': instance.correctionTypeDisplay,
  'date': instance.date?.toIso8601String(),
  'correction_time': instance.correctionTime,
  'attendance_log_id': instance.attendanceLogId,
  'reason': instance.reason,
  'state': instance.state,
  'state_display': instance.stateDisplay,
  'manager_id': instance.managerId,
  'manager_name': instance.managerName,
  'res_attendance_id': instance.resAttendanceId,
  'shift_name': instance.shiftName,
  'fix_attendance_method': instance.fixAttendanceMethod,
};
