// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_summary_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AttendanceSummaryDetailsResponseModelToJson(
  AttendanceSummaryDetailsResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$AttendanceSummaryDetailsResultToJson(
  AttendanceSummaryDetailsResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  offDay: json['off_day'] as bool?,
  publicOff: json['public_off'] as bool?,
  leave: json['leave'] as bool?,
  absence: json['absence'] as bool?,
  description: json['description'] as String?,
  the2Shifts: json['2_shifts'] as bool?,
  shifts: (json['shifts'] as List<dynamic>?)
      ?.map((e) => ShiftData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'date': instance.date?.toIso8601String(),
  'off_day': instance.offDay,
  'public_off': instance.publicOff,
  'leave': instance.leave,
  'absence': instance.absence,
  'description': instance.description,
  '2_shifts': instance.the2Shifts,
  'shifts': instance.shifts,
};

ShiftData _$ShiftDataFromJson(Map<String, dynamic> json) => ShiftData(
  shiftId: (json['shift_id'] as num?)?.toInt(),
  shiftStartTime: json['shift_start_time'] as String?,
  shiftEndTime: json['shift_end_time'] as String?,
  checkInTime: json['check_in_time'] as String?,
  lateInTime: json['late_in_time'] as String?,
  checkOutTime: json['check_out_time'] as String?,
  earlyOutTime: json['early_out_time'] as String?,
  totalLateTime: json['total_late_time'] as String?,
  totalWorkTime: json['total_work_time'] as String?,
);

Map<String, dynamic> _$ShiftDataToJson(ShiftData instance) => <String, dynamic>{
  'shift_id': instance.shiftId,
  'shift_start_time': instance.shiftStartTime,
  'shift_end_time': instance.shiftEndTime,
  'check_in_time': instance.checkInTime,
  'late_in_time': instance.lateInTime,
  'check_out_time': instance.checkOutTime,
  'early_out_time': instance.earlyOutTime,
  'total_late_time': instance.totalLateTime,
  'total_work_time': instance.totalWorkTime,
};
