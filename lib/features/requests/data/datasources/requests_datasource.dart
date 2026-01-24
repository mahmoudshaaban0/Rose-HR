import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/requests/data/models/cancel_request_response_model.dart';
import 'package:rose_hr/features/requests/data/models/employee_list_response_model.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';

class RequestsDataSource {
  RequestsDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<EmployeeListResponseModel> getEmployeeList() async {
    final response = await apiConsumer.get(Env.employeeList);
    return EmployeeListResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<CancelRequestResponseModel> cancelRequest(int requestId) async {
    final response = await apiConsumer.post(
      '${Env.cancelRequestById}$requestId',
      body: <String, dynamic>{
        "params": <String, dynamic>{},
      },
    );
    return CancelRequestResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<SingleRequestResponseById> getSingleRequestById(int requestId) async {
    final response = await apiConsumer.get(
      '${Env.getRequestById}$requestId',
    );
    return SingleRequestResponseById.fromJson(response as Map<String, dynamic>);
  }
}
