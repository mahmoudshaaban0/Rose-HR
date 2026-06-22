import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/routing/app_router.dart';
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
          // dialog. Disabling "Ignore" and "Later" makes the update
          // mandatory — the only action is "Update Now", which sends the
          // user to the store.
          builder: (context, child) => UpgradeAlert(
            showIgnore: false,
            showLater: false,
            // Native look: Material dialog on Android, Cupertino on iOS.
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            upgrader: Upgrader(
              durationUntilAlertAgain: Duration.zero,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
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
