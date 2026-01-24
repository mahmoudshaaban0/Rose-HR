part of 'single_request_cubit.dart';

enum SingleRequestStatus {
  initial,
  loading,
  success,
  error,
  cancelling,
  cancelSuccess,
  cancelError,
}

class SingleRequestState extends Equatable {
  const SingleRequestState({
    this.status = SingleRequestStatus.initial,
    this.singleRequestResponse,
    this.errorMessage,
  });
  final SingleRequestStatus status;
  final SingleRequestResponseById? singleRequestResponse;
  final String? errorMessage;

  SingleRequestState copyWith({
    SingleRequestStatus? status,
    SingleRequestResponseById? singleRequestResponse,
    String? errorMessage,
  }) {
    return SingleRequestState(
      status: status ?? this.status,
      singleRequestResponse: singleRequestResponse ?? this.singleRequestResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, singleRequestResponse, errorMessage];
}
