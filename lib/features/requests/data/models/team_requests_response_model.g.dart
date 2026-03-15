// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_requests_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamRequestsResponseModel _$TeamRequestsResponseModelFromJson(
  Map<String, dynamic> json,
) => TeamRequestsResponseModel(
  jsonrpc: json['jsonrpc'] as String?,
  id: json['id'],
  result: json['result'] == null
      ? null
      : TeamRequestsResult.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeamRequestsResponseModelToJson(
  TeamRequestsResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

TeamRequestsResult _$TeamRequestsResultFromJson(Map<String, dynamic> json) =>
    TeamRequestsResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TeamRequestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamRequestsResultToJson(TeamRequestsResult instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status_code': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

TeamRequestItem _$TeamRequestItemFromJson(Map<String, dynamic> json) =>
    TeamRequestItem(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      requestType: json['request_type'] as String?,
      requestTypeDisplay: json['request_type_display'] as String?,
      employeeName: json['employee_name'] as String?,
      employeeJobTitle: json['employee_job_title'] as String?,
      employeeNumber: json['employee_number'],
      jobTitle: json['job_title'] as String?,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      createDate: json['create_date'] == null
          ? null
          : DateTime.parse(json['create_date'] as String),
      state: json['state'] as String?,
      stateDisplay: json['state_display'] as String?,
    );

Map<String, dynamic> _$TeamRequestItemToJson(TeamRequestItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'request_type': instance.requestType,
      'request_type_display': instance.requestTypeDisplay,
      'employee_name': instance.employeeName,
      'employee_job_title': instance.employeeJobTitle,
      'employee_number': instance.employeeNumber,
      'job_title': instance.jobTitle,
      'date': instance.date?.toIso8601String(),
      'create_date': instance.createDate?.toIso8601String(),
      'state': instance.state,
      'state_display': instance.stateDisplay,
    };
