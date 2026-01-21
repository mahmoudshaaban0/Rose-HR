import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/work_mission/data/datasources/work_mission_datasource.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_request_model.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_response_model.dart';

class WorkMissionRepository {
  WorkMissionRepository(this.workMissionDatasource);
  final WorkMissionDataSource workMissionDatasource;

  Future<Result<WorkPermissionResponseModel>> createWorkMission(WorkMissionRequestModel request) async {
    try {
      final response = await workMissionDatasource.createWorkMission(request);
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
