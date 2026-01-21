import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_request_model.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_response_model.dart';

class WorkMissionDataSource {
  WorkMissionDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<WorkPermissionResponseModel> createWorkMission(WorkMissionRequestModel request) async {
    final response = await apiConsumer.post(
      Env.workMissionReqeust,
      body: {
        "params": request.toJson(),
      },
    );
    return WorkPermissionResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
