part of 'team_requests_cubit.dart';

enum TeamRequestsStatus {
  initial,
  loading,
  success,
  error,
  actionLoading,
  actionSuccess,
  actionError,
}

class TeamRequestsState extends Equatable {
  const TeamRequestsState({
    this.status = TeamRequestsStatus.initial,
    this.teamRequestsResponseModel,
    this.errorMessage,
    this.actionMessage,
    this.activeRequestId,
  });

  final TeamRequestsStatus status;
  final TeamRequestsResponseModel? teamRequestsResponseModel;
  final String? errorMessage;
  final String? actionMessage;
  final int? activeRequestId;

  TeamRequestsState copyWith({
    TeamRequestsStatus? status,
    TeamRequestsResponseModel? teamRequestsResponseModel,
    String? errorMessage,
    String? actionMessage,
    int? activeRequestId,
  }) {
    return TeamRequestsState(
      status: status ?? this.status,
      teamRequestsResponseModel:
          teamRequestsResponseModel ?? this.teamRequestsResponseModel,
      errorMessage: errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
      activeRequestId: activeRequestId ?? this.activeRequestId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    teamRequestsResponseModel,
    errorMessage,
    actionMessage,
    activeRequestId,
  ];
}
