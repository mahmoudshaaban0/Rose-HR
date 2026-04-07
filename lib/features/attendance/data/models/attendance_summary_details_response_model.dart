import 'package:json_annotation/json_annotation.dart';

part 'attendance_summary_details_response_model.g.dart';

@JsonSerializable(createFactory: false)
class AttendanceSummaryDetailsResponseModel {
  AttendanceSummaryDetailsResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory AttendanceSummaryDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return AttendanceSummaryDetailsResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? AttendanceSummaryDetailsResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  AttendanceSummaryDetailsResult? result;

  Map<String, dynamic> toJson() => _$AttendanceSummaryDetailsResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class AttendanceSummaryDetailsResult {
  AttendanceSummaryDetailsResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory AttendanceSummaryDetailsResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AttendanceSummaryDetailsResult(
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
    this.shifts,
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

  /// List of shifts for this day — may contain 1, 2, or more objects.
  @JsonKey(name: "shifts")
  List<ShiftData>? shifts;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

/// Represents a single shift record inside the shifts array.
///
/// All time fields arrive as strings from the backend.
/// A value of "0.0" (or "0") means "no data" and should display as "--:--".
@JsonSerializable()
class ShiftData {
  ShiftData({
    this.checkInTime,
    this.lateInTime,
    this.checkOutTime,
    this.earlyOutTime,
    this.totalLateTime,
    this.totalWorkTime,
  });

  factory ShiftData.fromJson(Map<String, dynamic> json) => _$ShiftDataFromJson(json);

  /// Time of check-in, e.g. "07:25:57". Null / "0.0" → "--:--"
  @JsonKey(name: "check_in_time")
  String? checkInTime;

  /// Late-in amount in decimal hours as a string, e.g. "1.18". "0.0" → no badge
  @JsonKey(name: "late_in_time")
  String? lateInTime;

  /// Time of check-out, e.g. "13:15:36". Null / "0.0" → "--:--"
  @JsonKey(name: "check_out_time")
  String? checkOutTime;

  /// Early-out amount in decimal hours as a string, e.g. "1.74". "0.0" → no badge
  @JsonKey(name: "early_out_time")
  String? earlyOutTime;

  /// Total late/overtime in decimal hours as a string, e.g. "2.92".
  @JsonKey(name: "total_late_time")
  String? totalLateTime;

  /// Total work time in decimal hours as a string, e.g. "5.83". "0.0" → "--"
  @JsonKey(name: "total_work_time")
  String? totalWorkTime;

  /// Returns true if [lateInTime] represents an actual non-zero late value.
  bool get hasLateIn {
    final v = double.tryParse(lateInTime ?? '');
    return v != null && v != 0.0;
  }

  /// Returns true if [earlyOutTime] represents an actual non-zero early-out value.
  bool get hasEarlyOut {
    final v = double.tryParse(earlyOutTime ?? '');
    return v != null && v != 0.0;
  }

  /// Parses [totalLateTime] as a double. Returns null if absent / zero.
  double? get totalLateTimeValue {
    final v = double.tryParse(totalLateTime ?? '');
    return (v != null && v != 0.0) ? v : null;
  }

  /// Parses [totalWorkTime] as a double. Returns null if absent / zero.
  double? get totalWorkTimeValue {
    final v = double.tryParse(totalWorkTime ?? '');
    return (v != null && v != 0.0) ? v : null;
  }

  Map<String, dynamic> toJson() => _$ShiftDataToJson(this);
}
