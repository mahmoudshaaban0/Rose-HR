import 'package:json_annotation/json_annotation.dart';

part 'holiday_request_response_model.g.dart';

@JsonSerializable()
class HolidayRequestResponseModel {
  HolidayRequestResponseModel({
    required this.jsonrpc,
    required this.result,
    this.id,
  });

  factory HolidayRequestResponseModel.fromJson(Map<String, dynamic> json) => _$HolidayRequestResponseModelFromJson(json);

  @JsonKey(name: 'jsonrpc')
  final String jsonrpc;

  @JsonKey(name: 'id')
  final dynamic id;

  @JsonKey(name: 'result')
  final HolidayRequestResult result;

  Map<String, dynamic> toJson() => _$HolidayRequestResponseModelToJson(this);
}

@JsonSerializable()
class HolidayRequestResult {
  HolidayRequestResult({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory HolidayRequestResult.fromJson(Map<String, dynamic> json) => _$HolidayRequestResultFromJson(json);

  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'status_code')
  final int statusCode;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final dynamic data; // Can be int (on success) or Map<String, dynamic> (on error)

  /// Get the leave request ID if data is an integer
  int? get leaveRequestId => data is int ? data as int : null;

  Map<String, dynamic> toJson() => _$HolidayRequestResultToJson(this);
}
