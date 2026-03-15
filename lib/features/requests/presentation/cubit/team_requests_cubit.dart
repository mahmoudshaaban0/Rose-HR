import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/requests/data/models/team_requests_response_model.dart';
import 'package:rose_hr/features/requests/data/repositories/requests_repository.dart';

part 'team_requests_state.dart';

class TeamRequestsCubit extends Cubit<TeamRequestsState> {
  TeamRequestsCubit(this.requestsRepository) : super(const TeamRequestsState());

  final RequestsRepository requestsRepository;

  Future<void> getTeamRequests() async {
    if (isClosed) return;

    emit(state.copyWith(status: TeamRequestsStatus.loading));
    final result = await requestsRepository.getManagerRequestsList();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: TeamRequestsStatus.success,
            teamRequestsResponseModel: data,
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: TeamRequestsStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> approveRequest(int? requestId) async {
    if (requestId == null || isClosed) return;
    emit(
      state.copyWith(
        status: TeamRequestsStatus.actionLoading,
        activeRequestId: requestId,
      ),
    );

    final result = await requestsRepository.approveManagerRequest(requestId);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        if (data.result?.success ?? false) {
          emit(
            state.copyWith(
              status: TeamRequestsStatus.actionSuccess,
              activeRequestId: requestId,
              actionMessage: data.result?.message,
            ),
          );
          await getTeamRequests();
        } else {
          emit(
            state.copyWith(
              status: TeamRequestsStatus.actionError,
              activeRequestId: requestId,
              errorMessage: data.result?.message,
            ),
          );
        }
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: TeamRequestsStatus.actionError,
            activeRequestId: requestId,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> rejectRequest(int? requestId) async {
    if (requestId == null || isClosed) return;
    emit(
      state.copyWith(
        status: TeamRequestsStatus.actionLoading,
        activeRequestId: requestId,
      ),
    );

    final result = await requestsRepository.rejectManagerRequest(requestId);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        if (data.result?.success ?? false) {
          emit(
            state.copyWith(
              status: TeamRequestsStatus.actionSuccess,
              activeRequestId: requestId,
              actionMessage: data.result?.message,
            ),
          );
          await getTeamRequests();
        } else {
          emit(
            state.copyWith(
              status: TeamRequestsStatus.actionError,
              activeRequestId: requestId,
              errorMessage: data.result?.message,
            ),
          );
        }
      case Error(:final failure):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: TeamRequestsStatus.actionError,
            activeRequestId: requestId,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
