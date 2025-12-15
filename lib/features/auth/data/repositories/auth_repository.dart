import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/auth/data/datasources/auth_datasource.dart';
import 'package:rose_hr/features/auth/data/models/login_request_model.dart';
import 'package:rose_hr/features/auth/data/models/login_response_model.dart';

class AuthRepository {
  AuthRepository(this.authDatasource);
  final AuthDataSource authDatasource;

  Future<Result<LoginResponseModel>> login(LoginRequestModel request) async {
    try {
      final response = await authDatasource.login(request);
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
