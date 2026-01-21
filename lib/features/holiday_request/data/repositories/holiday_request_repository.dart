import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/holiday_request/data/datasources/holiday_request_datasource.dart';
import 'package:rose_hr/features/holiday_request/data/models/get_all_leave_types_response_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/holiday_request_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/holiday_request_response_model.dart';

class HolidayRequestRepository {
  HolidayRequestRepository(this.holidayRequestDatasource);
  final HolidayRequestDataSource holidayRequestDatasource;

  Future<Result<AlleaveTypesResponseModel>> getAllLeaveTypes() async {
    try {
      final response = await holidayRequestDatasource.getAllLeaveTypes();
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

  Future<Result<HolidayRequestResponseModel>> createHolidayRequest(HolidayRequestModel request) async {
    try {
      final response = await holidayRequestDatasource.createHolidayRequest(request);
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
