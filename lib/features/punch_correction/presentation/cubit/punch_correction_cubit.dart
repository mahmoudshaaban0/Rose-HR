import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_logs_response_model.dart';
import 'package:rose_hr/features/attendance/data/repositories/attendance_repository.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_request_model.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_response_model.dart';
import 'package:rose_hr/features/punch_correction/data/repositories/punch_correction_repository.dart';

part 'punch_correction_state.dart';

class PunchCorrectionCubit extends Cubit<PunchCorrectionState> {
  PunchCorrectionCubit(this.punchCorrectionRepository, this.attendanceRepository)
      : super(const PunchCorrectionState(attendanceMethod: 'manual'));
  final PunchCorrectionRepository punchCorrectionRepository;
  final AttendanceRepository attendanceRepository;

  void selectDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(date: date.toIso8601String()));
  }

  void selectShiftId(int shiftId) {
    if (isClosed) return;
    // When changing shift, reset correction times and correction type
    emit(
      PunchCorrectionState(
        status: state.status,
        errorMessage: state.errorMessage,
        date: state.date,
        shiftId: shiftId,
        reasonId: state.reasonId,
        attendanceMethod: state.attendanceMethod,
        attendanceLogId: state.attendanceLogId,
        punchCorrectionResponseModel: state.punchCorrectionResponseModel,
      ),
    );
  }

  void selectReasonId(String reasonId) {
    if (isClosed) return;
    emit(state.copyWith(reasonId: reasonId));
  }

  void selectCorrectionType(String correctionType) {
    if (isClosed) return;
    // When switching correction type, clear the times
    emit(
      PunchCorrectionState(
        status: state.status,
        errorMessage: state.errorMessage,
        date: state.date,
        shiftId: state.shiftId,
        reasonId: state.reasonId,
        correctionType: correctionType,
        attendanceMethod: state.attendanceMethod,
      ),
    );
  }

  void clearCorrectionType() {
    if (isClosed) return;
    emit(
      PunchCorrectionState(
        status: state.status,
        errorMessage: state.errorMessage,
        date: state.date,
        shiftId: state.shiftId,
        reasonId: state.reasonId,
        attendanceMethod: state.attendanceMethod,
      ),
    );
  }

  void selectAttendanceMethod(String attendanceMethod) {
    if (isClosed) return;
    emit(state.copyWith(attendanceMethod: attendanceMethod));
  }

  void selectStartTime(double startTime) {
    if (isClosed) return;
    emit(state.copyWith(startTime: startTime));
  }

  void selectEndTime(double endTime) {
    if (isClosed) return;
    emit(state.copyWith(endTime: endTime));
  }

  void selectAttendanceLogId(int attendanceLogId) {
    if (isClosed) return;
    emit(state.copyWith(attendanceLogId: attendanceLogId));
  }

  void selectLogTime(double logTime, int logId) {
    if (isClosed) return;
    emit(state.copyWith(selectedLogTime: logTime, attendanceLogId: logId));
    // Also set the start/end time based on correction type
    if (state.correctionType == 'in') {
      emit(state.copyWith(startTime: logTime));
    } else if (state.correctionType == 'out') {
      emit(state.copyWith(endTime: logTime));
    }
  }

  Future<void> fetchAttendanceLogs(String date) async {
    if (isClosed) return;
    emit(state.copyWith(attendanceLogsStatus: AttendanceLogsStatus.loading));

    final result = await attendanceRepository.getAttendanceLogs(date);

    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(
          state.copyWith(
            attendanceLogsStatus: AttendanceLogsStatus.success,
            attendanceLogs: data,
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            attendanceLogsStatus: AttendanceLogsStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> submitPunchCorrection({
    required String formattedDate,
    String? reason,
    List<AttachmentData>? attachmentIds,
  }) async {
    if (isClosed) return;
    // Validate required fields
    if (state.shiftId == null || state.correctionType == null || state.attendanceMethod == null) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: PunchCorrectionStatus.error,
          errorMessage: 'Please fill all required fields',
        ),
      );
      return;
    }

    // Create request based on attendance method
    final PunchCorrectionRequestModel request;

    if (state.attendanceMethod == 'manual') {
      // For manual method, correctionTime is required
      // Use startTime for 'in' correction, endTime for 'out' correction
      final correctionTime = state.correctionType == 'in' ? state.startTime : state.endTime;

      if (correctionTime == null) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PunchCorrectionStatus.error,
            errorMessage: 'Please select correction time',
          ),
        );
        return;
      }

      request = PunchCorrectionRequestModel.manual(
        date: formattedDate,
        shiftId: state.shiftId!,
        correctionType: state.correctionType!,
        correctionTime: correctionTime,
        reason: reason,
        attachmentIds: attachmentIds,
      );
    } else {
      // For attendance_log method, attendanceLogId is required
      if (state.attendanceLogId == null) {
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PunchCorrectionStatus.error,
            errorMessage: 'Please select attendance log',
          ),
        );
        return;
      }

      request = PunchCorrectionRequestModel.attendanceLog(
        date: formattedDate,
        shiftId: state.shiftId!,
        correctionType: state.correctionType!,
        attendanceLogId: state.attendanceLogId!,
        reason: reason,
        attachmentIds: attachmentIds,
      );
    }

    if (isClosed) return;
    emit(state.copyWith(status: PunchCorrectionStatus.loading));
    final result = await punchCorrectionRepository.createPunchCorrection(request);

    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PunchCorrectionStatus.success,
            punchCorrectionResponseModel: data,
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PunchCorrectionStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
