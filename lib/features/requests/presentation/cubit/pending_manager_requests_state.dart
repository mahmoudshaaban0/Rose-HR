part of 'pending_manager_requests_cubit.dart';

enum PendingRequestsStatus {
  initial,
  loading,
  success,
  error,
  actionLoading,
  actionSuccess,
  actionError,
}

class PendingRequestsState extends Equatable {
  const PendingRequestsState({
    this.status = PendingRequestsStatus.initial,
    this.pendingRequestsResponseModel,
    this.errorMessage,
    this.activeRequestId,
    this.actionMessage,
  });

  final PendingRequestsStatus status;
  final PendingManagerRequestsResponseModel? pendingRequestsResponseModel;
  final String? errorMessage;
  final int? activeRequestId;
  final String? actionMessage;

  PendingRequestsState copyWith({
    PendingRequestsStatus? status,
    PendingManagerRequestsResponseModel? pendingRequestsResponseModel,
    String? errorMessage,
    int? activeRequestId,
    String? actionMessage,
  }) {
    return PendingRequestsState(
      status: status ?? this.status,
      pendingRequestsResponseModel: pendingRequestsResponseModel ?? this.pendingRequestsResponseModel,
      errorMessage: errorMessage,
      activeRequestId: activeRequestId,
      actionMessage: actionMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    pendingRequestsResponseModel,
    errorMessage,
    activeRequestId,
    actionMessage,
  ];
}
