import 'package:flutter/material.dart';
import 'package:rose_hr/l10n/app_localizations.dart';
import 'package:rose_hr/theme/app_button.dart';
import 'package:rose_hr/theme/app_colors.dart';
import 'package:rose_hr/theme/app_input.dart';
import 'package:rose_hr/theme/app_typography.dart';

/// An extension on [BuildContext] that provides access to the current theme.
extension ThemeExt on BuildContext {
  /// The current theme.
  ThemeData get theme => Theme.of(this);

  // check is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // check is light mode
  bool get isLightMode => theme.brightness == Brightness.light;

  AppColors get colors => theme.extension<AppColors>()!;

  AppTypography get typography => theme.extension<AppTypography>()!;

  AppInputTheme get inputTheme => theme.extension<AppInputTheme>()!;

  ///the current button theme
  AppButtonTheme get buttonTheme => theme.extension<AppButtonTheme>()!;

  AppLocalizations get localizations => AppLocalizations.of(this);
}
