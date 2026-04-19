// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_store_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SingleStoreResponseModelToJson(
  SingleStoreResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$SingleStoreResultToJson(SingleStoreResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };
