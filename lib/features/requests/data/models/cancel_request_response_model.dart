import 'package:json_annotation/json_annotation.dart';

part 'cancel_request_response_model.g.dart';

@JsonSerializable(createFactory: false)
class CancelRequestResponseModel {
  CancelRequestResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory CancelRequestResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return CancelRequestResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? CancelResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  CancelResult? result;

  Map<String, dynamic> toJson() => _$CancelRequestResponseModelToJson(this);
}

@JsonSerializable()
class CancelResult {
  CancelResult({
    this.success,
    this.statusCode,
    this.message,
  });

  factory CancelResult.fromJson(Map<String, dynamic> json) => _$CancelResultFromJson(json);
  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;

  Map<String, dynamic> toJson() => _$CancelResultToJson(this);
}
