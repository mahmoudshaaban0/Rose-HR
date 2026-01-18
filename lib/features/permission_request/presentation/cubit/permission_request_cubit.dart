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
      emit(
        state.copyWith(
          permissionTypeName: permissionTypeName,
          permissionTypeId: permissionTypeId,
          clearStartTime: true,
          clearEndTime: true,
        ),
      );
    } else {
      emit(state.copyWith(permissionTypeName: permissionTypeName, permissionTypeId: permissionTypeId));
    }
  }

  void sendDate(DateTime date) {
    emit(state.copyWith(date: date.toIso8601String()));
  }

  void sendReasonType(String reasonTypeName, String reasonTypeId) {
    emit(state.copyWith(reasonTypeName: reasonTypeName, reasonTypeId: reasonTypeId));
  }

  void sendStartTimeAndEndTime({String? startTime, String? endTime}) {
    if (state.permissionTypeId != 'mid_day') {
      emit(state.copyWith(clearStartTime: true, clearEndTime: true));
      return;
    }
    emit(state.copyWith(startTime: startTime, endTime: endTime));
  }

  void sendShiftId(int shiftId) {
    emit(state.copyWith(shiftId: shiftId));
  }

  void togglePartialExcuse(bool value) {
    emit(state.copyWith(partialExcuse: value));
  }

  void sendRequestedDuration(double? duration) {
    emit(state.copyWith(requestedDuration: duration));
  }
}
