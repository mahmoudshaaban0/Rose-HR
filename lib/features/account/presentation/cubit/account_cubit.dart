import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/account/data/models/account_response_model.dart';
import 'package:rose_hr/features/account/data/repositories/account_repository.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.accountRepository) : super(const AccountState());
  final AccountRepository accountRepository;

  Future<void> getAccountInfo() async {
    emit(state.copyWith(status: AccountStatus.loading));
    final result = await accountRepository.getAccountInfo();
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: AccountStatus.success, accountResponseModel: data));
      case Error(:final failure):
        emit(state.copyWith(status: AccountStatus.error, errorMessage: failure.message));
    }
  }
}
