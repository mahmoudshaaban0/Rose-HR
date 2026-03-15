import 'package:json_annotation/json_annotation.dart';

part 'team_requests_response_model.g.dart';

@JsonSerializable()
class TeamRequestsResponseModel {
  TeamRequestsResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory TeamRequestsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TeamRequestsResponseModelFromJson(json);

  @JsonKey(name: 'jsonrpc')
  String? jsonrpc;

  @JsonKey(name: 'id')
  dynamic id;

  @JsonKey(name: 'result')
  TeamRequestsResult? result;

  Map<String, dynamic> toJson() => _$TeamRequestsResponseModelToJson(this);
}

@JsonSerializable()
class TeamRequestsResult {
  TeamRequestsResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory TeamRequestsResult.fromJson(Map<String, dynamic> json) =>
      _$TeamRequestsResultFromJson(json);

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'status_code')
  int? statusCode;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'data')
  List<TeamRequestItem>? data;

  Map<String, dynamic> toJson() => _$TeamRequestsResultToJson(this);
}

@JsonSerializable()
class TeamRequestItem {
  TeamRequestItem({
    this.id,
    this.name,
    this.requestType,
    this.requestTypeDisplay,
    this.employeeName,
    this.employeeJobTitle,
    this.employeeNumber,
    this.jobTitle,
    this.date,
    this.createDate,
    this.state,
    this.stateDisplay,
  });

  factory TeamRequestItem.fromJson(Map<String, dynamic> json) =>
      _$TeamRequestItemFromJson(json);

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'request_type')
  String? requestType;

  @JsonKey(name: 'request_type_display')
  String? requestTypeDisplay;

  @JsonKey(name: 'employee_name')
  String? employeeName;

  @JsonKey(name: 'employee_job_title')
  String? employeeJobTitle;

  @JsonKey(name: 'employee_number')
  dynamic employeeNumber;

  @JsonKey(name: 'job_title')
  String? jobTitle;

  @JsonKey(name: 'date')
  DateTime? date;

  @JsonKey(name: 'create_date')
  DateTime? createDate;

  @JsonKey(name: 'state')
  String? state;

  @JsonKey(name: 'state_display')
  String? stateDisplay;

  Map<String, dynamic> toJson() => _$TeamRequestItemToJson(this);
}
