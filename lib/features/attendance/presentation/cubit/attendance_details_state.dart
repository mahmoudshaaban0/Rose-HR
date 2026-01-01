part of 'attendance_details_cubit.dart';

enum AttendanceDetailsStatus { initial, loading, success, error }

class AttendanceDetailsState extends Equatable {
  const AttendanceDetailsState({
    this.status = AttendanceDetailsStatus.initial,
    this.attendanceSummaryDetailsResponse,
    this.error,
  });
  final AttendanceDetailsStatus status;
  final AttendanceSummaryDetailsResponseModel? attendanceSummaryDetailsResponse;
  final String? error;

  AttendanceDetailsState copyWith({
    AttendanceDetailsStatus? status,
    AttendanceSummaryDetailsResponseModel? attendanceSummaryDetailsResponse,
    String? error,
  }) {
    return AttendanceDetailsState(
      status: status ?? this.status,
      attendanceSummaryDetailsResponse: attendanceSummaryDetailsResponse ?? this.attendanceSummaryDetailsResponse,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, attendanceSummaryDetailsResponse, error];
}
