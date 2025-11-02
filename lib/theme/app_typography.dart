// {@template app_typography}
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rose_hr/theme/app_colors.dart';

/// Theme class which provides configuration of [TextStyle]
interface class AppTypography extends ThemeExtension<AppTypography> {
  /// {@macro app_typography}
  AppTypography({
    required this.regular12,
    required this.regular14,
    required this.regular16,
    required this.regular18,
    required this.regular22,
    required this.medium12,
    required this.medium16,
    required this.medium18,
    required this.medium22,
    required this.bold16,
    required this.bold18,
    required this.bold22,
    required this.bold28,
    required this.buttonText,
    required this.semiBold16,
    required this.semiBold18,
    required this.semiBold22,
    required this.semiBold28,
  });

  factory AppTypography.dark(AppColors colors) => _AppTypographyDark(colors);
  factory AppTypography.light(AppColors colors) => _AppTypographyLight(colors);

  // Regular
  final TextStyle regular12;
  final TextStyle regular14;
  final TextStyle regular16;
  final TextStyle regular18;
  final TextStyle regular22;

  // Medium
  final TextStyle medium12;
  final TextStyle medium16;
  final TextStyle medium18;
  final TextStyle medium22;

  // Bold
  final TextStyle bold16;
  final TextStyle bold18;
  final TextStyle bold22;
  final TextStyle bold28;

  // SemiBold
  final TextStyle semiBold16;
  final TextStyle semiBold18;
  final TextStyle semiBold22;
  final TextStyle semiBold28;

  final TextStyle buttonText;

  @override
  ThemeExtension<AppTypography> copyWith({
    TextStyle? regular12,
    TextStyle? regular14,
    TextStyle? regular16,
    TextStyle? regular18,
    TextStyle? regular22,
    TextStyle? medium12,
    TextStyle? medium16,
    TextStyle? medium18,
    TextStyle? medium22,
    TextStyle? bold16,
    TextStyle? bold18,
    TextStyle? bold22,
    TextStyle? bold28,
    TextStyle? semiBold16,
    TextStyle? semiBold18,
    TextStyle? semiBold22,
    TextStyle? semiBold28,
    TextStyle? buttonText,
  }) {
    return AppTypography(
      regular12: regular12 ?? this.regular12,
      regular14: regular14 ?? this.regular14,
      regular16: regular16 ?? this.regular16,
      regular18: regular18 ?? this.regular18,
      regular22: regular22 ?? this.regular22,
      medium12: medium12 ?? this.medium12,
      medium16: medium16 ?? this.medium16,
      medium18: medium18 ?? this.medium18,
      medium22: medium22 ?? this.medium22,
      bold16: bold16 ?? this.bold16,
      bold18: bold18 ?? this.bold18,
      bold22: bold22 ?? this.bold22,
      bold28: bold28 ?? this.bold28,
      semiBold16: semiBold16 ?? this.semiBold16,
      semiBold18: semiBold18 ?? this.semiBold18,
      semiBold22: semiBold22 ?? this.semiBold22,
      semiBold28: semiBold28 ?? this.semiBold28,
      buttonText: buttonText ?? this.buttonText,
    );
  }

  @override
  ThemeExtension<AppTypography> lerp(
    covariant ThemeExtension<AppTypography>? other,
    double t,
  ) {
    if (other is! AppTypography) return this;

    return AppTypography(
      regular12: TextStyle.lerp(regular12, other.regular12, t)!,
      regular14: TextStyle.lerp(regular14, other.regular14, t)!,
      regular16: TextStyle.lerp(regular16, other.regular16, t)!,
      regular18: TextStyle.lerp(regular18, other.regular18, t)!,
      regular22: TextStyle.lerp(regular22, other.regular22, t)!,
      medium12: TextStyle.lerp(medium12, other.medium12, t)!,
      medium16: TextStyle.lerp(medium16, other.medium16, t)!,
      medium18: TextStyle.lerp(medium18, other.medium18, t)!,
      medium22: TextStyle.lerp(medium22, other.medium22, t)!,
      bold16: TextStyle.lerp(bold16, other.bold16, t)!,
      bold18: TextStyle.lerp(bold18, other.bold18, t)!,
      bold22: TextStyle.lerp(bold22, other.bold22, t)!,
      bold28: TextStyle.lerp(bold28, other.bold28, t)!,
      semiBold16: TextStyle.lerp(semiBold16, other.semiBold16, t)!,
      semiBold18: TextStyle.lerp(semiBold18, other.semiBold18, t)!,
      semiBold22: TextStyle.lerp(semiBold22, other.semiBold22, t)!,
      semiBold28: TextStyle.lerp(semiBold28, other.semiBold28, t)!,
      buttonText: TextStyle.lerp(buttonText, other.buttonText, t)!,
    );
  }
}

@reopen
class _AppTypographyLight extends AppTypography {
  _AppTypographyLight(AppColors colors)
    : super(
        // Regular
        regular12: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular14: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),

        // Medium
        medium12: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        medium16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        medium18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        medium22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),

        // Bold
        bold16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        bold18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        bold22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        bold28: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        buttonText: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold28: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
      );
}

@reopen
class _AppTypographyDark extends AppTypography {
  _AppTypographyDark(AppColors colors)
    : super(
        // Regular
        regular12: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular14: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        regular22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),

        // Medium
        medium12: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        medium16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        medium18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        medium22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),

        // Bold
        bold16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        bold18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        bold22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        bold28: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        buttonText: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold16: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold18: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold22: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
        semiBold28: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          fontFamily: 'GraphikArabic',
        ),
      );
}
