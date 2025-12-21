part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, error, resetPasswordSuccess, resetPasswordError, resetPasswordLoading }

class AuthState extends Equatable {
  const AuthState({
    this.loginResponseModel,
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.resetPasswordSuccess = false,
    this.resetPasswordErrorMessage,
  });
  final AuthStatus status;
  final LoginResponseModel? loginResponseModel;
  final String? errorMessage;
  final bool? resetPasswordSuccess;
  final String? resetPasswordErrorMessage;
  @override
  List<Object?> get props => [status, loginResponseModel, errorMessage, resetPasswordSuccess, resetPasswordErrorMessage];

  AuthState copyWith({
    AuthStatus? status,
    LoginResponseModel? loginResponseModel,
    String? errorMessage,
    bool? resetPasswordSuccess,
    String? resetPasswordErrorMessage,
  }) {
    return AuthState(
      loginResponseModel: loginResponseModel ?? this.loginResponseModel,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resetPasswordSuccess: resetPasswordSuccess ?? this.resetPasswordSuccess,
      resetPasswordErrorMessage: resetPasswordErrorMessage ?? this.resetPasswordErrorMessage,
    );
  }
}
