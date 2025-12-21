part of 'account_cubit.dart';

enum AccountStatus { initial, loading, success, error }

class AccountState extends Equatable {
  const AccountState({
    this.status = AccountStatus.initial,
    this.accountResponseModel,
    this.errorMessage,
  });
  final AccountStatus status;
  final AccountResponseModel? accountResponseModel;
  final String? errorMessage;

  AccountState copyWith({
    AccountStatus? status,
    AccountResponseModel? accountResponseModel,
    String? errorMessage,
  }) {
    return AccountState(
      status: status ?? this.status,
      accountResponseModel: accountResponseModel ?? this.accountResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accountResponseModel, errorMessage];
}
