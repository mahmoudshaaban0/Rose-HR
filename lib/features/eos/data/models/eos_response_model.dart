import 'package:json_annotation/json_annotation.dart';

part 'eos_response_model.g.dart';

@JsonSerializable(createFactory: false)
class EosResponseModel {
  EosResponseModel({
    required this.jsonrpc,
    required this.result,
    this.id,
  });

  factory EosResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return EosResponseModel(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'],
      result: rawResult is Map<String, dynamic>
          ? EosResult.fromJson(rawResult)
          : EosResult(success: false, statusCode: 0, message: ''),
    );
  }

  @JsonKey(name: 'jsonrpc')
  final String jsonrpc;

  @JsonKey(name: 'id')
  final dynamic id;

  @JsonKey(name: 'result')
  final EosResult result;

  Map<String, dynamic> toJson() => _$EosResponseModelToJson(this);
}

@JsonSerializable()
class EosResult {
  EosResult({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory EosResult.fromJson(Map<String, dynamic> json) => _$EosResultFromJson(json);

  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'status_code')
  final int statusCode;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'data')
  final dynamic data; // Can be int (on success) or Map<String, dynamic> (on error)

  Map<String, dynamic> toJson() => _$EosResultToJson(this);
}
