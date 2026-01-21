// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_mission_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkMissionRequestModel _$WorkMissionRequestModelFromJson(
  Map<String, dynamic> json,
) => WorkMissionRequestModel(
  workMissionType: json['work_mission_type'] as String,
  attachmentIds: (json['attachment_ids'] as List<dynamic>)
      .map((e) => AttachmentData.fromJson(e as Map<String, dynamic>))
      .toList(),
  date: json['date'] as String?,
  shiftId: (json['shift_id'] as num?)?.toInt(),
  timeFrom: (json['time_from'] as num?)?.toDouble(),
  timeTo: (json['time_to'] as num?)?.toDouble(),
  missionStartDate: json['mission_start_date'] as String?,
  missionEndDate: json['mission_end_date'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$WorkMissionRequestModelToJson(
  WorkMissionRequestModel instance,
) => <String, dynamic>{
  'work_mission_type': instance.workMissionType,
  'date': ?instance.date,
  'shift_id': ?instance.shiftId,
  'time_from': ?instance.timeFrom,
  'time_to': ?instance.timeTo,
  'mission_start_date': ?instance.missionStartDate,
  'mission_end_date': ?instance.missionEndDate,
  'reason': ?instance.reason,
  'attachment_ids': instance.attachmentIds,
};
