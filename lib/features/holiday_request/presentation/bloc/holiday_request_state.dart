part of 'holiday_request_cubit.dart';

enum HolidayRequestStatus { initial, loading, success, error, submitting, submitted, submitError }

class HolidayRequestState extends Equatable {
  const HolidayRequestState({
    this.status = HolidayRequestStatus.initial,
    this.errorMessage,
    this.leaveTypesResponseModel,
    this.holidayRequestResponseModel,
    this.selectedLeaveTypeName,
    this.selectedLeaveTypeId,
    this.startDate,
    this.endDate,
    this.advanceSalary = false,
    this.airTicket = false,
    this.visaTypeName,
    this.visaTypeId,
    this.visaPeriod,
    this.visaDate,
    this.description,
  });

  final HolidayRequestStatus status;
  final String? errorMessage;
  final AlleaveTypesResponseModel? leaveTypesResponseModel;
  final HolidayRequestResponseModel? holidayRequestResponseModel;
  final String? selectedLeaveTypeName;
  final int? selectedLeaveTypeId;
  final String? startDate;
  final String? endDate;
  final bool advanceSalary;
  final bool airTicket;
  final String? visaTypeName;
  final String? visaTypeId;
  final String? visaPeriod;
  final String? visaDate;
  final String? description;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    leaveTypesResponseModel,
    holidayRequestResponseModel,
    selectedLeaveTypeName,
    selectedLeaveTypeId,
    startDate,
    endDate,
    advanceSalary,
    airTicket,
    visaTypeName,
    visaTypeId,
    visaPeriod,
    visaDate,
    description,
  ];

  HolidayRequestState copyWith({
    HolidayRequestStatus? status,
    String? errorMessage,
    AlleaveTypesResponseModel? leaveTypesResponseModel,
    HolidayRequestResponseModel? holidayRequestResponseModel,
    String? selectedLeaveTypeName,
    int? selectedLeaveTypeId,
    String? startDate,
    String? endDate,
    bool? advanceSalary,
    bool? airTicket,
    Object? visaTypeName = _undefined,
    Object? visaTypeId = _undefined,
    Object? visaPeriod = _undefined,
    Object? visaDate = _undefined,
    Object? description = _undefined,
  }) {
    return HolidayRequestState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      leaveTypesResponseModel: leaveTypesResponseModel ?? this.leaveTypesResponseModel,
      holidayRequestResponseModel: holidayRequestResponseModel ?? this.holidayRequestResponseModel,
      selectedLeaveTypeName: selectedLeaveTypeName ?? this.selectedLeaveTypeName,
      selectedLeaveTypeId: selectedLeaveTypeId ?? this.selectedLeaveTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      advanceSalary: advanceSalary ?? this.advanceSalary,
      airTicket: airTicket ?? this.airTicket,
      visaTypeName: visaTypeName == _undefined ? this.visaTypeName : visaTypeName as String?,
      visaTypeId: visaTypeId == _undefined ? this.visaTypeId : visaTypeId as String?,
      visaPeriod: visaPeriod == _undefined ? this.visaPeriod : visaPeriod as String?,
      visaDate: visaDate == _undefined ? this.visaDate : visaDate as String?,
      description: description == _undefined ? this.description : description as String?,
    );
  }
}

// Sentinel value for copyWith to distinguish between "not provided" and "set to null"
const _undefined = Object();
