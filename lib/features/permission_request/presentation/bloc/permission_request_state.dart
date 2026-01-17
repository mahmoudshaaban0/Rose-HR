part of 'permission_request_bloc.dart';

enum PermissionRequestStatus { initial, loading, success, error }

class PermissionRequestState extends Equatable {
  const PermissionRequestState({
    this.status = PermissionRequestStatus.initial,
    this.errorMessage,
  });

  final PermissionRequestStatus status;
  final String? errorMessage;

  // TODO: Add your state properties here (e.g., data models, lists, etc.)

  @override
  List<Object?> get props => [status, errorMessage];

  PermissionRequestState copyWith({
    PermissionRequestStatus? status,
    String? errorMessage,
  }) {
    return PermissionRequestState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

