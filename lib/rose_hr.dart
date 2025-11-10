import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/routing/app_router.dart';
import 'package:rose_hr/l10n/app_localizations.dart';
import 'package:rose_hr/theme/app_theme_scope.dart';

class RoseHr extends StatelessWidget {
  const RoseHr({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeScope.of(context);
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
          locale: const Locale(AppStrings.arabic),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          theme: ThemeData(
            scaffoldBackgroundColor: theme.theme.colors.surface,
            extensions: [
              theme.theme.colors,
              theme.theme.typography,
              theme.theme.inputTheme,
              theme.theme.buttonTheme,
            ],
          ),
          darkTheme: ThemeData(
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
