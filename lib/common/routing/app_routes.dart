enum AppRoutes {
  splash('/', 'Splash'),
  login('/login', 'Login'),
  forgetPassword('/forget-password', 'Forget Password'),
  home('/home', 'Home'),
  verification('/verification', 'Verification'),
  updateAccount('/update-account', 'Update Account'),
  punchCorrection('/attendance-correction', 'Attendance Correction'),
  correctionTime('/correction-time', 'Correction Time'),
  permissionRequest('/permission-request', 'Permission Request');
  // workAssignment('/work-assignment', 'Work Assignment'),
  // leaveRequest('/leave-request', 'Leave Request'),

  const AppRoutes(this.path, this.name);
  final String path;
  final String name;
}
