import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/bottom_nav_bar.dart';
import 'package:rose_hr/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/login_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/verification_screen.dart';
import 'package:rose_hr/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash.path,
    routes: [
      GoRoute(
        name: AppRoutes.splash.name,
        path: AppRoutes.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoutes.login.name,
        path: AppRoutes.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRoutes.forgetPassword.name,
        path: AppRoutes.forgetPassword.path,
        builder: (context, state) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        name: AppRoutes.verification.name,
        path: AppRoutes.verification.path,
        builder: (context, state) => const VerificationScreen(),
      ),
      GoRoute(
        name: AppRoutes.home.name,
        path: AppRoutes.home.path,
        builder: (context, state) => const BottomNavBar(),
      ),
    ],
  );
}
