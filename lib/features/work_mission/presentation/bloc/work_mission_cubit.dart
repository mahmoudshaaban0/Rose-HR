import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_request_model.dart';
import 'package:rose_hr/features/work_mission/data/repositories/work_mission_repository.dart';

part 'work_mission_state.dart';

class WorkMissionCubit extends Cubit<WorkMissionState> {
  WorkMissionCubit(this.workMissionRepository) : super(const WorkMissionState());

  final WorkMissionRepository workMissionRepository;

  void selectWorkMissionType(String workMissionTypeId) {
    if (isClosed) return;
    emit(state.copyWith(workMissionTypeId: workMissionTypeId));
  }

  void selectStartDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(startDate: date.toIso8601String()));
  }

  void selectEndDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(endDate: date.toIso8601String()));
  }

  void selectStartTime(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(startDate: date.toIso8601String()));
  }

  void selectEndTime(DateTime date) {
    if (isClosed) return;

    var endTime = date;

    // If a start time exists and the chosen end time is not after it (overnight span),
    // advance the end date by one day so the DateTime comparison works correctly.
    if (state.startDate != null) {
      final startDT = DateTime.parse(state.startDate!);
      final endOnSameDay = DateTime(
        startDT.year,
        startDT.month,
        startDT.day,
        date.hour,
        date.minute,
        date.second,
      );
      if (!endOnSameDay.isAfter(startDT)) {
        endTime = endOnSameDay.add(const Duration(days: 1));
      } else {
        endTime = endOnSameDay;
      }
    }

    emit(state.copyWith(endDate: endTime.toIso8601String()));
  }

  void selectShiftId(int shiftId) {
    if (isClosed) return;
    emit(state.copyWith(shiftId: shiftId));
  }

  void selectDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(date: date.toIso8601String()));
  }

  /// Creates a work mission request
  Future<void> createWorkMission(WorkMissionRequestModel request) async {
    if (isClosed) return;
    emit(state.copyWith(status: WorkMissionStatus.loading));

    final result = await workMissionRepository.createWorkMission(request);

    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: WorkMissionStatus.success,
            workMissionResponseModel: data,
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: WorkMissionStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Clears all fields to reset the form
  void clearAllFields() {
    if (isClosed) return;
    emit(const WorkMissionState());
  }
}
