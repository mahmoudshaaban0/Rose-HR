import 'package:json_annotation/json_annotation.dart';

part 'attendance_summary_details_response_model.g.dart';

@JsonSerializable()
class AttendanceSummaryDetailsResponseModel {
  AttendanceSummaryDetailsResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory AttendanceSummaryDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSummaryDetailsResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AttendanceSummaryDetailsResult? result;

  Map<String, dynamic> toJson() => _$AttendanceSummaryDetailsResponseModelToJson(this);
}

@JsonSerializable()
class AttendanceSummaryDetailsResult {
  AttendanceSummaryDetailsResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendanceSummaryDetailsResult.fromJson(Map<String, dynamic> json) => _$AttendanceSummaryDetailsResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$AttendanceSummaryDetailsResultToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.date,
    this.offDay,
    this.publicOff,
    this.leave,
    this.absence,
    this.description,
    this.the2Shifts,
    this.checkInTime,
    this.lateInTime,
    this.checkOutTime,
    this.earlyOutTime,
    this.totalLateTime,
    this.totalWorkTime,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: "date")
  DateTime? date;
  @JsonKey(name: "off_day")
  bool? offDay;
  @JsonKey(name: "public_off")
  bool? publicOff;
  @JsonKey(name: "leave")
  bool? leave;
  @JsonKey(name: "absence")
  bool? absence;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "2_shifts")
  bool? the2Shifts;
  @JsonKey(name: "check_in_time")
  dynamic checkInTime;
  @JsonKey(name: "late_in_time")
  dynamic lateInTime;
  @JsonKey(name: "check_out_time")
  dynamic checkOutTime;
  @JsonKey(name: "early_out_time")
  dynamic earlyOutTime;
  @JsonKey(name: "total_late_time")
  dynamic totalLateTime;
  @JsonKey(name: "total_work_time")
  dynamic totalWorkTime;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
