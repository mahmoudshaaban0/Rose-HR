// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_id_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftIdResponseModel _$ShiftIdResponseModelFromJson(
  Map<String, dynamic> json,
) => ShiftIdResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : Result.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShiftIdResponseModelToJson(
  ShiftIdResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  hourFrom: (json['hour_from'] as num?)?.toInt(),
  hourTo: (json['hour_to'] as num?)?.toInt(),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'hour_from': instance.hourFrom,
  'hour_to': instance.hourTo,
};
