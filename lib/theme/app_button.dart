import 'package:flutter/material.dart';
import 'package:rose_hr/theme/app_colors.dart';

/// {@template app_button_theme}
/// Theme class which provides configuration of buttons
/// {@endtemplate}
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  /// {@macro app_button_theme}
  const AppButtonTheme({
    required this.primaryText,
    required this.primaryDefault,
    required this.primaryHover,
    required this.primaryFocused,
    required this.secondaryText,
    required this.secondaryDefault,
    required this.secondaryHover,
    required this.secondaryFocused,
    required this.primaryDisabled,
  });

  /// {@macro app_button_theme}
  factory AppButtonTheme.light(AppColors colors) {
    return AppButtonTheme(
      primaryText: colors.onSurface,
      primaryDefault: colors.black,
      primaryHover: colors.info.withValues(alpha: 0.8),
      primaryFocused: colors.info.withValues(alpha: 0.6),
      secondaryText: colors.onSurface,
      secondaryDefault: colors.black,
      secondaryHover: colors.info.withValues(alpha: 0.8),
      secondaryFocused: colors.info.withValues(alpha: 0.6),
      primaryDisabled: colors.onSurface,
    );
  }

  /// {@macro app_button_theme}
  factory AppButtonTheme.dark(AppColors colors) {
    return AppButtonTheme(
      primaryText: colors.onSurface,
      primaryDefault: colors.black,
      primaryHover: colors.info.withValues(alpha: 0.8),
      primaryFocused: colors.info.withValues(alpha: 0.6),
      secondaryText: colors.onSurface,
      secondaryDefault: colors.black,
      secondaryHover: colors.info.withValues(alpha: 0.8),
      secondaryFocused: colors.info.withValues(alpha: 0.6),
      primaryDisabled: colors.onSurface,
    );
  }

  final Color primaryText;
  final Color primaryDefault;
  final Color primaryHover;
  final Color primaryFocused;
  final Color secondaryText;
  final Color secondaryDefault;
  final Color secondaryHover;
  final Color secondaryFocused;
  final Color primaryDisabled;
  @override
  ThemeExtension<AppButtonTheme> copyWith({
    Color? primaryText,
    Color? primaryDefault,
    Color? primaryHover,
    Color? primaryFocused,
  }) {
    return AppButtonTheme(
      primaryText: primaryText ?? this.primaryText,
      primaryDefault: primaryDefault ?? this.primaryDefault,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryFocused: primaryFocused ?? this.primaryFocused,
      secondaryText: secondaryText,
      secondaryDefault: secondaryDefault,
      secondaryHover: secondaryHover,
      secondaryFocused: secondaryFocused,
      primaryDisabled: primaryDisabled,
    );
  }

  @override
  ThemeExtension<AppButtonTheme> lerp(
    covariant ThemeExtension<AppButtonTheme>? other,
    double t,
  ) {
    if (other is! AppButtonTheme) {
      return this;
    }

    return AppButtonTheme(
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      primaryDefault: Color.lerp(primaryDefault, other.primaryDefault, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryFocused: Color.lerp(primaryFocused, other.primaryFocused, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      secondaryDefault: Color.lerp(secondaryDefault, other.secondaryDefault, t)!,
      secondaryHover: Color.lerp(secondaryHover, other.secondaryHover, t)!,
      secondaryFocused: Color.lerp(secondaryFocused, other.secondaryFocused, t)!,
      primaryDisabled: Color.lerp(primaryDisabled, other.primaryDisabled, t)!,
    );
  }
}
