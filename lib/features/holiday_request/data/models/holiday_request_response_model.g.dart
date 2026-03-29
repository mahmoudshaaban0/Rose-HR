// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_request_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$HolidayRequestResponseModelToJson(
  HolidayRequestResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

HolidayRequestResult _$HolidayRequestResultFromJson(
  Map<String, dynamic> json,
) => HolidayRequestResult(
  success: json['success'] as bool,
  statusCode: (json['status_code'] as num).toInt(),
  message: json['message'] as String,
  data: json['data'],
);

Map<String, dynamic> _$HolidayRequestResultToJson(
  HolidayRequestResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};
