import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/punch_correction/data/datasources/punch_correction_datasource.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_request_model.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_response_model.dart';

class PunchCorrectionRepository {
  PunchCorrectionRepository(this.punchCorrectionDatasource);
  final PunchCorrectionDataSource punchCorrectionDatasource;

  Future<Result<PunchCorrectionResponseModel>> createPunchCorrection(
    PunchCorrectionRequestModel request,
  ) async {
    try {
      final response = await punchCorrectionDatasource.createPunchCorrection(request);
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
