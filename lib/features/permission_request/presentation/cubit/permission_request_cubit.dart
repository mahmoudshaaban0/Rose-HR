import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_response_model.dart';
import 'package:rose_hr/features/permission_request/data/repositories/permission_request_repository.dart';

part 'permission_request_state.dart';

class PermissionRequestCubit extends Cubit<PermissionRequestState> {
  PermissionRequestCubit(this.permissionRequestRepository) : super(const PermissionRequestState());
  final PermissionRequestRepository permissionRequestRepository;

  Future<void> createPermissionRequest(PermissionRequestRequestModel request) async {
    if (isClosed) return;
    emit(state.copyWith(status: PermissionRequestStatus.loading));
    final result = await permissionRequestRepository.createPermissionRequest(request);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: PermissionRequestStatus.success, permissionRequestResponseModel: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: PermissionRequestStatus.error, errorMessage: failure.message));
    }
  }

  void sendPermsissionType(String permissionTypeName, String permissionTypeId) {
    // Reset startTime and endTime if the new permission type is not 'mid_day'
    if (permissionTypeId != 'mid_day') {
      if (isClosed) return;
      emit(
        state.copyWith(
          permissionTypeName: permissionTypeName,
          permissionTypeId: permissionTypeId,
          clearStartTime: true,
          clearEndTime: true,
        ),
      );
    } else {
      if (isClosed) return;
      emit(state.copyWith(permissionTypeName: permissionTypeName, permissionTypeId: permissionTypeId));
    }
  }

  void selectDate(DateTime date) {
    if (isClosed) return;
    emit(state.copyWith(date: date.toIso8601String()));
  }

  void selecteReasonType(String reasonTypeName, String reasonTypeId) {
    if (isClosed) return;
    emit(state.copyWith(reasonTypeName: reasonTypeName, reasonTypeId: reasonTypeId));
  }

  void selectStartTimeAndEndTime({String? startTime, String? endTime}) {
    if (isClosed) return;
    if (state.permissionTypeId != 'mid_day') {
      emit(state.copyWith(clearStartTime: true, clearEndTime: true));
      return;
    }
    emit(state.copyWith(startTime: startTime, endTime: endTime));
  }

  void selectShiftId(int shiftId) {
    if (isClosed) return;
    emit(state.copyWith(shiftId: shiftId));
  }

  void togglePartialExcuse(bool value) {
    if (isClosed) return;
    emit(state.copyWith(partialExcuse: value));
  }

  void selectRequestedDuration(double? duration) {
    if (isClosed) return;
    emit(state.copyWith(requestedDuration: duration));
  }

  void clearAllFields() {
    emit(
      state.copyWith(
        clearStartTime: true,
        clearEndTime: true,
        partialExcuse: false,
      ),
    );
  }
}
