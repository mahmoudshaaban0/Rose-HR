import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/auth/data/models/login_request_model.dart';
import 'package:rose_hr/features/auth/data/models/login_response_model.dart';

class AuthDataSource {
  AuthDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiConsumer.post(
      Env.authenticate,
      body: {
        "params": request.toJson(),
      },
    );
    return LoginResponseModel.fromJson(response as Map<String, dynamic>);
  }

  // reset password
  Future<bool> resetPassword(String email) async {
    final response = await apiConsumer.post(
      Env.resetPassword,
      body: {
        "params": {
          "email": email,
        },
      },
    );
    // ignore: avoid_dynamic_calls
    return response['result']['success'] as bool;
  }
}
