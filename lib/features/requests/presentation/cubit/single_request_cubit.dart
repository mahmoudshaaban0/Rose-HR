import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';
import 'package:rose_hr/features/requests/data/repositories/requests_repository.dart';

part 'single_request_state.dart';

class SingleRequestCubit extends Cubit<SingleRequestState> {
  SingleRequestCubit(this.requestsRepository) : super(const SingleRequestState());
  final RequestsRepository requestsRepository;

  Future<void> getSingleRequest(String recordType, int recordId) async {
    if (isClosed) return;
    emit(state.copyWith(status: SingleRequestStatus.loading));
    final result = await requestsRepository.getSingleRequestById(recordType, recordId);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: SingleRequestStatus.success, singleRequestResponse: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: SingleRequestStatus.error, errorMessage: failure.message));
    }
  }

  Future<void> cancelRequest(String recordType, int recordId) async {
    if (isClosed) return;

    emit(state.copyWith(status: SingleRequestStatus.cancelling));
    final result = await requestsRepository.cancelRequest(recordType, recordId);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        // Check if cancellation was successful
        if (data.result?.success ?? false) {
          emit(state.copyWith(status: SingleRequestStatus.cancelSuccess));
          // Refresh the request details after successful cancellation
          await getSingleRequest(recordType, recordId);
        } else {
          emit(
            state.copyWith(
              status: SingleRequestStatus.cancelError,
              errorMessage: data.result?.message ?? 'Failed to cancel request',
            ),
          );
        }
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: SingleRequestStatus.cancelError, errorMessage: failure.message));
    }
  }
}
