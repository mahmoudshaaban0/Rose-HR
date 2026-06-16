// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_request_response_by_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$SingleRequestResponseByIdToJson(
  SingleRequestResponseById instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$SingleRequestResultToJson(
  SingleRequestResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  recordType: json['record_type'] as String?,
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  employeeId: (json['employee_id'] as num?)?.toInt(),
  employeeName: json['employee_name'] as String?,
  state: json['state'] as String?,
  stateDisplay: json['state_display'] as String?,
  createDate: json['create_date'] == null
      ? null
      : DateTime.parse(json['create_date'] as String),
  reqRequestType: const FalseOrStringConverter().fromJson(
    json['req_request_type'],
  ),
  reqRequestTypeDisplay: const FalseOrStringConverter().fromJson(
    json['req_request_type_display'],
  ),
  reqDate: const FalseOrStringConverter().fromJson(json['req_date']),
  reqTimeFrom: const FalseOrStringConverter().fromJson(json['req_time_from']),
  reqTimeTo: const FalseOrStringConverter().fromJson(json['req_time_to']),
  reqReason: const FalseOrStringConverter().fromJson(json['req_reason']),
  reqRequestedDuration: const FalseOrStringConverter().fromJson(
    json['req_requested_duration'],
  ),
  reqPartialExcuse: json['req_partial_excuse'] as bool?,
  reqManagerId: const FalseOrStringConverter().fromJson(json['req_manager_id']),
  reqManagerName: const FalseOrStringConverter().fromJson(
    json['req_manager_name'],
  ),
  reqCorrectionType: const FalseOrStringConverter().fromJson(
    json['req_correction_type'],
  ),
  reqFixAttendanceMethod: const FalseOrStringConverter().fromJson(
    json['req_fix_attendance_method'],
  ),
  reqCorrectionTime: const FalseOrStringConverter().fromJson(
    json['req_correction_time'],
  ),
  reqAttendanceLogId: json['req_attendance_log_id'],
  reqWorkMissionType: const FalseOrStringConverter().fromJson(
    json['req_work_mission_type'],
  ),
  reqMissionStartDate: const FalseOrStringConverter().fromJson(
    json['req_mission_start_date'],
  ),
  reqMissionEndDate: const FalseOrStringConverter().fromJson(
    json['req_mission_end_date'],
  ),
  reqRequestedDays: const FalseOrStringConverter().fromJson(
    json['req_requested_days'],
  ),
  reqShiftId: const FalseOrStringConverter().fromJson(json['req_shift_id']),
  reqShiftName: const FalseOrStringConverter().fromJson(json['req_shift_name']),
  leaveTypeId: const FalseOrStringConverter().fromJson(json['leave_type_id']),
  leaveTypeName: const FalseOrStringConverter().fromJson(
    json['leave_type_name'],
  ),
  leaveDateFrom: const FalseOrStringConverter().fromJson(
    json['leave_date_from'],
  ),
  leaveDateTo: const FalseOrStringConverter().fromJson(json['leave_date_to']),
  leaveNumberOfDays: const FalseOrStringConverter().fromJson(
    json['leave_number_of_days'],
  ),
  leaveDescription: const FalseOrStringConverter().fromJson(
    json['leave_description'],
  ),
  leaveRequireExitEntryVisa: json['leave_require_exit_entry_visa'] as bool?,
  leaveVisaType: const FalseOrStringConverter().fromJson(
    json['leave_visa_type'],
  ),
  leaveVisaPeriod: const FalseOrStringConverter().fromJson(
    json['leave_visa_period'],
  ),
  leaveVisaNeededBefore: const FalseOrStringConverter().fromJson(
    json['leave_visa_needed_before'],
  ),
  leaveRequireAdvanceSalary: json['leave_require_advance_salary'] as bool?,
  leaveBereavementType: json['leave_bereavement_type'] as bool?,
  leaveCanCancel: json['leave_can_cancel'] as bool?,
  leaveCanApprove: json['leave_can_approve'] as bool?,
  clrLastWorkingDay: const FalseOrStringConverter().fromJson(
    json['clr_last_working_day'],
  ),
  clrResignationReason: const FalseOrStringConverter().fromJson(
    json['clr_resignation_reason'],
  ),
  clrResignationReasonDetail: const FalseOrStringConverter().fromJson(
    json['clr_resignation_reason_detail'],
  ),
  clrTotalSalary: json['clr_total_salary'] as num?,
  clrLeaveBalanceDays: json['clr_leave_balance_days'] as num?,
  clrLeaveBalanceAmount: json['clr_leave_balance_amount'] as num?,
  clrLoanSettlement: json['clr_loan_settlement'] as num?,
  clrEosGratuity: json['clr_eos_gratuity'] as num?,
  clrTotalAdditions: json['clr_total_additions'] as num?,
  clrTotalDeductions: json['clr_total_deductions'] as num?,
  clrNetAmount: json['clr_net_amount'] as num?,
  clrServiceYears: (json['clr_service_years'] as num?)?.toInt(),
  clrServiceMonths: (json['clr_service_months'] as num?)?.toInt(),
  clrServiceDays: (json['clr_service_days'] as num?)?.toInt(),
  clrPhysicalCustodyCleared: json['clr_physical_custody_cleared'] as bool?,
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
      .toList(),
  approvalChain: (json['approval_chain'] as List<dynamic>?)
      ?.map((e) => ApprovalChainItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'record_type': instance.recordType,
  'id': instance.id,
  'name': instance.name,
  'employee_id': instance.employeeId,
  'employee_name': instance.employeeName,
  'state': instance.state,
  'state_display': instance.stateDisplay,
  'create_date': instance.createDate?.toIso8601String(),
  'req_request_type': const FalseOrStringConverter().toJson(
    instance.reqRequestType,
  ),
  'req_request_type_display': const FalseOrStringConverter().toJson(
    instance.reqRequestTypeDisplay,
  ),
  'req_date': const FalseOrStringConverter().toJson(instance.reqDate),
  'req_time_from': const FalseOrStringConverter().toJson(instance.reqTimeFrom),
  'req_time_to': const FalseOrStringConverter().toJson(instance.reqTimeTo),
  'req_reason': const FalseOrStringConverter().toJson(instance.reqReason),
  'req_requested_duration': const FalseOrStringConverter().toJson(
    instance.reqRequestedDuration,
  ),
  'req_partial_excuse': instance.reqPartialExcuse,
  'req_manager_id': const FalseOrStringConverter().toJson(
    instance.reqManagerId,
  ),
  'req_manager_name': const FalseOrStringConverter().toJson(
    instance.reqManagerName,
  ),
  'req_correction_type': const FalseOrStringConverter().toJson(
    instance.reqCorrectionType,
  ),
  'req_fix_attendance_method': const FalseOrStringConverter().toJson(
    instance.reqFixAttendanceMethod,
  ),
  'req_correction_time': const FalseOrStringConverter().toJson(
    instance.reqCorrectionTime,
  ),
  'req_attendance_log_id': instance.reqAttendanceLogId,
  'req_work_mission_type': const FalseOrStringConverter().toJson(
    instance.reqWorkMissionType,
  ),
  'req_mission_start_date': const FalseOrStringConverter().toJson(
    instance.reqMissionStartDate,
  ),
  'req_mission_end_date': const FalseOrStringConverter().toJson(
    instance.reqMissionEndDate,
  ),
  'req_requested_days': const FalseOrStringConverter().toJson(
    instance.reqRequestedDays,
  ),
  'req_shift_id': const FalseOrStringConverter().toJson(instance.reqShiftId),
  'req_shift_name': const FalseOrStringConverter().toJson(
    instance.reqShiftName,
  ),
  'leave_type_id': const FalseOrStringConverter().toJson(instance.leaveTypeId),
  'leave_type_name': const FalseOrStringConverter().toJson(
    instance.leaveTypeName,
  ),
  'leave_date_from': const FalseOrStringConverter().toJson(
    instance.leaveDateFrom,
  ),
  'leave_date_to': const FalseOrStringConverter().toJson(instance.leaveDateTo),
  'leave_number_of_days': const FalseOrStringConverter().toJson(
    instance.leaveNumberOfDays,
  ),
  'leave_description': const FalseOrStringConverter().toJson(
    instance.leaveDescription,
  ),
  'leave_require_exit_entry_visa': instance.leaveRequireExitEntryVisa,
  'leave_visa_type': const FalseOrStringConverter().toJson(
    instance.leaveVisaType,
  ),
  'leave_visa_period': const FalseOrStringConverter().toJson(
    instance.leaveVisaPeriod,
  ),
  'leave_visa_needed_before': const FalseOrStringConverter().toJson(
    instance.leaveVisaNeededBefore,
  ),
  'leave_require_advance_salary': instance.leaveRequireAdvanceSalary,
  'leave_bereavement_type': instance.leaveBereavementType,
  'leave_can_cancel': instance.leaveCanCancel,
  'leave_can_approve': instance.leaveCanApprove,
  'clr_last_working_day': const FalseOrStringConverter().toJson(
    instance.clrLastWorkingDay,
  ),
  'clr_resignation_reason': const FalseOrStringConverter().toJson(
    instance.clrResignationReason,
  ),
  'clr_resignation_reason_detail': const FalseOrStringConverter().toJson(
    instance.clrResignationReasonDetail,
  ),
  'clr_total_salary': instance.clrTotalSalary,
  'clr_leave_balance_days': instance.clrLeaveBalanceDays,
  'clr_leave_balance_amount': instance.clrLeaveBalanceAmount,
  'clr_loan_settlement': instance.clrLoanSettlement,
  'clr_eos_gratuity': instance.clrEosGratuity,
  'clr_total_additions': instance.clrTotalAdditions,
  'clr_total_deductions': instance.clrTotalDeductions,
  'clr_net_amount': instance.clrNetAmount,
  'clr_service_years': instance.clrServiceYears,
  'clr_service_months': instance.clrServiceMonths,
  'clr_service_days': instance.clrServiceDays,
  'clr_physical_custody_cleared': instance.clrPhysicalCustodyCleared,
  'attachments': instance.attachments,
  'approval_chain': instance.approvalChain,
};

ApprovalChainItem _$ApprovalChainItemFromJson(Map<String, dynamic> json) =>
    ApprovalChainItem(
      approvalNames: (json['approval_names'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      approvalStatus: json['approval_status'] as String?,
    );

Map<String, dynamic> _$ApprovalChainItemToJson(ApprovalChainItem instance) =>
    <String, dynamic>{
      'approval_names': instance.approvalNames,
      'approval_status': instance.approvalStatus,
    };

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  mimetype: json['mimetype'] as String?,
  url: json['url'] as String?,
);

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimetype': instance.mimetype,
      'url': instance.url,
    };
