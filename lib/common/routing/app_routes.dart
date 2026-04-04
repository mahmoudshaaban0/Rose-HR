enum AppRoutes {
  splash('/', 'Splash'),
  login('/login', 'Login'),
  forgetPassword('/forget-password', 'Forget Password'),
  home('/home', 'Home'),
  verification('/verification', 'Verification'),
  myInformation('/my-information', 'My Information'),
  updateAccount('/update-account', 'Update Account'),
  punchCorrection('/attendance-correction', 'Attendance Correction'),
  correctionTime('/correction-time', 'Correction Time'),
  permissionRequest('/permission-request', 'Permission Request'),
  workMission('/work-mission', 'Work Mission'),
  holidayRequest('/holiday-request', 'Holiday Request'),
  singleRequest('/single-request', 'Single Request'),
  generalSettings('/general-settings', 'General Settings'),
  allPendingManagerRequests('/all-pending-manager-requests', 'All Pending Manager Requests'),
  singleTeamRequest('/single-team-request', 'Single Team Request'),
  notifications('/notifications', 'Notifications');

  const AppRoutes(this.path, this.name);
  final String path;
  final String name;
}
