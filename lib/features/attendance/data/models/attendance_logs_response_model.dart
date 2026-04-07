import 'package:json_annotation/json_annotation.dart';

part 'attendance_logs_response_model.g.dart';

@JsonSerializable()
class AttendanceLogsResponseModel {
  AttendanceLogsResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory AttendanceLogsResponseModel.fromJson(Map<String, dynamic> json) => _$AttendanceLogsResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AttendanceResult? result;

  Map<String, dynamic> toJson() => _$AttendanceLogsResponseModelToJson(this);
}

@JsonSerializable()
class AttendanceResult {
  AttendanceResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendanceResult.fromJson(Map<String, dynamic> json) => _$AttendanceResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Datum>? data;

  Map<String, dynamic> toJson() => _$AttendanceResultToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.actionDatetime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "action_datetime")
  DateTime? actionDatetime;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
