import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  Env._();

  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static String baseUrl = _Env.baseUrl;
  @EnviedField(varName: 'Authenticate', obfuscate: true)
  static String authenticate = _Env.authenticate;
  @EnviedField(varName: 'resetPassword', obfuscate: true)
  static String resetPassword = _Env.resetPassword;
  @EnviedField(varName: 'createAttendancePunch', obfuscate: true)
  static String createAttendancePunchIn = _Env.createAttendancePunchIn;
  @EnviedField(varName: 'getAccountInfo', obfuscate: true)
  static String getAccountInfo = _Env.getAccountInfo;
  @EnviedField(varName: 'updateAccountInfo', obfuscate: true)
  static String updateAccountInfo = _Env.updateAccountInfo;
}
