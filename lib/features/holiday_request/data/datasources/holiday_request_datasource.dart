import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/holiday_request/data/models/get_all_leave_types_response_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/holiday_request_model.dart';
import 'package:rose_hr/features/holiday_request/data/models/holiday_request_response_model.dart';

class HolidayRequestDataSource {
  HolidayRequestDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<HolidayRequestResponseModel> createHolidayRequest(HolidayRequestModel request) async {
    final response = await apiConsumer.post(
      Env.createHolidayRequest,
      body: request.toJson(),
    );
    return HolidayRequestResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<AlleaveTypesResponseModel> getAllLeaveTypes() async {
    final response = await apiConsumer.get(
      Env.getLeaveTypes,
    );
    return AlleaveTypesResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
