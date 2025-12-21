// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_attendance_punch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAttendancePunchRequest _$CreateAttendancePunchRequestFromJson(
  Map<String, dynamic> json,
) => CreateAttendancePunchRequest(
  geoInformation: GeoInformation.fromJson(
    json['geo_information'] as Map<String, dynamic>,
  ),
  deviceInfo: json['device_info'] as String,
  actionDatetime: json['action_datetime'] as String,
);

Map<String, dynamic> _$CreateAttendancePunchRequestToJson(
  CreateAttendancePunchRequest instance,
) => <String, dynamic>{
  'geo_information': instance.geoInformation,
  'device_info': instance.deviceInfo,
  'action_datetime': instance.actionDatetime,
};

GeoInformation _$GeoInformationFromJson(Map<String, dynamic> json) =>
    GeoInformation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$GeoInformationToJson(GeoInformation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
