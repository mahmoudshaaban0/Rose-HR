import 'package:json_annotation/json_annotation.dart';

part 'create_attendance_punch_response.g.dart';

@JsonSerializable(createFactory: false)
class CreateAttendancePunchResponse {
  CreateAttendancePunchResponse({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory CreateAttendancePunchResponse.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return CreateAttendancePunchResponse(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? AttendancePunchResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AttendancePunchResult? result;

  Map<String, dynamic> toJson() => _$CreateAttendancePunchResponseToJson(this);
}

@JsonSerializable(createFactory: false)
class AttendancePunchResult {
  AttendancePunchResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendancePunchResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AttendancePunchResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? Data.fromJson(rawData) : null,
    );
  }

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
