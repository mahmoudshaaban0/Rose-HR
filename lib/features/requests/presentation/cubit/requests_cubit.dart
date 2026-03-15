import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/requests/data/models/employee_list_response_model.dart';
import 'package:rose_hr/features/requests/data/repositories/requests_repository.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit(this.requestsRepository) : super(const RequestsState());
  final RequestsRepository requestsRepository;

  Future<void> getEmployeeList() async {
    if (isClosed) return;
    emit(state.copyWith(status: RequestsStatus.loading));
    final result = await requestsRepository.getEmployeeList();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: RequestsStatus.success, employeeListResponseModel: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: RequestsStatus.error, errorMessage: failure.message));
    }
  }

  Future<void> cancelRequest(int? requestId) async {
    if (requestId == null || isClosed) return;

    emit(state.copyWith(status: RequestsStatus.cancelling, cancelledRequestId: requestId));
    final result = await requestsRepository.cancelRequest(requestId);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        // Check if cancellation was successful
        if (data.result?.success ?? false) {
          emit(state.copyWith(status: RequestsStatus.cancelSuccess, cancelledRequestId: requestId));
          // Refresh the list after successful cancellation
          await getEmployeeList();
        } else {
          emit(
            state.copyWith(
              status: RequestsStatus.cancelError,
              errorMessage: data.result?.message ?? 'Failed to cancel request',
            ),
          );
        }
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: RequestsStatus.cancelError, errorMessage: failure.message));
    }
  }
}
