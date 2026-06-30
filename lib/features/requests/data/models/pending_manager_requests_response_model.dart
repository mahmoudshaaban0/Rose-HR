import 'package:json_annotation/json_annotation.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';

part 'pending_manager_requests_response_model.g.dart';

@JsonSerializable(createFactory: false)
class PendingManagerRequestsResponseModel {
  PendingManagerRequestsResponseModel({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory PendingManagerRequestsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return PendingManagerRequestsResponseModel(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? PendingRequestsResult.fromJson(rawResult) : null,
    );
  }

  @JsonKey(name: 'jsonrpc')
  String? jsonrpc;

  @JsonKey(name: 'id')
  dynamic id;

  @JsonKey(name: 'result')
  PendingRequestsResult? result;

  Map<String, dynamic> toJson() => _$PendingManagerRequestsResponseModelToJson(this);
}

@JsonSerializable(createFactory: false)
class PendingRequestsResult {
  PendingRequestsResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory PendingRequestsResult.fromJson(Map<String, dynamic> json) {
    final dataField = json['data'];
    PendingRequestsData? parsedData;

    if (dataField is Map<String, dynamic>) {
      parsedData = PendingRequestsData.fromJson(dataField);
    } else if (dataField is List) {
      parsedData = PendingRequestsData(userRoles: [], requests: []);
    }

    return PendingRequestsResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: parsedData,
    );
  }

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'status_code')
  int? statusCode;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'data')
  PendingRequestsData? data;

  Map<String, dynamic> toJson() => _$PendingRequestsResultToJson(this);
}

@JsonSerializable()
class PendingRequestsData {
  PendingRequestsData({
    this.userRoles,
    this.requests,
  });

  factory PendingRequestsData.fromJson(Map<String, dynamic> json) => _$PendingRequestsDataFromJson(json);

  @JsonKey(name: 'user_roles')
  List<String>? userRoles;

  @JsonKey(name: 'requests')
  List<PendingRequestItem>? requests;

  Map<String, dynamic> toJson() => _$PendingRequestsDataToJson(this);
}

@JsonSerializable()
class PendingRequestItem {
  PendingRequestItem({
    this.recordType,
    this.id,
    this.name,
    this.employeeId,
    this.employeeName,
    this.state,
    this.stateDisplay,
    this.createDate,
    this.canCancel,
    this.pendingUsersNames,
    this.approvalChain,
    this.reqRequestType,
    this.reqRequestTypeDisplay,
    this.reqDate,
    this.reqTimeFrom,
    this.reqTimeTo,
    this.reqReason,
    this.reqRequestedDuration,
    this.reqPartialExcuse,
    this.reqManagerId,
    this.reqManagerName,
    this.reqCorrectionType,
    this.reqFixAttendanceMethod,
    this.reqCorrectionTime,
    this.reqAttendanceLogId,
    this.reqWorkMissionType,
    this.reqMissionStartDate,
    this.reqMissionEndDate,
    this.reqRequestedDays,
    this.reqShiftId,
    this.reqShiftName,
    this.leaveTypeId,
    this.leaveTypeName,
    this.leaveDateFrom,
    this.leaveDateTo,
    this.leaveNumberOfDays,
    this.leaveDescription,
    this.leaveRequireExitEntryVisa,
    this.leaveVisaType,
    this.leaveVisaPeriod,
    this.leaveVisaNeededBefore,
    this.leaveRequireAdvanceSalary,
    this.leaveBereavementType,
    this.leaveCanCancel,
    this.leaveCanApprove,
    this.canApprove,
    this.canReject,
    this.pendingOn,
  });

  factory PendingRequestItem.fromJson(Map<String, dynamic> json) => _$PendingRequestItemFromJson(json);

  @JsonKey(name: 'record_type')
  String? recordType;

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'employee_id')
  int? employeeId;

  @JsonKey(name: 'employee_name')
  String? employeeName;

  @JsonKey(name: 'state')
  String? state;

  @JsonKey(name: 'state_display')
  String? stateDisplay;

  @JsonKey(name: 'create_date')
  String? createDate;

  @JsonKey(name: 'can_cancel')
  bool? canCancel;

  @JsonKey(name: 'pending_users_names')
  List<String>? pendingUsersNames;

  @JsonKey(name: 'approval_chain')
  List<ApprovalChainItem>? approvalChain;

  @JsonKey(name: 'req_request_type')
  dynamic reqRequestType;

  @JsonKey(name: 'req_request_type_display')
  dynamic reqRequestTypeDisplay;

  @JsonKey(name: 'req_date')
  dynamic reqDate;

  @JsonKey(name: 'req_time_from')
  dynamic reqTimeFrom;

  @JsonKey(name: 'req_time_to')
  dynamic reqTimeTo;

  @JsonKey(name: 'req_reason')
  dynamic reqReason;

  @JsonKey(name: 'req_requested_duration')
  dynamic reqRequestedDuration;

  @JsonKey(name: 'req_partial_excuse')
  dynamic reqPartialExcuse;

  @JsonKey(name: 'req_manager_id')
  dynamic reqManagerId;

  @JsonKey(name: 'req_manager_name')
  dynamic reqManagerName;

  @JsonKey(name: 'req_correction_type')
  dynamic reqCorrectionType;

  @JsonKey(name: 'req_fix_attendance_method')
  dynamic reqFixAttendanceMethod;

  @JsonKey(name: 'req_correction_time')
  dynamic reqCorrectionTime;

  @JsonKey(name: 'req_attendance_log_id')
  dynamic reqAttendanceLogId;

  @JsonKey(name: 'req_work_mission_type')
  dynamic reqWorkMissionType;

  @JsonKey(name: 'req_mission_start_date')
  dynamic reqMissionStartDate;

  @JsonKey(name: 'req_mission_end_date')
  dynamic reqMissionEndDate;

  @JsonKey(name: 'req_requested_days')
  dynamic reqRequestedDays;

  @JsonKey(name: 'req_shift_id')
  dynamic reqShiftId;

  @JsonKey(name: 'req_shift_name')
  dynamic reqShiftName;

  @JsonKey(name: 'leave_type_id')
  dynamic leaveTypeId;

  @JsonKey(name: 'leave_type_name')
  dynamic leaveTypeName;

  @JsonKey(name: 'leave_date_from')
  dynamic leaveDateFrom;

  @JsonKey(name: 'leave_date_to')
  dynamic leaveDateTo;

  @JsonKey(name: 'leave_number_of_days')
  dynamic leaveNumberOfDays;

  @JsonKey(name: 'leave_description')
  dynamic leaveDescription;

  @JsonKey(name: 'leave_require_exit_entry_visa')
  dynamic leaveRequireExitEntryVisa;

  @JsonKey(name: 'leave_visa_type')
  dynamic leaveVisaType;

  @JsonKey(name: 'leave_visa_period')
  dynamic leaveVisaPeriod;

  @JsonKey(name: 'leave_visa_needed_before')
  dynamic leaveVisaNeededBefore;

  @JsonKey(name: 'leave_require_advance_salary')
  dynamic leaveRequireAdvanceSalary;

  @JsonKey(name: 'leave_bereavement_type')
  dynamic leaveBereavementType;

  @JsonKey(name: 'leave_can_cancel')
  dynamic leaveCanCancel;

  @JsonKey(name: 'leave_can_approve')
  dynamic leaveCanApprove;

  @JsonKey(name: 'can_approve')
  bool? canApprove;

  @JsonKey(name: 'can_reject')
  bool? canReject;

  @JsonKey(name: 'pending_on')
  String? pendingOn;

  Map<String, dynamic> toJson() => _$PendingRequestItemToJson(this);
}
