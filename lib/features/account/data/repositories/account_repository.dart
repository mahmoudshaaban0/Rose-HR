import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/account/data/datasources/account_datasource.dart';
import 'package:rose_hr/features/account/data/models/account_response_model.dart';

class AccountRepository {
  AccountRepository(this.accountDataSource);
  final AccountDataSource accountDataSource;

  Future<Result<AccountResponseModel>> getAccountInfo() async {
    try {
      final response = await accountDataSource.getAccountInfo();
      return Success(response);
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
