enum AppRoutes {
  splash('/', 'Splash'),
  home('/home', 'Home');

  const AppRoutes(this.path, this.name);
  final String path;
  final String name;
}
