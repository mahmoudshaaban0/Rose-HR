import 'package:json_annotation/json_annotation.dart';

part 'create_attendance_punch_response.g.dart';

@JsonSerializable()
class CreateAttendancePunchResponse {
  CreateAttendancePunchResponse({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory CreateAttendancePunchResponse.fromJson(Map<String, dynamic> json) => _$CreateAttendancePunchResponseFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AttendancePunchResult? result;

  Map<String, dynamic> toJson() => _$CreateAttendancePunchResponseToJson(this);
}

@JsonSerializable()
class AttendancePunchResult {
  AttendancePunchResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendancePunchResult.fromJson(Map<String, dynamic> json) => _$AttendancePunchResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$AttendancePunchResultToJson(this);
}

@JsonSerializable()
class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
