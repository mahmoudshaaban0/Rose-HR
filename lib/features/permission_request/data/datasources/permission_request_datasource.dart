import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_response_model.dart';
import 'package:rose_hr/features/permission_request/data/models/shift_id_response_model.dart';

class PermissionRequestDataSource {
  PermissionRequestDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  // Example:
  Future<ShiftIdResponseModel> getShiftId(String date) async {
    final response = await apiConsumer.post(
      Env.getShiftId,
      body: {
        "params": {
          "date": date,
        },
      },
    );
    return ShiftIdResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<PermissionRequestResponseModel> createPermissionRequest(PermissionRequestRequestModel request) async {
    final response = await apiConsumer.post(
      Env.createPermissionRequest,
      body: {
        "params": request.toJson(),
      },
    );
    return PermissionRequestResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
