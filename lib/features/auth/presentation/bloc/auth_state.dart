part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState extends Equatable {
  const AuthState({this.loginResponseModel, this.status = AuthStatus.initial, this.errorMessage});
  final AuthStatus status;
  final LoginResponseModel? loginResponseModel;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, loginResponseModel, errorMessage];

  AuthState copyWith({
    AuthStatus? status,
    LoginResponseModel? loginResponseModel,
    String? errorMessage,
  }) {
    return AuthState(
      loginResponseModel: loginResponseModel ?? this.loginResponseModel,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
