import 'package:json_annotation/json_annotation.dart';

part 'attendance_summary_response_model.g.dart';

@JsonSerializable(createFactory: false)
class AttendanceSummary {
  AttendanceSummary({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return AttendanceSummary(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? AttendanceResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AttendanceResult? result;

  Map<String, dynamic> toJson() => _$AttendanceSummaryToJson(this);
}

@JsonSerializable(createFactory: false)
class AttendanceResult {
  AttendanceResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendanceResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AttendanceResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is List
          ? rawData.map((e) => Datum.fromJson(e as Map<String, dynamic>)).toList()
          : null,
    );
  }

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
    this.date,
    this.offDay,
    this.publicOff,
    this.leave,
    this.incompAttend,
    this.absence,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: "date")
  DateTime? date;
  @JsonKey(name: "off_day")
  bool? offDay;
  @JsonKey(name: "public_off")
  bool? publicOff;
  @JsonKey(name: "leave")
  bool? leave;
  @JsonKey(name: "incomp_attendance")
  bool? incompAttend;
  @JsonKey(name: "absence")
  bool? absence;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
