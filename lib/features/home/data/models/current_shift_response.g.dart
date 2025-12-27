// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_shift_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentShiftResponse _$CurrentShiftResponseFromJson(
  Map<String, dynamic> json,
) => CurrentShiftResponse(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : CurrentShiftResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CurrentShiftResponseToJson(
  CurrentShiftResponse instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

CurrentShiftResult _$CurrentShiftResultFromJson(Map<String, dynamic> json) =>
    CurrentShiftResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentShiftResultToJson(CurrentShiftResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  longitude: (json['longitude'] as num?)?.toDouble(),
  latitude: (json['latitude'] as num?)?.toDouble(),
  radius: (json['radius'] as num?)?.toInt(),
  shiftHourFrom: (json['shift_hour_from'] as num?)?.toInt(),
  shiftHourTo: (json['shift_hour_to'] as num?)?.toInt(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'longitude': instance.longitude,
  'latitude': instance.latitude,
  'radius': instance.radius,
  'shift_hour_from': instance.shiftHourFrom,
  'shift_hour_to': instance.shiftHourTo,
};
