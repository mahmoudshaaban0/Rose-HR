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
  @EnviedField(varName: 'currentShift', obfuscate: true)
  static String getCurrentShift = _Env.getCurrentShift;
  @EnviedField(varName: 'shiftSummary', obfuscate: true)
  static String shiftSummary = _Env.shiftSummary;
  @EnviedField(varName: 'shiftSummaryDetails', obfuscate: true)
  static String shiftSummaryDetails = _Env.shiftSummaryDetails;
  @EnviedField(varName: 'shiftID', obfuscate: true)
  static String getShiftId = _Env.getShiftId;
  @EnviedField(varName: 'createPermission', obfuscate: true)
  static String createPermissionRequest = _Env.createPermissionRequest;
  @EnviedField(varName: 'punchCorrection', obfuscate: true)
  static String punchCorrection = _Env.punchCorrection;
  @EnviedField(varName: 'workMissionReqeust', obfuscate: true)
  static String workMissionReqeust = _Env.workMissionReqeust;
  @EnviedField(varName: 'getLeaveTypes', obfuscate: true)
  static String getLeaveTypes = _Env.getLeaveTypes;
  @EnviedField(varName: 'createHolidayRequest', obfuscate: true)
  static String createHolidayRequest = _Env.createHolidayRequest;
  @EnviedField(varName: 'employeeList', obfuscate: true)
  static String employeeList = _Env.employeeList;
  @EnviedField(varName: 'cancelRequestById', obfuscate: true)
  static String cancelRequestById = _Env.cancelRequestById;
  @EnviedField(varName: 'getRequestById', obfuscate: true)
  static String getRequestById = _Env.getRequestById;
  @EnviedField(varName: 'managerRequestsList', obfuscate: true)
  static String managerRequestsList = _Env.managerRequestsList;
  @EnviedField(varName: 'approveManagerRequest', obfuscate: true)
  static String approveManagerRequest = _Env.approveManagerRequest;
  @EnviedField(varName: 'rejectManagerRequest', obfuscate: true)
  static String rejectManagerRequest = _Env.rejectManagerRequest;
  @EnviedField(varName: 'pendingManagerRequests', obfuscate: true)
  static String pendingManagerRequests = _Env.pendingManagerRequests;
  @EnviedField(varName: 'approveRequest', obfuscate: true)
  static String approveRequest = _Env.approveRequest;
  @EnviedField(varName: 'rejectRequest', obfuscate: true)
  static String rejectRequest = _Env.rejectRequest;
  @EnviedField(varName: 'attendanceLogs', obfuscate: true)
  static String attendanceLogs = _Env.attendanceLogs;
  @EnviedField(varName: 'registerDeviceToken', obfuscate: true)
  static String registerDeviceToken = _Env.registerDeviceToken;
}
