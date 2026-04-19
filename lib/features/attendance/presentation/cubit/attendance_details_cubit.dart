import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_logs_response_model.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_summary_details_response_model.dart';
import 'package:rose_hr/features/attendance/data/repositories/attendance_repository.dart';

part 'attendance_details_state.dart';

class AttendanceDetailsCubit extends Cubit<AttendanceDetailsState> {
  AttendanceDetailsCubit(this.attendanceRepository) : super(const AttendanceDetailsState());
  final AttendanceRepository attendanceRepository;

  Future<void> getAttendanceSummaryByDate(String date) async {
    emit(state.copyWith(status: AttendanceDetailsStatus.loading));
    final result = await attendanceRepository.getAttendanceSummaryByDate(date);
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: AttendanceDetailsStatus.success, attendanceSummaryDetailsResponse: data));
      case Error(:final failure):
        emit(state.copyWith(status: AttendanceDetailsStatus.error, error: failure.message));
    }
  }

  Future<void> getAttendanceLogs(String date) async {
    emit(state.copyWith(attendanceLogsStatus: AttendanceLogsStatus.loading));
    final result = await attendanceRepository.getAttendanceLogs(date);
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(attendanceLogsStatus: AttendanceLogsStatus.success, attendanceLogsResponse: data));
      case Error(:final failure):
        emit(state.copyWith(attendanceLogsStatus: AttendanceLogsStatus.error, logsError: failure.message));
    }
  }
}
