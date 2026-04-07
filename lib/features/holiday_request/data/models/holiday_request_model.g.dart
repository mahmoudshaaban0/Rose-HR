// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HolidayRequestModel _$HolidayRequestModelFromJson(Map<String, dynamic> json) =>
    HolidayRequestModel(
      params: HolidayRequestParams.fromJson(
        json['params'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$HolidayRequestModelToJson(
  HolidayRequestModel instance,
) => <String, dynamic>{'params': instance.params.toJson()};

HolidayRequestParams _$HolidayRequestParamsFromJson(
  Map<String, dynamic> json,
) => HolidayRequestParams(
  leaveTypeId: (json['leave_type_id'] as num).toInt(),
  dateFrom: json['date_from'] as String,
  dateTo: json['date_to'] as String,
  requireAdvanceSalary: json['require_advance_salary'] as bool,
  requireExitEntryVisa: json['require_exit_entry_visa'] as bool,
  description: json['description'] as String?,
  visaType: json['visa_type'] as String?,
  visaPeriod: json['visa_period'] as String?,
  visaNeededBefore: json['visa_needed_before'] as String?,
  bereavementType: json['bereavement_type'] as String?,
  attachmentIds: (json['attachment_ids'] as List<dynamic>?)
      ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HolidayRequestParamsToJson(
  HolidayRequestParams instance,
) => <String, dynamic>{
  'leave_type_id': instance.leaveTypeId,
  'date_from': instance.dateFrom,
  'date_to': instance.dateTo,
  'description': instance.description,
  'require_advance_salary': instance.requireAdvanceSalary,
  'require_exit_entry_visa': instance.requireExitEntryVisa,
  'visa_type': ?instance.visaType,
  'visa_period': ?instance.visaPeriod,
  'visa_needed_before': ?instance.visaNeededBefore,
  'bereavement_type': ?instance.bereavementType,
  'attachment_ids': ?instance.attachmentIds?.map((e) => e.toJson()).toList(),
};

AttachmentModel _$AttachmentModelFromJson(Map<String, dynamic> json) =>
    AttachmentModel(
      mimetype: json['mimetype'] as String,
      name: json['name'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$AttachmentModelToJson(AttachmentModel instance) =>
    <String, dynamic>{
      'mimetype': instance.mimetype,
      'name': instance.name,
      'data': instance.data,
    };
