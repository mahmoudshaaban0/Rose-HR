import 'package:json_annotation/json_annotation.dart';

part 'create_attendance_punch_request.g.dart';

@JsonSerializable()
class CreateAttendancePunchRequest {
  CreateAttendancePunchRequest({
    required this.geoInformation,
    required this.deviceInfo,
    required this.actionDatetime,
  });

  factory CreateAttendancePunchRequest.fromJson(Map<String, dynamic> json) => _$CreateAttendancePunchRequestFromJson(json);

  @JsonKey(name: 'geo_information')
  final GeoInformation geoInformation;

  @JsonKey(name: 'device_info')
  final String deviceInfo;

  @JsonKey(name: 'action_datetime')
  final String actionDatetime;

  Map<String, dynamic> toJson() => _$CreateAttendancePunchRequestToJson(this);

  // to string
  @override
  String toString() {
    return 'CreateAttendancePunchRequest(geoInformation: $geoInformation, deviceInfo: $deviceInfo, actionDatetime: $actionDatetime)';
  }
}

@JsonSerializable()
class GeoInformation {
  GeoInformation({
    required this.latitude,
    required this.longitude,
  });

  factory GeoInformation.fromJson(Map<String, dynamic> json) => _$GeoInformationFromJson(json);

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  // to string
  @override
  String toString() {
    return 'GeoInformation(latitude: $latitude, longitude: $longitude)';
  }

  Map<String, dynamic> toJson() => _$GeoInformationToJson(this);
}
