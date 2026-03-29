// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CancelRequestResponseModelToJson(
  CancelRequestResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

CancelResult _$CancelResultFromJson(Map<String, dynamic> json) => CancelResult(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$CancelResultToJson(CancelResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
    };
