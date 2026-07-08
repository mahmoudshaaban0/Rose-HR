// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'get_all_leave_types_response_model.g.dart';

@JsonSerializable()
class AlleaveTypesResponseModel {
  AlleaveTypesResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory AlleaveTypesResponseModel.fromJson(Map<String, dynamic> json) => _$AlleaveTypesResponseModelFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  LeaveTypesResult? result;

  Map<String, dynamic> toJson() => _$AlleaveTypesResponseModelToJson(this);
}

@JsonSerializable()
class LeaveTypesResult {
  LeaveTypesResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LeaveTypesResult.fromJson(Map<String, dynamic> json) => _$LeaveTypesResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Datum>? data;

  Map<String, dynamic> toJson() => _$LeaveTypesResultToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.name,
    this.technicalName,
    this.hasValidAllocation,
    this.requiresAllocation,
    this.virtualRemainingLeaves,
    this.hasLimitedDays,
    this.numberOfLimitedDays,
    this.requireAttachment,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "technical_name")
  String? technicalName;
  @JsonKey(name: "has_valid_allocation")
  bool? hasValidAllocation;
  @JsonKey(name: "requires_allocation")
  RequiresAllocation? requiresAllocation;
  @JsonKey(name: "virtual_remaining_leaves")
  int? virtualRemainingLeaves;
  @JsonKey(name: "has_limited_days")
  bool? hasLimitedDays;
  @JsonKey(name: "number_of_limited_days")
  int? numberOfLimitedDays;
  @JsonKey(name: "require_attachment")
  bool? requireAttachment;

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

enum RequiresAllocation {
  @JsonValue("no")
  NO,
  @JsonValue("yes")
  YES,
}
