import 'package:json_annotation/json_annotation.dart';
import 'package:rose_hr/features/stores/data/models/store_model.dart';

part 'single_store_response_model.g.dart';

/// Response model for single store operations
@JsonSerializable(createFactory: false)
class SingleStoreResponseModel {
  SingleStoreResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory SingleStoreResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return SingleStoreResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? SingleStoreResult.fromJson(rawResult) : null,
    );
  }

  @JsonKey(name: 'jsonrpc')
  String? jsonrpc;

  @JsonKey(name: 'id')
  dynamic id;

  @JsonKey(name: 'result')
  SingleStoreResult? result;

  Map<String, dynamic> toJson() => _$SingleStoreResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class SingleStoreResult {
  SingleStoreResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SingleStoreResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    StoreModel? store;

    if (rawData is Map<String, dynamic>) {
      store = StoreModel.fromJson(rawData);
    }

    return SingleStoreResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: store,
    );
  }

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'status_code')
  int? statusCode;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'data')
  StoreModel? data;

  Map<String, dynamic> toJson() => _$SingleStoreResultToJson(this);
}
