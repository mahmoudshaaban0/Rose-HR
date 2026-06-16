import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/eos/data/datasources/eos_datasource.dart';
import 'package:rose_hr/features/eos/data/models/eos_request_model.dart';
import 'package:rose_hr/features/eos/data/models/eos_response_model.dart';

class EosRepository {
  EosRepository(this.eosDatasource);
  final EosDataSource eosDatasource;

  Future<Result<EosResponseModel>> createEos(EosRequestModel request) async {
    try {
      final response = await eosDatasource.createEos(request);
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
