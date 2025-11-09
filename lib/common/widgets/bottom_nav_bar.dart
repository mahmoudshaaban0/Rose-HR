import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:rose_hr/features/auth/presentation/screens/login_screen.dart';
import 'package:rose_hr/features/home/presentation/screens/home_screen.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();

    controller = PersistentTabController();
  }

  bool _isKeyboardVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.of(context);
    final newIsKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    if (_isKeyboardVisible != newIsKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newIsKeyboardVisible;
      });
    }
  }

  List<PersistentTabConfig> _tabs(BuildContext context) {
    return [
      PersistentTabConfig(
        screen: const HomeScreen(),
        item: ItemConfig(
          title: context.localizations.home,
          textStyle: context.typography.semiBold14,
          activeForegroundColor: context.colors.onSurface,
          icon: const AppVectorGraphic(path: Assets.vectorsHomeActive),
          inactiveIcon: const AppVectorGraphic(
            path: Assets.vectorsHomeInActive,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: const AttendanceScreen(),
        item: ItemConfig(
          title: context.localizations.attendance,
          textStyle: context.typography.semiBold14,
          activeForegroundColor: context.colors.onSurface,
          inactiveIcon: const AppVectorGraphic(
            path: Assets.vectorsAttendanceInActive,
          ),
          icon: const AppVectorGraphic(path: Assets.vectorsAttendanceActive),
        ),
      ),
      PersistentTabConfig(
        screen: const LoginScreen(),
        item: ItemConfig(
          title: context.localizations.requests,
          textStyle: context.typography.semiBold14,
          activeForegroundColor: context.colors.onSurface,
          inactiveIcon: const AppVectorGraphic(
            path: Assets.vectorsRequestsInActive,
          ),
          icon: const AppVectorGraphic(path: Assets.vectorsRequestsActive),
        ),
      ),
      PersistentTabConfig(
        screen: Container(),
        item: ItemConfig(
          title: context.localizations.account,
          textStyle: context.typography.semiBold14,
          activeForegroundColor: context.colors.onSurface,
          inactiveIcon: const AppVectorGraphic(
            path: Assets.vectorsAccountInActive,
          ),
          icon: const AppVectorGraphic(path: Assets.vectorsAccountActive),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: PersistentTabView(
          backgroundColor: context.colors.surface,
          tabs: _tabs(context),
          controller: controller,
          avoidBottomPadding: false,
          navBarBuilder: (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(
              padding: EdgeInsets.zero,
              color: context.colors.surface,
            ),
          ),
        ),
      ),
    );
  }
}
