import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';

class {{name.pascalCase()}}DataSource {
  {{name.pascalCase()}}DataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  // TODO: Add your API methods here
  // Example:
  // Future<YourResponseModel> yourMethod(YourRequestModel request) async {
  //   final response = await apiConsumer.post(
  //     Env.yourEndpoint,
  //     body: {
  //       "params": request.toJson(),
  //     },
  //   );
  //   return YourResponseModel.fromJson(response as Map<String, dynamic>);
  // }
}

