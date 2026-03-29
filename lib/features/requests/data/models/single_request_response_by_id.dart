import 'package:json_annotation/json_annotation.dart';

part 'single_request_response_by_id.g.dart';

/// Custom JSON converter to handle fields that can be either false or string.
/// When the API returns false or null, we treat it as null.
/// When the API returns any other value, we convert it to a String.
class FalseOrStringConverter implements JsonConverter<String?, dynamic> {
  const FalseOrStringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == false || json == null) {
      return null;
    }
    return json.toString();
  }

  @override
  dynamic toJson(String? object) {
    return object ?? false;
  }
}

@JsonSerializable(createFactory: false)
class SingleRequestResponseById {
  SingleRequestResponseById({
    this.jsonrpc,
    this.id,
    this.result,
  });

  factory SingleRequestResponseById.fromJson(Map<String, dynamic> json) {
    final rawResult = json['result'];
    return SingleRequestResponseById(
      jsonrpc: json['jsonrpc'] as String?,
      id: json['id'],
      result: rawResult is Map<String, dynamic> ? SingleRequestResult.fromJson(rawResult) : null,
    );
  }
  @JsonKey(name: "jsonrpc")
  String? jsonrpc;
  @JsonKey(name: "id")
  dynamic id;
  @JsonKey(name: "result")
  SingleRequestResult? result;

  Map<String, dynamic> toJson() => _$SingleRequestResponseByIdToJson(this);
}

@JsonSerializable(createFactory: false)
class SingleRequestResult {
  SingleRequestResult({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory SingleRequestResult.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return SingleRequestResult(
      success: json['success'] as bool?,
      statusCode: (json['status_code'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: rawData is Map<String, dynamic> ? Data.fromJson(rawData) : null,
    );
  }

  @JsonKey(name: "success")
  bool? success;
  @JsonKey(name: "status_code")
  int? statusCode;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Data? data;

  Map<String, dynamic> toJson() => _$SingleRequestResultToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.recordType,
    this.id,
    this.name,
    this.employeeId,
    this.employeeName,
    this.state,
    this.stateDisplay,
    this.createDate,
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
    this.attachments,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  @JsonKey(name: "record_type")
  String? recordType;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "employee_id")
  int? employeeId;
  @JsonKey(name: "employee_name")
  String? employeeName;
  @JsonKey(name: "state")
  String? state;
  @JsonKey(name: "state_display")
  String? stateDisplay;
  @JsonKey(name: "create_date")
  DateTime? createDate;
  @FalseOrStringConverter()
  @JsonKey(name: "req_request_type")
  String? reqRequestType;
  @FalseOrStringConverter()
  @JsonKey(name: "req_request_type_display")
  String? reqRequestTypeDisplay;
  @FalseOrStringConverter()
  @JsonKey(name: "req_date")
  String? reqDate;
  @FalseOrStringConverter()
  @JsonKey(name: "req_time_from")
  String? reqTimeFrom;
  @FalseOrStringConverter()
  @JsonKey(name: "req_time_to")
  String? reqTimeTo;
  @FalseOrStringConverter()
  @JsonKey(name: "req_reason")
  String? reqReason;
  @FalseOrStringConverter()
  @JsonKey(name: "req_requested_duration")
  String? reqRequestedDuration;
  @JsonKey(name: "req_partial_excuse")
  bool? reqPartialExcuse;
  @FalseOrStringConverter()
  @JsonKey(name: "req_manager_id")
  String? reqManagerId;
  @FalseOrStringConverter()
  @JsonKey(name: "req_manager_name")
  String? reqManagerName;
  @FalseOrStringConverter()
  @JsonKey(name: "req_correction_type")
  String? reqCorrectionType;
  @FalseOrStringConverter()
  @JsonKey(name: "req_fix_attendance_method")
  String? reqFixAttendanceMethod;
  @FalseOrStringConverter()
  @JsonKey(name: "req_correction_time")
  String? reqCorrectionTime;
  @JsonKey(name: "req_attendance_log_id")
  bool? reqAttendanceLogId;
  @FalseOrStringConverter()
  @JsonKey(name: "req_work_mission_type")
  String? reqWorkMissionType;
  @FalseOrStringConverter()
  @JsonKey(name: "req_mission_start_date")
  String? reqMissionStartDate;
  @FalseOrStringConverter()
  @JsonKey(name: "req_mission_end_date")
  String? reqMissionEndDate;
  @FalseOrStringConverter()
  @JsonKey(name: "req_requested_days")
  String? reqRequestedDays;
  @FalseOrStringConverter()
  @JsonKey(name: "req_shift_id")
  String? reqShiftId;
  @FalseOrStringConverter()
  @JsonKey(name: "req_shift_name")
  String? reqShiftName;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_type_id")
  String? leaveTypeId;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_type_name")
  String? leaveTypeName;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_date_from")
  String? leaveDateFrom;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_date_to")
  String? leaveDateTo;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_number_of_days")
  String? leaveNumberOfDays;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_description")
  String? leaveDescription;
  @JsonKey(name: "leave_require_exit_entry_visa")
  bool? leaveRequireExitEntryVisa;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_visa_type")
  String? leaveVisaType;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_visa_period")
  String? leaveVisaPeriod;
  @FalseOrStringConverter()
  @JsonKey(name: "leave_visa_needed_before")
  String? leaveVisaNeededBefore;
  @JsonKey(name: "leave_require_advance_salary")
  bool? leaveRequireAdvanceSalary;
  @JsonKey(name: "leave_bereavement_type")
  bool? leaveBereavementType;
  @JsonKey(name: "leave_can_cancel")
  bool? leaveCanCancel;
  @JsonKey(name: "leave_can_approve")
  bool? leaveCanApprove;
  @JsonKey(name: "attachments")
  List<Attachment>? attachments;

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Attachment {
  Attachment({
    this.id,
    this.name,
    this.mimetype,
    this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => _$AttachmentFromJson(json);
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "mimetype")
  String? mimetype;
  @JsonKey(name: "url")
  String? url;

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
