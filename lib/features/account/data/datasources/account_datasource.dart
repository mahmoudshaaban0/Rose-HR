import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/account/data/models/account_response_model.dart';

class AccountDataSource {
  AccountDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<AccountResponseModel> getAccountInfo() async {
    final response = await apiConsumer.get(Env.getAccountInfo);
    return AccountResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
