import 'package:json_annotation/json_annotation.dart';

part 'single_request_response_by_id.g.dart';

@JsonSerializable()
class SingleRequestResponseById {
  SingleRequestResponseById({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory SingleRequestResponseById.fromJson(Map<String, dynamic> json) => _$SingleRequestResponseByIdFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  RequestResult? result;

  Map<String, dynamic> toJson() => _$SingleRequestResponseByIdToJson(this);
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
    this.workMissionType,
    this.missionStartDate,
    this.missionEndDate,
    this.attachments,
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
  /// Decimal hour value, e.g. 16.65 = 16:39
  @JsonKey(name: "time_from")
  double? timeFrom;
  /// Decimal hour value, e.g. 19.8 = 19:48
  @JsonKey(name: "time_to")
  double? timeTo;
  @JsonKey(name: "reason")
  String? reason;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "state_display")
  String? stateDisplay;
  /// Duration in decimal hours, e.g. 3.15
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
  /// "hours" or "days"
  @JsonKey(name: "work_mission_type")
  String? workMissionType;
  @JsonKey(name: "mission_start_date")
  DateTime? missionStartDate;
  @JsonKey(name: "mission_end_date")
  DateTime? missionEndDate;
  @JsonKey(name: "attachments")
  List<RequestAttachment>? attachments;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class RequestAttachment {
  RequestAttachment({this.id, this.name, this.url, this.mimetype});

  factory RequestAttachment.fromJson(Map<String, dynamic> json) =>
      _$RequestAttachmentFromJson(json);

  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "mimetype")
  String? mimetype;

  bool get isPdf => mimetype?.contains('pdf') ?? false;
  bool get isImage =>
      mimetype?.startsWith('image/') ?? false;

  Map<String, dynamic> toJson() => _$RequestAttachmentToJson(this);
}
