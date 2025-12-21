import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/home/data/datasources/home_datasource.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_request.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_response.dart';

class HomeRepository {
  HomeRepository(this.homeDatasource);
  final HomeDataSource homeDatasource;

  Future<Result<CreateAttendancePunchResponse>> createAttendancePunchIn(CreateAttendancePunchRequest request) async {
    try {
      final response = await homeDatasource.createAttendancePunchIn(request);
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
