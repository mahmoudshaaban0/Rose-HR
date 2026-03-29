import 'package:json_annotation/json_annotation.dart';

part 'punch_correction_response_model.g.dart';

@JsonSerializable(createFactory: false)
class PunchCorrectionResponseModel {
  PunchCorrectionResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory PunchCorrectionResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return PunchCorrectionResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? PunchCorrectionResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  PunchCorrectionResult? result;

  Map<String, dynamic> toJson() => _$PunchCorrectionResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class PunchCorrectionResult {
  PunchCorrectionResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PunchCorrectionResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return PunchCorrectionResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? PunchCorrectionData.fromJson(rawData) : null,
    );
  }

  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  PunchCorrectionData? data;

  Map<String, dynamic> toJson() => _$PunchCorrectionResultToJson(this);
}

@JsonSerializable()
class PunchCorrectionData {
  PunchCorrectionData({
    this.id,
    this.name,
    this.employeeId,
    this.employeeName,
    this.correctionType,
    this.correctionTypeDisplay,
    this.date,
    this.correctionTime,
    this.attendanceLogId,
    this.reason,
    this.state,
    this.stateDisplay,
    this.managerId,
    this.managerName,
    this.resAttendanceId,
    this.shiftName,
    this.fixAttendanceMethod,
  });

  factory PunchCorrectionData.fromJson(Map<String, dynamic> json) => _$PunchCorrectionDataFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "employee_id")
  int? employeeId;
  @JsonKey(name: "employee_name")
  String? employeeName;
  @JsonKey(name: "correction_type")
  String? correctionType;
  @JsonKey(name: "correction_type_display")
  String? correctionTypeDisplay;
  @JsonKey(name: "date")
  DateTime? date;
  @JsonKey(name: "correction_time")
  double? correctionTime;
  @JsonKey(name: "attendance_log_id")
  int? attendanceLogId;
  @JsonKey(name: "reason")
  String? reason;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "state_display")
  String? stateDisplay;
  @JsonKey(name: "manager_id")
  int? managerId;
  @JsonKey(name: "manager_name")
  String? managerName;
  @JsonKey(name: "res_attendance_id")
  int? resAttendanceId;
  @JsonKey(name: "shift_name")
  String? shiftName;
  @JsonKey(name: "fix_attendance_method")
  String? fixAttendanceMethod;

  Map<String, dynamic> toJson() => _$PunchCorrectionDataToJson(this);
}
