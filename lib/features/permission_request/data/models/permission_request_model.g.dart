// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionRequestRequestModel _$PermissionRequestRequestModelFromJson(
  Map<String, dynamic> json,
) => PermissionRequestRequestModel(
  requestType: json['request_type'] as String,
  date: json['date'] as String,
  shiftId: (json['shift_id'] as num).toInt(),
  timeFrom: (json['time_from'] as num?)?.toDouble(),
  timeTo: (json['time_to'] as num?)?.toDouble(),
  partialExcuse: json['partial_excuse'] as bool?,
  requestedDuration: (json['requested_duration'] as num?)?.toDouble(),
  reason: json['reason'] as String?,
  attachmentIds: (json['attachment_ids'] as List<dynamic>?)
      ?.map((e) => AttachmentData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PermissionRequestRequestModelToJson(
  PermissionRequestRequestModel instance,
) => <String, dynamic>{
  'request_type': instance.requestType,
  'date': instance.date,
  'shift_id': instance.shiftId,
  'time_from': ?instance.timeFrom,
  'time_to': ?instance.timeTo,
  'partial_excuse': ?instance.partialExcuse,
  'requested_duration': ?instance.requestedDuration,
  'reason': ?instance.reason,
  'attachment_ids': ?instance.attachmentIds,
};

AttachmentData _$AttachmentDataFromJson(Map<String, dynamic> json) =>
    AttachmentData(
      name: json['name'] as String,
      data: json['data'] as String,
      mimetype: json['mimetype'] as String,
    );

Map<String, dynamic> _$AttachmentDataToJson(AttachmentData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
      'mimetype': instance.mimetype,
    };
