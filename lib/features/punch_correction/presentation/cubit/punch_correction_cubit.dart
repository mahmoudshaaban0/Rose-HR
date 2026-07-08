import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_logs_response_model.dart';
import 'package:rose_hr/features/attendance/data/repositories/attendance_repository.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/punch_correction/data/models/correction_type_enum.dart';
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

  bool get _isCheckInSelected =>
      state.correctionType == CorrectionType.checkIn.id ||
      state.correctionType == CorrectionType.both.id;

  bool get _isCheckOutSelected =>
      state.correctionType == CorrectionType.checkOut.id ||
      state.correctionType == CorrectionType.both.id;

  /// Toggle the check-in slot. Combines with the check-out slot to form
  /// 'in', 'both' or (when both cleared) null.
  void toggleCheckIn(bool checked) {
    if (isClosed) return;
    final outSelected = _isCheckOutSelected;
    if (checked) {
      emit(
        state.copyWith(
          correctionType:
              outSelected ? CorrectionType.both.id : CorrectionType.checkIn.id,
        ),
      );
    } else {
      // Clear the check-in slot (time + log) while keeping the check-out slot.
      emit(
        PunchCorrectionState(
          status: state.status,
          errorMessage: state.errorMessage,
          date: state.date,
          shiftId: state.shiftId,
          reasonId: state.reasonId,
          correctionType: outSelected ? CorrectionType.checkOut.id : null,
          attendanceMethod: state.attendanceMethod,
          endTime: state.endTime,
          attendanceLogOutId: state.attendanceLogOutId,
          punchCorrectionResponseModel: state.punchCorrectionResponseModel,
          attendanceLogsStatus: state.attendanceLogsStatus,
          attendanceLogs: state.attendanceLogs,
        ),
      );
    }
  }

  /// Toggle the check-out slot. Combines with the check-in slot to form
  /// 'out', 'both' or (when both cleared) null.
  void toggleCheckOut(bool checked) {
    if (isClosed) return;
    final inSelected = _isCheckInSelected;
    if (checked) {
      emit(
        state.copyWith(
          correctionType:
              inSelected ? CorrectionType.both.id : CorrectionType.checkOut.id,
        ),
      );
    } else {
      // Clear the check-out slot (time + log) while keeping the check-in slot.
      emit(
        PunchCorrectionState(
          status: state.status,
          errorMessage: state.errorMessage,
          date: state.date,
          shiftId: state.shiftId,
          reasonId: state.reasonId,
          correctionType: inSelected ? CorrectionType.checkIn.id : null,
          attendanceMethod: state.attendanceMethod,
          startTime: state.startTime,
          attendanceLogId: state.attendanceLogId,
          punchCorrectionResponseModel: state.punchCorrectionResponseModel,
          attendanceLogsStatus: state.attendanceLogsStatus,
          attendanceLogs: state.attendanceLogs,
        ),
      );
    }
  }

  /// Set which slot ('in' or 'out') the correction-time screen edits next.
  void setEditingType(String editingType) {
    if (isClosed) return;
    emit(state.copyWith(editingType: editingType));
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
    // Store the picked log in the slot currently being edited.
    if (state.editingType == CorrectionType.checkOut.id) {
      emit(
        state.copyWith(
          selectedLogTime: logTime,
          attendanceLogOutId: logId,
          endTime: logTime,
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedLogTime: logTime,
          attendanceLogId: logId,
          startTime: logTime,
        ),
      );
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
    final correctionType = state.correctionType!;
    final isBoth = correctionType == CorrectionType.both.id;
    final isCheckIn = correctionType == CorrectionType.checkIn.id;

    if (state.attendanceMethod == 'manual') {
      // For 'both', correction_time carries the check-in time and
      // correction_time_out the check-out time. For a single type, the one
      // relevant time is sent as correction_time.
      final inTime = state.startTime;
      final outTime = state.endTime;
      final correctionTime = isBoth || isCheckIn ? inTime : outTime;
      final correctionTimeOut = isBoth ? outTime : null;

      if (correctionTime == null || (isBoth && correctionTimeOut == null)) {
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
        correctionType: correctionType,
        correctionTime: correctionTime,
        correctionTimeOut: correctionTimeOut,
        reason: reason,
        attachmentIds: attachmentIds,
      );
    } else {
      // For 'both', attendance_log_id carries the check-in log and
      // attendance_log_out_id the check-out log. For a single type, the one
      // relevant log is sent as attendance_log_id.
      final inLog = state.attendanceLogId;
      final outLog = state.attendanceLogOutId;
      final attendanceLogId = isBoth || isCheckIn ? inLog : outLog;
      final attendanceLogOutId = isBoth ? outLog : null;

      if (attendanceLogId == null || (isBoth && attendanceLogOutId == null)) {
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
        correctionType: correctionType,
        attendanceLogId: attendanceLogId,
        attendanceLogOutId: attendanceLogOutId,
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
