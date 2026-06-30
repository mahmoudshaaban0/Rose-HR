import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/routing/app_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/l10n/app_localizations.dart';
import 'package:rose_hr/theme/app_theme_scope.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';
import 'package:upgrader/upgrader.dart';

class RoseHr extends StatelessWidget {
  const RoseHr({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);
    final locale =
        ThemeScopeWidget.of(context)?.locale ?? const Locale(AppStrings.arabic);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          themeMode: theme!.themeMode,
          locale: locale,
          // Force-update gate: wraps every routed screen with an upgrade
          // dialog once routing settles off the splash screen.
          builder: (context, child) =>
              _UpgradeGate(child: child ?? const SizedBox.shrink()),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          // Set [brightness] explicitly so [Theme.of(context).brightness] and
          // [context.isDarkMode] match the active Material theme (light vs dark).
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: theme.theme.colors.surface,
            extensions: [
              theme.theme.colors,
              theme.theme.typography,
              theme.theme.inputTheme,
              theme.theme.buttonTheme,
            ],
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: theme.theme.colors.surface,
            extensions: [
              theme.theme.colors,
              theme.theme.typography,
              theme.theme.inputTheme,
              theme.theme.buttonTheme,
            ],
          ),
        );
      },
    );
  }
}

/// Arms the mandatory force-update dialog only once routing has settled off
/// the splash route.
///
/// Why a stateful gate instead of a `ListenableBuilder`: `GoRouterDelegate`
/// fires its change notification *during* the build phase, so listening to it
/// inline would `markNeedsBuild` mid-build and throw. Here we listen out of
/// band and defer the rebuild to a post-frame callback, rebuilding only on the
/// actual splash↔destination transition.
///
/// Why skip splash: splash auto-redirects to home/login, and a dialog opened
/// over the splash page is a pageless route anchored to it — it would be torn
/// down together with the splash page on redirect.
class _UpgradeGate extends StatefulWidget {
  const _UpgradeGate({required this.child});

  final Widget child;

  @override
  State<_UpgradeGate> createState() => _UpgradeGateState();
}

class _UpgradeGateState extends State<_UpgradeGate> {
  final GoRouterDelegate _delegate = AppRouter.router.routerDelegate;
  late bool _onSplash = _isSplash();

  @override
  void initState() {
    super.initState();
    _delegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _delegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  bool _isSplash() =>
      _delegate.currentConfiguration.uri.path == AppRoutes.splash.path;

  void _onRouteChanged() {
    final onSplash = _isSplash();
    if (onSplash == _onSplash) return;
    // Defer: GoRouterDelegate notifies during build, so setState now would
    // throw "setState() called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _onSplash = onSplash);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onSplash) return widget.child;
    return UpgradeAlert(
      // The dialog must use the router's Navigator (below this widget), else
      // showDialog throws "no Navigator in context".
      navigatorKey: _delegate.navigatorKey,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: false,
      // Mandatory update: tapping the scrim outside the dialog must NOT
      // dismiss it. Independent of the buttons above.
      barrierDismissible: false,
      // Native look: Material dialog on Android, Cupertino on iOS.
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      upgrader: Upgrader(
        durationUntilAlertAgain: Duration.zero,
      ),
      child: widget.child,
    );
  }
}
