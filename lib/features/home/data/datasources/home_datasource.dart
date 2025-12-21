import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_request.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_response.dart';

class HomeDataSource {
  HomeDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<CreateAttendancePunchResponse> createAttendancePunchIn(CreateAttendancePunchRequest request) async {
    final response = await apiConsumer.post(
      Env.createAttendancePunchIn,
      body: {
        'params': request.toJson(),
      },
    );
    return CreateAttendancePunchResponse.fromJson(response as Map<String, dynamic>);
  }
}
