part of 'attendance_details_cubit.dart';

enum AttendanceDetailsStatus { initial, loading, success, error }
enum AttendanceLogsStatus { initial, loading, success, error }

class AttendanceDetailsState extends Equatable {
  const AttendanceDetailsState({
    this.status = AttendanceDetailsStatus.initial,
    this.attendanceSummaryDetailsResponse,
    this.error,
    this.attendanceLogsStatus = AttendanceLogsStatus.initial,
    this.attendanceLogsResponse,
    this.logsError,
  });
  final AttendanceDetailsStatus status;
  final AttendanceSummaryDetailsResponseModel? attendanceSummaryDetailsResponse;
  final String? error;
  
  final AttendanceLogsStatus attendanceLogsStatus;
  final AttendanceLogsResponseModel? attendanceLogsResponse;
  final String? logsError;

  AttendanceDetailsState copyWith({
    AttendanceDetailsStatus? status,
    AttendanceSummaryDetailsResponseModel? attendanceSummaryDetailsResponse,
    String? error,
    AttendanceLogsStatus? attendanceLogsStatus,
    AttendanceLogsResponseModel? attendanceLogsResponse,
    String? logsError,
  }) {
    return AttendanceDetailsState(
      status: status ?? this.status,
      attendanceSummaryDetailsResponse: attendanceSummaryDetailsResponse ?? this.attendanceSummaryDetailsResponse,
      error: error ?? this.error,
      attendanceLogsStatus: attendanceLogsStatus ?? this.attendanceLogsStatus,
      attendanceLogsResponse: attendanceLogsResponse ?? this.attendanceLogsResponse,
      logsError: logsError ?? this.logsError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        attendanceSummaryDetailsResponse,
        error,
        attendanceLogsStatus,
        attendanceLogsResponse,
        logsError,
      ];
}
