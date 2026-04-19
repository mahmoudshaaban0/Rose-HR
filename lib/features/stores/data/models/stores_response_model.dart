import 'package:json_annotation/json_annotation.dart';
import 'package:rose_hr/features/stores/data/models/store_model.dart';

part 'stores_response_model.g.dart';

/// Response model following the project's API structure
@JsonSerializable(createFactory: false)
class StoresResponseModel {
  StoresResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory StoresResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return StoresResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? StoresResult.fromJson(rawResult) : null,
    );
  }

  @JsonKey(name: 'jsonrpc')
  String? jsonrpc;

  @JsonKey(name: 'id')
  dynamic id;

  @JsonKey(name: 'result')
  StoresResult? result;

  Map<String, dynamic> toJson() => _$StoresResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class StoresResult {
  StoresResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory StoresResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<StoreModel>? stores;

    if (rawData is List) {
      stores = rawData.map((item) => StoreModel.fromJson(item as Map<String, dynamic>)).toList();
    }

    return StoresResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: stores,
    );
  }

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'status_code')
  int? statusCode;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'data')
  List<StoreModel>? data;

  Map<String, dynamic> toJson() => _$StoresResultToJson(this);
}
