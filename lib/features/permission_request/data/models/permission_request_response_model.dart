import 'package:json_annotation/json_annotation.dart';

part 'permission_request_response_model.g.dart';

@JsonSerializable()
class PermissionRequestResponseModel {
  PermissionRequestResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory PermissionRequestResponseModel.fromJson(Map<String, dynamic> json) => _$PermissionRequestResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  RequestResult? result;

  Map<String, dynamic> toJson() => _$PermissionRequestResponseModelToJson(this);
}

@JsonSerializable()
class RequestResult {
  RequestResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory RequestResult.fromJson(Map<String, dynamic> json) => _$RequestResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$RequestResultToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.id,
    this.name,
    this.employeeId,
    this.employeeName,
    this.requestType,
    this.requestTypeDisplay,
    this.date,
    this.timeFrom,
    this.timeTo,
    this.reason,
    this.state,
    this.stateDisplay,
    this.requestedDuration,
    this.partialExcuse,
    this.managerId,
    this.managerName,
    this.resAttendanceId,
    this.shiftName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "employee_id")
  int? employeeId;
  @JsonKey(name: "employee_name")
  String? employeeName;
  @JsonKey(name: "request_type")
  String? requestType;
  @JsonKey(name: "request_type_display")
  String? requestTypeDisplay;
  @JsonKey(name: "date")
  DateTime? date;
  @JsonKey(name: "time_from")
  int? timeFrom;
  @JsonKey(name: "time_to")
  int? timeTo;
  @JsonKey(name: "reason")
  String? reason;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "state_display")
  String? stateDisplay;
  @JsonKey(name: "requested_duration")
  double? requestedDuration;
  @JsonKey(name: "partial_excuse")
  bool? partialExcuse;
  @JsonKey(name: "manager_id")
  int? managerId;
  @JsonKey(name: "manager_name")
  String? managerName;
  @JsonKey(name: "res_attendance_id")
  int? resAttendanceId;
  @JsonKey(name: "shift_name")
  String? shiftName;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
