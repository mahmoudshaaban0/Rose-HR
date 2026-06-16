// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eos_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EosRequestModel _$EosRequestModelFromJson(Map<String, dynamic> json) =>
    EosRequestModel(
      params: EosRequestParams.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EosRequestModelToJson(EosRequestModel instance) =>
    <String, dynamic>{'params': instance.params};

EosRequestParams _$EosRequestParamsFromJson(Map<String, dynamic> json) =>
    EosRequestParams(
      lastWorkingDay: json['last_working_day'] as String,
      resignationReason: json['resignation_reason'] as String,
      resignationReasonDetail: json['resignation_reason_detail'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => EosAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EosRequestParamsToJson(EosRequestParams instance) =>
    <String, dynamic>{
      'last_working_day': instance.lastWorkingDay,
      'resignation_reason': instance.resignationReason,
      'resignation_reason_detail': ?instance.resignationReasonDetail,
      'attachments': ?instance.attachments,
    };

EosAttachmentModel _$EosAttachmentModelFromJson(Map<String, dynamic> json) =>
    EosAttachmentModel(
      mimetype: json['mimetype'] as String,
      name: json['name'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$EosAttachmentModelToJson(EosAttachmentModel instance) =>
    <String, dynamic>{
      'mimetype': instance.mimetype,
      'name': instance.name,
      'data': instance.data,
    };
