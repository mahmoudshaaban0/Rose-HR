import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/{{name.snakeCase()}}/data/datasources/{{name.snakeCase()}}_datasource.dart';

class {{name.pascalCase()}}Repository {
  {{name.pascalCase()}}Repository(this.{{name.camelCase()}}Datasource);
  final {{name.pascalCase()}}DataSource {{name.camelCase()}}Datasource;

  // TODO: Add your repository methods here
  // Example:
  // Future<Result<YourResponseModel>> yourMethod(YourRequestModel request) async {
  //   try {
  //     final response = await {{name.camelCase()}}Datasource.yourMethod(request);
  //     return Success(response);
  //   } on NoInternetConnectionException catch (e) {
  //     return Error(NetworkFailure(e.toString()));
  //   } on BadCertificateException catch (e) {
  //     return Error(NetworkFailure(e.toString()));
  //   } on ServerException catch (e) {
  //     return Error(ServerFailure(e.toString()));
  //   } on FormatException catch (e) {
  //     return Error(DataFailure('Invalid data format: ${e.message}'));
  //   } on Exception catch (e) {
  //     return Error(UnknownFailure(e.toString()));
  //   }
  // }
}

