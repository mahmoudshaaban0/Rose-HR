import 'package:json_annotation/json_annotation.dart';

part 'holiday_request_model.g.dart';

@JsonSerializable()
class HolidayRequestModel {
  HolidayRequestModel({
    required this.params,
  });

  factory HolidayRequestModel.fromJson(Map<String, dynamic> json) => _$HolidayRequestModelFromJson(json);

  final HolidayRequestParams params;

  Map<String, dynamic> toJson() => _$HolidayRequestModelToJson(this);

  @override
  String toString() {
    return 'HolidayRequestModel(params: $params)';
  }
}

@JsonSerializable()
class HolidayRequestParams {
  HolidayRequestParams({
    required this.leaveTypeId,
    required this.dateFrom,
    required this.dateTo,
    required this.requireAdvanceSalary,
    required this.requireExitEntryVisa,
    this.description,
    this.visaType,
    this.visaPeriod,
    this.visaNeededBefore,
    this.bereavementType,
    this.attachmentIds,
  });

  factory HolidayRequestParams.fromJson(Map<String, dynamic> json) => _$HolidayRequestParamsFromJson(json);

  @JsonKey(name: 'leave_type_id')
  final int leaveTypeId;

  @JsonKey(name: 'date_from')
  final String dateFrom;

  @JsonKey(name: 'date_to')
  final String dateTo;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'require_advance_salary')
  final bool requireAdvanceSalary;

  @JsonKey(name: 'require_exit_entry_visa')
  final bool requireExitEntryVisa;

  @JsonKey(name: 'visa_type', includeIfNull: false)
  final String? visaType;

  @JsonKey(name: 'visa_period', includeIfNull: false)
  final String? visaPeriod;

  @JsonKey(name: 'visa_needed_before', includeIfNull: false)
  final String? visaNeededBefore;

  @JsonKey(name: 'bereavement_type', includeIfNull: false)
  final String? bereavementType;

  @JsonKey(name: 'attachment_ids', includeIfNull: false)
  final List<AttachmentModel>? attachmentIds;

  Map<String, dynamic> toJson() => _$HolidayRequestParamsToJson(this);

  @override
  String toString() {
    return 'HolidayRequestParams(leaveTypeId: $leaveTypeId, dateFrom: $dateFrom, dateTo: $dateTo, requireAdvanceSalary: $requireAdvanceSalary, requireExitEntryVisa: $requireExitEntryVisa, description: $description, visaType: $visaType, visaPeriod: $visaPeriod, visaNeededBefore: $visaNeededBefore, bereavementType: $bereavementType, attachmentIds: $attachmentIds)';
  }
}

@JsonSerializable()
class AttachmentModel {
  AttachmentModel({
    required this.mimetype,
    required this.name,
    required this.data,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) => _$AttachmentModelFromJson(json);

  @JsonKey(name: 'mimetype')
  final String mimetype;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'data')
  final String data;

  Map<String, dynamic> toJson() => _$AttachmentModelToJson(this);

  @override
  String toString() {
    return 'AttachmentModel(mimetype: $mimetype, name: $name, data: [${data.length} chars])';
  }
}
