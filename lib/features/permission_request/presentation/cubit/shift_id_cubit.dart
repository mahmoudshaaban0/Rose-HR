import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/permission_request/data/repositories/permission_request_repository.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_state.dart';

class ShiftIdCubit extends Cubit<ShiftIdState> {
  ShiftIdCubit(this.permissionRequestRepository) : super(const ShiftIdState());
  final PermissionRequestRepository permissionRequestRepository;

  Future<void> getShiftId(String date) async {
    if (isClosed) return;
    emit(state.copyWith(status: ShiftIdStatus.loading));
    final result = await permissionRequestRepository.getShiftId(date);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: ShiftIdStatus.success, shiftIdResponseModel: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: ShiftIdStatus.error, errorMessage: failure.message));
    }
  }
}
