import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_request_model.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_response_model.dart';

class PunchCorrectionDataSource {
  PunchCorrectionDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<PunchCorrectionResponseModel> createPunchCorrection(
    PunchCorrectionRequestModel request,
  ) async {
    final response = await apiConsumer.post(
      Env.punchCorrection,
      body: {
        "params": request.toJson(),
      },
    );
    return PunchCorrectionResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
