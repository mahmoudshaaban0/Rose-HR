import 'package:json_annotation/json_annotation.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';

part 'punch_correction_request_model.g.dart';

/// Request model for creating a punch correction
/// Supports two methods: 'manual' and 'attendance_log'
/// Supports three correction types: 'in', 'out' and 'both'
/// For 'both', the `*_out` fields carry the check-out values.
@JsonSerializable(includeIfNull: false)
class PunchCorrectionRequestModel {
  PunchCorrectionRequestModel({
    required this.date,
    required this.shiftId,
    required this.correctionType,
    required this.fixAttendanceMethod,
    this.correctionTime,
    this.correctionTimeOut,
    this.attendanceLogId,
    this.attendanceLogOutId,
    this.reason,
    this.attachmentIds,
  });

  factory PunchCorrectionRequestModel.fromJson(Map<String, dynamic> json) => _$PunchCorrectionRequestModelFromJson(json);

  /// Factory constructor for 'manual' method.
  /// For `correctionType == 'both'`, pass [correctionTimeOut] with the
  /// check-out time; [correctionTime] then carries the check-in time.
  factory PunchCorrectionRequestModel.manual({
    required String date,
    required int shiftId,
    required String correctionType,
    required double correctionTime,
    double? correctionTimeOut,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PunchCorrectionRequestModel(
      date: date,
      shiftId: shiftId,
      correctionType: correctionType,
      fixAttendanceMethod: 'manual',
      correctionTime: correctionTime,
      correctionTimeOut: correctionTimeOut,
      reason: reason,
      attachmentIds: attachmentIds,
    );
  }

  /// Factory constructor for 'attendance_log' method.
  /// For `correctionType == 'both'`, pass [attendanceLogOutId] with the
  /// check-out log; [attendanceLogId] then carries the check-in log.
  factory PunchCorrectionRequestModel.attendanceLog({
    required String date,
    required int shiftId,
    required String correctionType,
    required int attendanceLogId,
    int? attendanceLogOutId,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PunchCorrectionRequestModel(
      date: date,
      shiftId: shiftId,
      correctionType: correctionType,
      fixAttendanceMethod: 'attendance_log',
      attendanceLogId: attendanceLogId,
      attendanceLogOutId: attendanceLogOutId,
      reason: reason,
      attachmentIds: attachmentIds,
    );
  }

  /// Date of the attendance to fix (YYYY-MM-DD format)
  @JsonKey(name: 'date')
  final String date;

  /// Shift ID
  @JsonKey(name: 'shift_id')
  final int shiftId;

  /// Correction type: 'in' or 'out'
  @JsonKey(name: 'correction_type')
  final String correctionType;

  /// Fix attendance method: 'manual' or 'attendance_log'
  @JsonKey(name: 'fix_attendance_method')
  final String fixAttendanceMethod;

  /// For manual method: The corrected time (float hours)
  /// Example: 18.0 represents 6:00 PM
  @JsonKey(name: 'correction_time')
  final double? correctionTime;

  /// For manual method with `correctionType == 'both'`: the corrected
  /// check-out time (float hours)
  @JsonKey(name: 'correction_time_out')
  final double? correctionTimeOut;

  /// For attendance_log method: Attendance log ID to use
  @JsonKey(name: 'attendance_log_id')
  final int? attendanceLogId;

  /// For attendance_log method with `correctionType == 'both'`: the
  /// check-out attendance log ID to use
  @JsonKey(name: 'attendance_log_out_id')
  final int? attendanceLogOutId;

  /// Reason for the correction (Optional)
  @JsonKey(name: 'reason')
  final String? reason;

  /// List of attachment IDs (Optional)
  /// Each attachment should have: {name, data, mimetype}
  @JsonKey(name: 'attachment_ids')
  final List<AttachmentData>? attachmentIds;

  Map<String, dynamic> toJson() => _$PunchCorrectionRequestModelToJson(this);

  PunchCorrectionRequestModel copyWith({
    String? date,
    int? shiftId,
    String? correctionType,
    String? fixAttendanceMethod,
    double? correctionTime,
    double? correctionTimeOut,
    int? attendanceLogId,
    int? attendanceLogOutId,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) {
    return PunchCorrectionRequestModel(
      date: date ?? this.date,
      shiftId: shiftId ?? this.shiftId,
      correctionType: correctionType ?? this.correctionType,
      fixAttendanceMethod: fixAttendanceMethod ?? this.fixAttendanceMethod,
      correctionTime: correctionTime ?? this.correctionTime,
      correctionTimeOut: correctionTimeOut ?? this.correctionTimeOut,
      attendanceLogId: attendanceLogId ?? this.attendanceLogId,
      attendanceLogOutId: attendanceLogOutId ?? this.attendanceLogOutId,
      reason: reason ?? this.reason,
      attachmentIds: attachmentIds ?? this.attachmentIds,
    );
  }
}
