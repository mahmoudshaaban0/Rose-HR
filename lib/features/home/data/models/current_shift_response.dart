import 'package:json_annotation/json_annotation.dart';

part 'current_shift_response.g.dart';

@JsonSerializable()
class CurrentShiftResponse {
  CurrentShiftResponse({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory CurrentShiftResponse.fromJson(Map<String, dynamic> json) => _$CurrentShiftResponseFromJson(json);
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  CurrentShiftResult? result;

  Map<String, dynamic> toJson() => _$CurrentShiftResponseToJson(this);
}

@JsonSerializable()
class CurrentShiftResult {
  CurrentShiftResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CurrentShiftResult.fromJson(Map<String, dynamic> json) => _$CurrentShiftResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$CurrentShiftResultToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.longitude,
    this.latitude,
    this.radius,
    this.shiftHourFrom,
    this.shiftHourTo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: "longitude")
  double? longitude;
  @JsonKey(name: "latitude")
  double? latitude;
  @JsonKey(name: "radius")
  int? radius;
  @JsonKey(name: "shift_hour_from")
  int? shiftHourFrom;
  @JsonKey(name: "shift_hour_to")
  int? shiftHourTo;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
