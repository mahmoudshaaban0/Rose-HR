// inhereted from InheritedWidget

import 'package:flutter/material.dart';
import 'package:rose_hr/theme/app_theme.dart';

class AppThemeScope extends InheritedWidget {
  const AppThemeScope({required super.child, required this.theme, required this.themeMode, super.key});
  final AppTheme theme;
  final ThemeMode themeMode;

  static AppThemeScope? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(result != null, 'AppThemeScope not found in context');
    return result;
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) => true;
}
