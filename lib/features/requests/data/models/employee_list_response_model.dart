import 'package:json_annotation/json_annotation.dart';

part 'employee_list_response_model.g.dart';

@JsonSerializable()
class EmployeeListResponseModel {
  EmployeeListResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory EmployeeListResponseModel.fromJson(Map<String, dynamic> json) => _$EmployeeListResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  ListResult? result;

  Map<String, dynamic> toJson() => _$EmployeeListResponseModelToJson(this);
}

@JsonSerializable()
class ListResult {
  ListResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory ListResult.fromJson(Map<String, dynamic> json) => _$ListResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Datum>? data;

  Map<String, dynamic> toJson() => _$ListResultToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.name,
    this.requestType,
    this.requestTypeDisplay,
    this.date,
    this.state,
    this.stateDisplay,
    this.requestedDuration,
    this.partialExcuse,
    this.canCancel,
    this.workMissionType,
    this.missionStartDate,
    this.missionEndDate,
    this.requestedDays,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "request_type")
  String? requestType;
  @JsonKey(name: "request_type_display")
  String? requestTypeDisplay;
  @JsonKey(name: "date")
  DateTime? date;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "state_display")
  String? stateDisplay;
  @JsonKey(name: "requested_duration")
  double? requestedDuration;
  @JsonKey(name: "partial_excuse")
  bool? partialExcuse;
  @JsonKey(name: "can_cancel")
  bool? canCancel;
  @JsonKey(name: "work_mission_type")
  dynamic workMissionType;
  @JsonKey(name: "mission_start_date")
  DateTime? missionStartDate;
  @JsonKey(name: "mission_end_date")
  DateTime? missionEndDate;
  @JsonKey(name: "requested_days")
  int? requestedDays;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
