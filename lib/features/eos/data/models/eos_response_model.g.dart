// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eos_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$EosResponseModelToJson(EosResponseModel instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'result': instance.result,
    };

EosResult _$EosResultFromJson(Map<String, dynamic> json) => EosResult(
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
  message: json['message'] as String,
  data: json['data'],
);

Map<String, dynamic> _$EosResultToJson(EosResult instance) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
