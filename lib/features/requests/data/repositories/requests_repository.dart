import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/requests/data/datasources/requests_datasource.dart';
import 'package:rose_hr/features/requests/data/models/cancel_request_response_model.dart';
import 'package:rose_hr/features/requests/data/models/employee_list_response_model.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';

class RequestsRepository {
  RequestsRepository(this.requestsDataSource);
  final RequestsDataSource requestsDataSource;

  Future<Result<EmployeeListResponseModel>> getEmployeeList() async {
    try {
      final response = await requestsDataSource.getEmployeeList();
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

  Future<Result<CancelRequestResponseModel>> cancelRequest(int requestId) async {
    try {
      final response = await requestsDataSource.cancelRequest(requestId);
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

  Future<Result<SingleRequestResponseById>> getSingleRequestById(int requestId) async {
    try {
      final response = await requestsDataSource.getSingleRequestById(requestId);
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
