part of 'punch_correction_cubit.dart';

enum PunchCorrectionStatus { initial, loading, success, error }

enum AttendanceLogsStatus { initial, loading, success, error }

class PunchCorrectionState extends Equatable {
  const PunchCorrectionState({
    this.status = PunchCorrectionStatus.initial,
    this.errorMessage,
    this.date,
    this.shiftId,
    this.reasonId,
    this.correctionType,
    this.attendanceMethod,
    this.startTime,
    this.endTime,
    this.attendanceLogId,
    this.punchCorrectionResponseModel,
    this.attendanceLogsStatus = AttendanceLogsStatus.initial,
    this.attendanceLogs,
    this.selectedLogTime,
  });
  final PunchCorrectionStatus status;
  final String? errorMessage;
  final String? date;
  final int? shiftId;
  final String? reasonId;
  final String? correctionType;
  final String? attendanceMethod;
  final double? startTime;
  final double? endTime;
  final int? attendanceLogId;
  final PunchCorrectionResponseModel? punchCorrectionResponseModel;
  final AttendanceLogsStatus attendanceLogsStatus;
  final AttendanceLogsResponseModel? attendanceLogs;
  final double? selectedLogTime;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    date,
    shiftId,
    reasonId,
    correctionType,
    attendanceMethod,
    startTime,
    endTime,
    attendanceLogId,
    punchCorrectionResponseModel,
    attendanceLogsStatus,
    attendanceLogs,
    selectedLogTime,
  ];

  PunchCorrectionState copyWith({
    PunchCorrectionStatus? status,
    String? errorMessage,
    String? date,
    int? shiftId,
    String? reasonId,
    String? attendanceMethod,
    String? correctionType,
    double? startTime,
    double? endTime,
    int? attendanceLogId,
    PunchCorrectionResponseModel? punchCorrectionResponseModel,
    AttendanceLogsStatus? attendanceLogsStatus,
    AttendanceLogsResponseModel? attendanceLogs,
    double? selectedLogTime,
  }) {
    return PunchCorrectionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      date: date ?? this.date,
      shiftId: shiftId ?? this.shiftId,
      reasonId: reasonId ?? this.reasonId,
      correctionType: correctionType ?? this.correctionType,
      attendanceMethod: attendanceMethod ?? this.attendanceMethod,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      attendanceLogId: attendanceLogId ?? this.attendanceLogId,
      punchCorrectionResponseModel: punchCorrectionResponseModel ?? this.punchCorrectionResponseModel,
      attendanceLogsStatus: attendanceLogsStatus ?? this.attendanceLogsStatus,
      attendanceLogs: attendanceLogs ?? this.attendanceLogs,
      selectedLogTime: selectedLogTime ?? this.selectedLogTime,
    );
  }
}
