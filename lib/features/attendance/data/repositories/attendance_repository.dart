import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/attendance/data/datasources/attendance_datasource.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_summary_response_model.dart';

class AttendanceRepository {
  AttendanceRepository(this.attendanceDatasource);
  final AttendanceDataSource attendanceDatasource;

  // Example:
  Future<Result<AttendanceSummary>> getAttendanceSummary(int month, int year) async {
    try {
      final response = await attendanceDatasource.getAttendanceSummary(month, year);
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
