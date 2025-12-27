part of 'attendance_cubit.dart';

enum AttendanceStatus { initial, loading, success, error }

class AttendanceState extends Equatable {
  AttendanceState({
    this.status = AttendanceStatus.initial,
    this.attendanceSummaryResponse,
    this.error,
    DateTime? selectedDay,
    DateTime? focusedDay,
  }) : selectedDay = selectedDay ?? DateTime.now(),
       focusedDay = focusedDay ?? DateTime.now();

  final AttendanceStatus status;
  final AttendanceSummary? attendanceSummaryResponse;
  final String? error;
  final DateTime selectedDay;
  final DateTime focusedDay;

  /// Get attendance data for the focused month
  List<Datum> get attendanceData => attendanceSummaryResponse?.result?.data ?? [];

  /// Check if a specific date has incomplete attendance
  bool hasIncompleteAttendance(DateTime date) {
    return attendanceData.any(
      (datum) =>
          datum.date != null &&
          datum.date!.year == date.year &&
          datum.date!.month == date.month &&
          datum.date!.day == date.day &&
          (datum.incompAttend ?? false),
    );
  }

  /// Check if a specific date is an off day (weekend)
  bool isOffDay(DateTime date) {
    return attendanceData.any(
      (datum) =>
          datum.date != null &&
          datum.date!.year == date.year &&
          datum.date!.month == date.month &&
          datum.date!.day == date.day &&
          (datum.offDay ?? false),
    );
  }

  /// Check if a specific date is a public holiday
  bool isPublicOff(DateTime date) {
    return attendanceData.any(
      (datum) =>
          datum.date != null &&
          datum.date!.year == date.year &&
          datum.date!.month == date.month &&
          datum.date!.day == date.day &&
          (datum.publicOff ?? false),
    );
  }

  /// Check if a specific date is a leave day
  bool isLeaveDay(DateTime date) {
    return attendanceData.any(
      (datum) =>
          datum.date != null &&
          datum.date!.year == date.year &&
          datum.date!.month == date.month &&
          datum.date!.day == date.day &&
          (datum.leave ?? false),
    );
  }

  /// Get the Datum for a specific date
  Datum? getDatumForDate(DateTime date) {
    final matchingData = attendanceData.where(
      (datum) =>
          datum.date != null && datum.date!.year == date.year && datum.date!.month == date.month && datum.date!.day == date.day,
    );
    return matchingData.isEmpty ? null : matchingData.first;
  }

  AttendanceState copyWith({
    AttendanceStatus? status,
    AttendanceSummary? attendanceSummaryResponse,
    String? error,
    DateTime? selectedDay,
    DateTime? focusedDay,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      attendanceSummaryResponse: attendanceSummaryResponse ?? this.attendanceSummaryResponse,
      error: error ?? this.error,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
    );
  }

  @override
  List<Object?> get props => [status, attendanceSummaryResponse, error, selectedDay, focusedDay];
}
