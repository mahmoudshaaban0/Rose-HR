import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_logs_response_model.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_summary_details_response_model.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_summary_response_model.dart';

class AttendanceDataSource {
  AttendanceDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<AttendanceSummary> getAttendanceSummary(int month, int year) async {
    final response = await apiConsumer.post(
      Env.shiftSummary,
      body: {
        "params": {
          "month": month,
          "year": year,
        },
      },
    );
    return AttendanceSummary.fromJson(response as Map<String, dynamic>);
  }

  Future<AttendanceSummaryDetailsResponseModel> getAttendanceSummaryByDate(String date) async {
    final response = await apiConsumer.post(
      Env.shiftSummaryDetails,
      body: {
        "params": {
          "date": date,
        },
      },
    );
    return AttendanceSummaryDetailsResponseModel.fromJson(response as Map<String, dynamic>);
  }

  Future<AttendanceLogsResponseModel> getAttendanceLogs(String date) async {
    final response = await apiConsumer.post(
      Env.attendanceLogs,
      body: {
        "params": {
          "date": date,
        },
      },
    );
    return AttendanceLogsResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
