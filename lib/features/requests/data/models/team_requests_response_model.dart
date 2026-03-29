import 'package:json_annotation/json_annotation.dart';

part 'team_requests_response_model.g.dart';

@JsonSerializable(createFactory: false)
class TeamRequestsResponseModel {
  TeamRequestsResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory TeamRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return TeamRequestsResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? TeamRequestsResult.fromJson(rawResult) : null,
    );
  }

  @JsonKey(name: 'jsonrpc')
  String? jsonrpc;

  @JsonKey(name: 'id')
  dynamic id;

  @JsonKey(name: 'result')
  TeamRequestsResult? result;

  Map<String, dynamic> toJson() => _$TeamRequestsResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class TeamRequestsResult {
  TeamRequestsResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory TeamRequestsResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return TeamRequestsResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is List
          ? rawData.map((e) => TeamRequestItem.fromJson(e as Map<String, dynamic>)).toList()
          : null,
    );
  }

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
