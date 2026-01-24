enum AppRoutes {
  splash('/', 'Splash'),
  login('/login', 'Login'),
  forgetPassword('/forget-password', 'Forget Password'),
  home('/home', 'Home'),
  verification('/verification', 'Verification'),
  updateAccount('/update-account', 'Update Account'),
  punchCorrection('/attendance-correction', 'Attendance Correction'),
  correctionTime('/correction-time', 'Correction Time'),
  permissionRequest('/permission-request', 'Permission Request'),
  workMission('/work-mission', 'Work Mission'),
  holidayRequest('/holiday-request', 'Holiday Request'),
  singleRequest('/single-request', 'Single Request');

  const AppRoutes(this.path, this.name);
  final String path;
  final String name;
}
