part of 'requests_cubit.dart';

enum RequestsStatus { initial, loading, success, error, cancelling, cancelSuccess, cancelError }

class RequestsState extends Equatable {
  const RequestsState({
    this.status = RequestsStatus.initial,
    this.employeeListResponseModel,
    this.errorMessage,
    this.cancelledRequestId,
  });
  final RequestsStatus status;
  final EmployeeListResponseModel? employeeListResponseModel;
  final String? errorMessage;
  final int? cancelledRequestId;

  RequestsState copyWith({
    RequestsStatus? status,
    EmployeeListResponseModel? employeeListResponseModel,
    String? errorMessage,
    int? cancelledRequestId,
  }) {
    return RequestsState(
      status: status ?? this.status,
      employeeListResponseModel: employeeListResponseModel ?? this.employeeListResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
      cancelledRequestId: cancelledRequestId ?? this.cancelledRequestId,
    );
  }

  @override
  List<Object?> get props => [status, employeeListResponseModel, errorMessage, cancelledRequestId];
}
