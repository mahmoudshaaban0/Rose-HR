part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  const LoginEvent({required this.loginRequestModel});
  final LoginRequestModel loginRequestModel;

  @override
  List<Object> get props => [loginRequestModel];
}
