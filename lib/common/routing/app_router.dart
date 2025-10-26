import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash.path,
    routes: [
      GoRoute(
        name: AppRoutes.splash.name,
        path: AppRoutes.splash.path,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
