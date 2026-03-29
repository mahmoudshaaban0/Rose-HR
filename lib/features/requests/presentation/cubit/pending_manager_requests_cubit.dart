import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/requests/data/models/pending_manager_requests_response_model.dart';
import 'package:rose_hr/features/requests/data/repositories/requests_repository.dart';

part 'pending_manager_requests_state.dart';

class PendingRequestsCubit extends Cubit<PendingRequestsState> {
  PendingRequestsCubit(this.requestsRepository) : super(const PendingRequestsState());

  final RequestsRepository requestsRepository;

  Future<void> getPendingManagerRequests() async {
    if (isClosed) return;

    emit(state.copyWith(status: PendingRequestsStatus.loading));
    final result = await requestsRepository.getPendingManagerRequests();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PendingRequestsStatus.success,
            pendingRequestsResponseModel: data,
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PendingRequestsStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> approveRequest({
    required String recordType,
    required int requestId,
    required String approvalType,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: PendingRequestsStatus.actionLoading,
        activeRequestId: requestId,
      ),
    );

    final result = await requestsRepository.approveManagerRequest(
      recordType: recordType,
      recordId: requestId,
      approvalType: approvalType,
    );
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        if (data.result?.success ?? false) {
          emit(
            state.copyWith(
              status: PendingRequestsStatus.actionSuccess,
              activeRequestId: requestId,
              actionMessage: data.result?.message,
            ),
          );
          await getPendingManagerRequests();
        } else {
          emit(
            state.copyWith(
              status: PendingRequestsStatus.actionError,
              activeRequestId: requestId,
              errorMessage: data.result?.message,
            ),
          );
        }
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PendingRequestsStatus.actionError,
            activeRequestId: requestId,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> rejectRequest({
    required String recordType,
    required int requestId,
  }) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: PendingRequestsStatus.actionLoading,
        activeRequestId: requestId,
      ),
    );

    final result = await requestsRepository.rejectManagerRequest(
      recordType: recordType,
      recordId: requestId,
    );
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        if (data.result?.success ?? false) {
          emit(
            state.copyWith(
              status: PendingRequestsStatus.actionSuccess,
              activeRequestId: requestId,
              actionMessage: data.result?.message,
            ),
          );
          await getPendingManagerRequests();
        } else {
          emit(
            state.copyWith(
              status: PendingRequestsStatus.actionError,
              activeRequestId: requestId,
              errorMessage: data.result?.message,
            ),
          );
        }
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: PendingRequestsStatus.actionError,
            activeRequestId: requestId,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
