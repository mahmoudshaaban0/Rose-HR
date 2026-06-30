// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_manager_requests_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$PendingManagerRequestsResponseModelToJson(
  PendingManagerRequestsResponseModel instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': instance.result,
};

Map<String, dynamic> _$PendingRequestsResultToJson(
  PendingRequestsResult instance,
) => <String, dynamic>{
  'success': instance.success,
  'status_code': instance.statusCode,
  'message': instance.message,
  'data': instance.data,
};

PendingRequestsData _$PendingRequestsDataFromJson(Map<String, dynamic> json) =>
    PendingRequestsData(
      userRoles: (json['user_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      requests: (json['requests'] as List<dynamic>?)
          ?.map((e) => PendingRequestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PendingRequestsDataToJson(
  PendingRequestsData instance,
) => <String, dynamic>{
  'user_roles': instance.userRoles,
  'requests': instance.requests,
};

PendingRequestItem _$PendingRequestItemFromJson(Map<String, dynamic> json) =>
    PendingRequestItem(
      recordType: json['record_type'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      employeeId: (json['employee_id'] as num?)?.toInt(),
      employeeName: json['employee_name'] as String?,
      state: json['state'] as String?,
      stateDisplay: json['state_display'] as String?,
      createDate: json['create_date'] as String?,
      canCancel: json['can_cancel'] as bool?,
      pendingUsersNames: (json['pending_users_names'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      approvalChain: (json['approval_chain'] as List<dynamic>?)
          ?.map((e) => ApprovalChainItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      reqRequestType: json['req_request_type'],
      reqRequestTypeDisplay: json['req_request_type_display'],
      reqDate: json['req_date'],
      reqTimeFrom: json['req_time_from'],
      reqTimeTo: json['req_time_to'],
      reqReason: json['req_reason'],
      reqRequestedDuration: json['req_requested_duration'],
      reqPartialExcuse: json['req_partial_excuse'],
      reqManagerId: json['req_manager_id'],
      reqManagerName: json['req_manager_name'],
      reqCorrectionType: json['req_correction_type'],
      reqFixAttendanceMethod: json['req_fix_attendance_method'],
      reqCorrectionTime: json['req_correction_time'],
      reqAttendanceLogId: json['req_attendance_log_id'],
      reqWorkMissionType: json['req_work_mission_type'],
      reqMissionStartDate: json['req_mission_start_date'],
      reqMissionEndDate: json['req_mission_end_date'],
      reqRequestedDays: json['req_requested_days'],
      reqShiftId: json['req_shift_id'],
      reqShiftName: json['req_shift_name'],
      leaveTypeId: json['leave_type_id'],
      leaveTypeName: json['leave_type_name'],
      leaveDateFrom: json['leave_date_from'],
      leaveDateTo: json['leave_date_to'],
      leaveNumberOfDays: json['leave_number_of_days'],
      leaveDescription: json['leave_description'],
      leaveRequireExitEntryVisa: json['leave_require_exit_entry_visa'],
      leaveVisaType: json['leave_visa_type'],
      leaveVisaPeriod: json['leave_visa_period'],
      leaveVisaNeededBefore: json['leave_visa_needed_before'],
      leaveRequireAdvanceSalary: json['leave_require_advance_salary'],
      leaveBereavementType: json['leave_bereavement_type'],
      leaveCanCancel: json['leave_can_cancel'],
      leaveCanApprove: json['leave_can_approve'],
      canApprove: json['can_approve'] as bool?,
      canReject: json['can_reject'] as bool?,
      pendingOn: json['pending_on'] as String?,
    );

Map<String, dynamic> _$PendingRequestItemToJson(PendingRequestItem instance) =>
    <String, dynamic>{
      'record_type': instance.recordType,
      'id': instance.id,
      'name': instance.name,
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'state': instance.state,
      'state_display': instance.stateDisplay,
      'create_date': instance.createDate,
      'can_cancel': instance.canCancel,
      'pending_users_names': instance.pendingUsersNames,
      'approval_chain': instance.approvalChain,
      'req_request_type': instance.reqRequestType,
      'req_request_type_display': instance.reqRequestTypeDisplay,
      'req_date': instance.reqDate,
      'req_time_from': instance.reqTimeFrom,
      'req_time_to': instance.reqTimeTo,
      'req_reason': instance.reqReason,
      'req_requested_duration': instance.reqRequestedDuration,
      'req_partial_excuse': instance.reqPartialExcuse,
      'req_manager_id': instance.reqManagerId,
      'req_manager_name': instance.reqManagerName,
      'req_correction_type': instance.reqCorrectionType,
      'req_fix_attendance_method': instance.reqFixAttendanceMethod,
      'req_correction_time': instance.reqCorrectionTime,
      'req_attendance_log_id': instance.reqAttendanceLogId,
      'req_work_mission_type': instance.reqWorkMissionType,
      'req_mission_start_date': instance.reqMissionStartDate,
      'req_mission_end_date': instance.reqMissionEndDate,
      'req_requested_days': instance.reqRequestedDays,
      'req_shift_id': instance.reqShiftId,
      'req_shift_name': instance.reqShiftName,
      'leave_type_id': instance.leaveTypeId,
      'leave_type_name': instance.leaveTypeName,
      'leave_date_from': instance.leaveDateFrom,
      'leave_date_to': instance.leaveDateTo,
      'leave_number_of_days': instance.leaveNumberOfDays,
      'leave_description': instance.leaveDescription,
      'leave_require_exit_entry_visa': instance.leaveRequireExitEntryVisa,
      'leave_visa_type': instance.leaveVisaType,
      'leave_visa_period': instance.leaveVisaPeriod,
      'leave_visa_needed_before': instance.leaveVisaNeededBefore,
      'leave_require_advance_salary': instance.leaveRequireAdvanceSalary,
      'leave_bereavement_type': instance.leaveBereavementType,
      'leave_can_cancel': instance.leaveCanCancel,
      'leave_can_approve': instance.leaveCanApprove,
      'can_approve': instance.canApprove,
      'can_reject': instance.canReject,
      'pending_on': instance.pendingOn,
    };
