import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/permission_request/data/datasources/permission_request_datasource.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_response_model.dart';
import 'package:rose_hr/features/permission_request/data/models/shift_id_response_model.dart' hide ShiftIdResult;

class PermissionRequestRepository {
  PermissionRequestRepository(this.permissionRequestDatasource);
  final PermissionRequestDataSource permissionRequestDatasource;

  Future<Result<ShiftIdResponseModel>> getShiftId(String date) async {
    try {
      final response = await permissionRequestDatasource.getShiftId(date);
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

  Future<Result<PermissionRequestResponseModel>> createPermissionRequest(PermissionRequestRequestModel request) async {
    try {
      final response = await permissionRequestDatasource.createPermissionRequest(request);
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
