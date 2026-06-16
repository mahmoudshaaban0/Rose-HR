import 'package:json_annotation/json_annotation.dart';

part 'eos_request_model.g.dart';

@JsonSerializable()
class EosRequestModel {
  EosRequestModel({
    required this.params,
  });

  factory EosRequestModel.fromJson(Map<String, dynamic> json) => _$EosRequestModelFromJson(json);

  final EosRequestParams params;

  Map<String, dynamic> toJson() => _$EosRequestModelToJson(this);

  @override
  String toString() {
    return 'EosRequestModel(params: $params)';
  }
}

@JsonSerializable()
class EosRequestParams {
  EosRequestParams({
    required this.lastWorkingDay,
    required this.resignationReason,
    this.resignationReasonDetail,
    this.attachments,
  });

  factory EosRequestParams.fromJson(Map<String, dynamic> json) => _$EosRequestParamsFromJson(json);

  @JsonKey(name: 'last_working_day')
  final String lastWorkingDay;

  /// One of: 'resignation', 'termination' (based on employee nationality).
  @JsonKey(name: 'resignation_reason')
  final String resignationReason;

  @JsonKey(name: 'resignation_reason_detail', includeIfNull: false)
  final String? resignationReasonDetail;

  @JsonKey(name: 'attachments', includeIfNull: false)
  final List<EosAttachmentModel>? attachments;

  Map<String, dynamic> toJson() => _$EosRequestParamsToJson(this);

  @override
  String toString() {
    return 'EosRequestParams(lastWorkingDay: $lastWorkingDay, resignationReason: $resignationReason, resignationReasonDetail: $resignationReasonDetail, attachments: $attachments)';
  }
}

@JsonSerializable()
class EosAttachmentModel {
  EosAttachmentModel({
    required this.mimetype,
    required this.name,
    required this.data,
  });

  factory EosAttachmentModel.fromJson(Map<String, dynamic> json) => _$EosAttachmentModelFromJson(json);

  @JsonKey(name: 'mimetype')
  final String mimetype;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'data')
  final String data;

  Map<String, dynamic> toJson() => _$EosAttachmentModelToJson(this);

  @override
  String toString() {
    return 'EosAttachmentModel(mimetype: $mimetype, name: $name, data: [${data.length} chars])';
  }
}
