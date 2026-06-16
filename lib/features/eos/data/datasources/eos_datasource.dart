import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/eos/data/models/eos_request_model.dart';
import 'package:rose_hr/features/eos/data/models/eos_response_model.dart';

class EosDataSource {
  EosDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<EosResponseModel> createEos(EosRequestModel request) async {
    final response = await apiConsumer.post(
      Env.createEos,
      body: request.toJson(),
    );
    return EosResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
