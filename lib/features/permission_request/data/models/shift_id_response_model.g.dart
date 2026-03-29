// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_id_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ShiftIdResponseModelToJson(
  ShiftIdResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$ShiftIdResultToJson(ShiftIdResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  hourFrom: (json['hour_from'] as num?)?.toDouble(),
  hourTo: (json['hour_to'] as num?)?.toDouble(),
  checkIn: json['check_in'],
  checkOut: json['check_out'],
  timeLateIn: (json['time_late_in'] as num?)?.toDouble(),
  timeEarlyOut: (json['time_early_out'] as num?)?.toDouble(),
  totalLateTime: (json['total_late_time'] as num?)?.toDouble(),
  totalWorkTime: (json['total_work_time'] as num?)?.toDouble(),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'hour_from': instance.hourFrom,
  'hour_to': instance.hourTo,
  'check_in': instance.checkIn,
  'check_out': instance.checkOut,
  'time_late_in': instance.timeLateIn,
  'time_early_out': instance.timeEarlyOut,
  'total_late_time': instance.totalLateTime,
  'total_work_time': instance.totalWorkTime,
};
