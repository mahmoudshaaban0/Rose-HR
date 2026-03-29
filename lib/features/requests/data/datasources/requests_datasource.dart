import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/requests/data/models/cancel_request_response_model.dart';
import 'package:rose_hr/features/requests/data/models/employee_list_response_model.dart';
import 'package:rose_hr/features/requests/data/models/pending_manager_requests_response_model.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';
import 'package:rose_hr/features/requests/data/models/team_requests_response_model.dart';

class RequestsDataSource {
  RequestsDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<EmployeeListResponseModel> getEmployeeList() async {
    final response = await apiConsumer.get(Env.employeeList);
    return EmployeeListResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<CancelRequestResponseModel> cancelRequest(String recordType, int recordId) async {
    final response = await apiConsumer.post(
      Env.cancelRequestById,
      body: <String, dynamic>{
        "params": <String, dynamic>{
          "record_type": recordType,
          "record_id": recordId,
        },
      },
    );
    return CancelRequestResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  Future<SingleRequestResponseById> getSingleRequestById(String recordType, int recordId) async {
    final response = await apiConsumer.post(
      Env.getRequestById,
      body: <String, dynamic>{
        "params": <String, dynamic>{
          "record_type": recordType,
          "record_id": recordId,
        },
      },
    );
    return SingleRequestResponseById.fromJson(response as Map<String, dynamic>);
  }

  Future<TeamRequestsResponseModel> getManagerRequestsList() async {
    final response = await apiConsumer.get(Env.managerRequestsList);
    return TeamRequestsResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<CancelRequestResponseModel> approveManagerRequest({
    required String recordType,
    required int recordId,
    required String approvalType,
  }) async {
    final response = await apiConsumer.post(
      Env.approveRequest,
      body: <String, dynamic>{
        'params': <String, dynamic>{
          'record_type': recordType,
          'approval_type': approvalType,
          'record_id': recordId,
        },
      },
    );
    return CancelRequestResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  Future<CancelRequestResponseModel> rejectManagerRequest({
    required String recordType,
    required int recordId,
  }) async {
    final response = await apiConsumer.post(
      Env.rejectRequest,
      body: <String, dynamic>{
        'params': <String, dynamic>{
          'record_type': recordType,
          'record_id': recordId,
        },
      },
    );
    return CancelRequestResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  Future<PendingManagerRequestsResponseModel> getPendingManagerRequests() async {
    final response = await apiConsumer.get(Env.pendingManagerRequests);
    return PendingManagerRequestsResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
