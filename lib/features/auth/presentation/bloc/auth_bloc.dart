import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/auth/data/models/login_request_model.dart';
import 'package:rose_hr/features/auth/data/models/login_response_model.dart';
import 'package:rose_hr/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.authRepository) : super(const AuthState()) {
    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await authRepository.login(event.loginRequestModel);
      switch (result) {
        case Success(:final data):
          emit(state.copyWith(status: AuthStatus.success, loginResponseModel: data));
        case Error(:final failure):
          emit(state.copyWith(status: AuthStatus.error, errorMessage: failure.message));
      }
    });
    on<ResetPasswordEvent>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.resetPasswordLoading));
      final result = await authRepository.resetPassword(event.email);
      switch (result) {
        case Success(:final data):
          emit(state.copyWith(status: AuthStatus.resetPasswordSuccess, resetPasswordSuccess: data));
        case Error(:final failure):
          emit(state.copyWith(status: AuthStatus.resetPasswordError, resetPasswordErrorMessage: failure.message));
      }
    });
  }

  final AuthRepository authRepository;
}
