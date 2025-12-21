enum AppRoutes {
  splash('/', 'Splash'),
  login('/login', 'Login'),
  forgetPassword('/forget-password', 'Forget Password'),
  home('/home', 'Home'),
  verification('/verification', 'Verification'),
  updateAccount('/update-account', 'Update Account');

  const AppRoutes(this.path, this.name);
  final String path;
  final String name;
}
