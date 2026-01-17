import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/routing/notifier.dart';
import 'package:rose_hr/common/widgets/bottom_nav_bar.dart';
import 'package:rose_hr/features/account/presentation/screens/update_account_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/login_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/verification_screen.dart';
import 'package:rose_hr/features/permission_request/presentation/screens/permission_request_screen.dart';
import 'package:rose_hr/features/punch_correction/presentation/screens/correction_time_screen.dart';
import 'package:rose_hr/features/punch_correction/presentation/screens/punch_correction_screen.dart';
import 'package:rose_hr/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash.path,
    refreshListenable: RoutingNotifier(),
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
      GoRoute(
        name: AppRoutes.updateAccount.name,
        path: AppRoutes.updateAccount.path,
        builder: (context, state) => const UpdateAccountScreen(),
      ),
      GoRoute(
        name: AppRoutes.punchCorrection.name,
        path: AppRoutes.punchCorrection.path,
        builder: (context, state) => const PunchCorrectionScreen(),
      ),
      GoRoute(
        name: AppRoutes.correctionTime.name,
        path: AppRoutes.correctionTime.path,
        builder: (context, state) => const CorrectionTimeScreen(),
      ),
      GoRoute(
        name: AppRoutes.permissionRequest.name,
        path: AppRoutes.permissionRequest.path,
        builder: (context, state) => const PermissionRequestScreen(),
      ),
    ],
  );
}
