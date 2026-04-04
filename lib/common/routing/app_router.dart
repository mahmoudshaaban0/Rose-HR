import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/routing/notifier.dart';
import 'package:rose_hr/common/widgets/bottom_nav_bar.dart';
import 'package:rose_hr/features/account/presentation/screens/my_information_account_screen.dart';
import 'package:rose_hr/features/account/presentation/screens/update_account_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/login_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/verification_screen.dart';
import 'package:rose_hr/features/general_settings/presentation/screens/general_settings_screen.dart';
import 'package:rose_hr/features/holiday_request/presentation/screens/holiday_request_screen.dart';
import 'package:rose_hr/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:rose_hr/features/permission_request/presentation/screens/permission_request_screen.dart';
import 'package:rose_hr/features/punch_correction/presentation/cubit/punch_correction_cubit.dart';
import 'package:rose_hr/features/punch_correction/presentation/screens/correction_time_screen.dart';
import 'package:rose_hr/features/punch_correction/presentation/screens/punch_correction_screen.dart';
import 'package:rose_hr/features/requests/data/models/employee_list_response_model.dart';
import 'package:rose_hr/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:rose_hr/features/requests/presentation/cubit/pending_manager_requests_cubit.dart';
import 'package:rose_hr/features/requests/data/models/pending_manager_requests_response_model.dart';
import 'package:rose_hr/features/requests/presentation/screens/all_pending_manager_requests_screen.dart';
import 'package:rose_hr/features/requests/presentation/screens/single_request_screen.dart';
import 'package:rose_hr/features/requests/presentation/screens/single_team_request_screen.dart';
import 'package:rose_hr/features/splash/presentation/screens/splash_screen.dart';
import 'package:rose_hr/features/work_mission/presentation/screens/work_mission_screen.dart';
import 'package:rose_hr/theme/theme_ext.dart';

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
        name: AppRoutes.myInformation.name,
        path: AppRoutes.myInformation.path,
        builder: (context, state) => const MyInformationAccountScreen(),
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
        builder: (context, state) => CorrectionTimeScreen(cubit: state.extra! as PunchCorrectionCubit),
      ),
      GoRoute(
        name: AppRoutes.permissionRequest.name,
        path: AppRoutes.permissionRequest.path,
        builder: (context, state) => const PermissionRequestScreen(),
      ),
      GoRoute(
        name: AppRoutes.workMission.name,
        path: AppRoutes.workMission.path,
        builder: (context, state) => const WorkMissionScreen(),
      ),
      GoRoute(
        name: AppRoutes.holidayRequest.name,
        path: AppRoutes.holidayRequest.path,
        builder: (context, state) => const HolidayRequestScreen(),
      ),
      GoRoute(
        name: AppRoutes.singleRequest.name,
        path: AppRoutes.singleRequest.path,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic> && extra['request'] is Datum) {
            return SingleRequestScreen(request: extra['request'] as Datum, parentRequestsCubit: extra['cubit'] as RequestsCubit?);
          }
          // If extra is not Datum, navigate back or show error
          return Scaffold(
            body: Center(
              child: Text(context.localizations.invalidRequestData),
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.singleTeamRequest.name,
        path: AppRoutes.singleTeamRequest.path,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map<String, dynamic> &&
              extra['item'] is PendingRequestItem &&
              extra['cubit'] is PendingRequestsCubit) {
            return SingleTeamRequestScreen(
              item: extra['item'] as PendingRequestItem,
              pendingRequestsCubit: extra['cubit'] as PendingRequestsCubit,
            );
          }
          return Scaffold(
            body: Center(
              child: Text(context.localizations.invalidRequestData),
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.generalSettings.name,
        path: AppRoutes.generalSettings.path,
        builder: (context, state) => const GeneralSettingsScreen(),
      ),
      GoRoute(
        name: AppRoutes.allPendingManagerRequests.name,
        path: AppRoutes.allPendingManagerRequests.path,
        builder: (context, state) => const AllPendingManagerRequestsScreen(),
      ),
      GoRoute(
        name: AppRoutes.notifications.name,
        path: AppRoutes.notifications.path,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}
