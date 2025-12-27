import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_summary_response_model.dart';
import 'package:rose_hr/features/attendance/data/repositories/attendance_repository.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this.attendanceRepository) : super(AttendanceState());
  final AttendanceRepository attendanceRepository;

  /// Initialize with current month data
  void init() {
    final now = DateTime.now();
    getAttendanceSummary(now.month, now.year);
  }

  /// Refresh current month data (for pull-to-refresh)
  Future<void> refresh() async {
    final now = DateTime.now();
    await getAttendanceSummary(now.month, now.year);
  }

  Future<void> getAttendanceSummary(int month, int year) async {
    emit(state.copyWith(status: AttendanceStatus.loading));
    final result = await attendanceRepository.getAttendanceSummary(month, year);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: AttendanceStatus.success, attendanceSummaryResponse: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: AttendanceStatus.error, error: failure.message));
    }
  }

  /// Called when user navigates to a different month
  void onMonthChanged(DateTime focusedDay) {
    emit(state.copyWith(focusedDay: focusedDay));
    getAttendanceSummary(focusedDay.month, focusedDay.year);
  }

  /// Called when user selects a specific day
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    emit(state.copyWith(selectedDay: selectedDay, focusedDay: focusedDay));
  }
}
