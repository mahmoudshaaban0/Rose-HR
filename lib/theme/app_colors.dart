import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

interface class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    // Neutrals
    required this.surface,
    required this.surfaceDim,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerLowest,
    required this.surfaceVariant,

    // Text & Icons
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.textDisabled,
    required this.iconOnSurface,
    required this.iconOnSurfaceVariant,
    required this.iconSubtle,

    // Borders
    required this.outline,
    required this.outlineVariant,
    required this.strokeSubtle,

    // States
    required this.error,
    required this.errorContainer,
    required this.errorDark,
    required this.success,
    required this.successContainer,
    required this.successDark,
    required this.info,
    required this.infoContainer,
    required this.warning,
    required this.warningContainer,
    required this.warningDark,
    required this.warningAlt,

    // Overlays
    required this.scrim,
    required this.black,

    // Faded / Neutral Variants
    required this.fadedDark,
    required this.fadedBase,
    required this.fadedLight,
    required this.disabledColor,
  });

  factory AppColors.light() {
    return AppLightColors();
  }

  factory AppColors.dark() {
    return AppDarkColors();
  }

  // ===== Neutrals =====
  final Color surface;
  final Color surfaceDim;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerLowest;
  final Color surfaceVariant;

  // ===== Text & Icons =====
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color textDisabled;
  final Color iconOnSurface;
  final Color iconOnSurfaceVariant;
  final Color iconSubtle;

  // ===== Borders =====
  final Color outline;
  final Color outlineVariant;
  final Color strokeSubtle;

  // ===== States =====
  final Color error;
  final Color errorContainer;
  final Color errorDark;

  final Color success;
  final Color successContainer;
  final Color successDark;

  final Color info;
  final Color infoContainer;

  final Color warning;
  final Color warningContainer;
  final Color warningDark;
  final Color warningAlt;

  // ===== Overlays =====
  final Color scrim;
  final Color black;

  // ===== Faded / Neutral Variants =====
  final Color fadedDark;
  final Color fadedBase;
  final Color fadedLight;
  final Color disabledColor;
  @override
  ThemeExtension<AppColors> copyWith({
    Color? surface,
    Color? surfaceDim,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? surfaceContainerLowest,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? textDisabled,
    Color? iconOnSurface,
    Color? iconOnSurfaceVariant,
    Color? iconSubtle,
    Color? outline,
    Color? outlineVariant,
    Color? strokeSubtle,
    Color? error,
    Color? errorContainer,
    Color? errorDark,
    Color? success,
    Color? successContainer,
    Color? successDark,
    Color? info,
    Color? infoContainer,
    Color? warning,
    Color? warningContainer,
    Color? warningDark,
    Color? warningAlt,
    Color? scrim,
    Color? black,
    Color? fadedDark,
    Color? fadedBase,
    Color? fadedLight,
    Color? disabledColor,
  }) {
    return AppColors(
      surface: surface ?? this.surface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      textDisabled: textDisabled ?? this.textDisabled,
      iconOnSurface: iconOnSurface ?? this.iconOnSurface,
      iconOnSurfaceVariant: iconOnSurfaceVariant ?? this.iconOnSurfaceVariant,
      iconSubtle: iconSubtle ?? this.iconSubtle,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      strokeSubtle: strokeSubtle ?? this.strokeSubtle,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      errorDark: errorDark ?? this.errorDark,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      successDark: successDark ?? this.successDark,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      warningDark: warningDark ?? this.warningDark,
      warningAlt: warningAlt ?? this.warningAlt,
      scrim: scrim ?? this.scrim,
      black: black ?? this.black,
      fadedDark: fadedDark ?? this.fadedDark,
      fadedBase: fadedBase ?? this.fadedBase,
      fadedLight: fadedLight ?? this.fadedLight,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceContainerLow: Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerLowest: Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      iconOnSurface: Color.lerp(iconOnSurface, other.iconOnSurface, t)!,
      iconOnSurfaceVariant: Color.lerp(iconOnSurfaceVariant, other.iconOnSurfaceVariant, t)!,
      iconSubtle: Color.lerp(iconSubtle, other.iconSubtle, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      strokeSubtle: Color.lerp(strokeSubtle, other.strokeSubtle, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      errorDark: Color.lerp(errorDark, other.errorDark, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      successDark: Color.lerp(successDark, other.successDark, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      warningDark: Color.lerp(warningDark, other.warningDark, t)!,
      warningAlt: Color.lerp(warningAlt, other.warningAlt, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      black: Color.lerp(black, other.black, t)!,
      fadedDark: Color.lerp(fadedDark, other.fadedDark, t)!,
      fadedBase: Color.lerp(fadedBase, other.fadedBase, t)!,
      fadedLight: Color.lerp(fadedLight, other.fadedLight, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
    );
  }
}

@reopen
@protected
class AppLightColors extends AppColors {
  AppLightColors({
    // Neutrals / Surfaces
    super.surface = const Color(0xFFFFFFFF),
    super.surfaceDim = const Color(0xFFF5F7FA),
    super.onSurface = const Color(0xFF0E121B),
    super.onSurfaceVariant = const Color(0xFF99A0AE),
    super.textDisabled = const Color(0xFFCACFD8),
    super.iconOnSurface = const Color(0xFF0E121B),
    super.iconOnSurfaceVariant = const Color(0xFF99A0AE),
    super.iconSubtle = const Color(0xFF525866),
    super.outline = const Color(0xFF0E121B),
    super.outlineVariant = const Color(0xFFE1E4EA),
    super.strokeSubtle = const Color(0xFFE1E4EA),
    super.error = const Color(0xFFFB3748),
    super.errorContainer = const Color(0xFFFFEBEC),
    super.errorDark = const Color(0xFF681219),
    super.success = const Color(0xFF1FC16B),
    super.successContainer = const Color(0xFFE0FAEC),
    super.successDark = const Color(0xFF0B4627),
    super.info = const Color(0xFF335CFF),
    super.infoContainer = const Color(0xFFEBF1FF),
    super.warning = const Color(0xFFF6B51E),
    super.warningContainer = const Color(0xFFFFFAEB),
    super.warningDark = const Color(0xFF624C18),
    super.warningAlt = const Color(0xFFFA7319),

    // Overlays
    super.scrim = const Color(0x3D2B303B), // 24% opacity
    super.black = const Color(0xFF0E121B),

    // Faded / Neutral Variants
    super.fadedDark = const Color(0xFF0E121B),
    super.fadedBase = const Color(0xFF717784),
    super.fadedLight = const Color(0xFFF5F7FA),
    super.surfaceContainerLow = const Color(0xFFF5F7FA),
    super.surfaceContainerHigh = const Color(0xFFE1E4EA),
    super.surfaceContainerLowest = const Color(0xFFFFFFFF),
    super.surfaceVariant = const Color(0xFFCACFD8),
    super.disabledColor = const Color(0xFFCACFD8),
  });
}

@reopen
@protected
class AppDarkColors extends AppColors {
  AppDarkColors({
    // Neutrals / Surfaces
    super.surface = const Color(0xFF0E121B),
    super.surfaceDim = const Color(0xFF0E121B),
    super.onSurface = const Color(0xFFFFFFFF),
    super.onSurfaceVariant = const Color(0xFF99A0AE),
    super.textDisabled = const Color(0xFF525866),
    super.iconOnSurface = const Color(0xFFFFFFFF),
    super.iconOnSurfaceVariant = const Color(0xFFCACFD8),
    super.iconSubtle = const Color(0xFF99A0AE),
    super.outline = const Color(0xFFE1E4EA),
    super.outlineVariant = const Color(0xFF525866),
    super.strokeSubtle = const Color(0xFFE1E4EA),
    // States
    super.error = const Color(0xFFFB3748),
    super.errorContainer = const Color(0xFF681219),
    super.errorDark = const Color(0xFFFFEBEC),

    super.success = const Color(0xFF1FC16B),
    super.successContainer = const Color(0xFF0B4627),
    super.successDark = const Color(0xFFE0FAEC),

    super.info = const Color(0xFF335CFF),
    super.infoContainer = const Color(0xFF1A2E80),

    super.warning = const Color(0xFFF6B51E),
    super.warningContainer = const Color(0xFF624C18),
    super.warningDark = const Color(0xFFFFFAEB),
    super.warningAlt = const Color(0xFFFA7319),

    // Overlays
    super.scrim = const Color(0x3D0E121B), // 24% opacity black overlay
    super.black = const Color(0xFF000000),

    // Faded / Neutral Variants
    super.fadedDark = const Color(0xFF0E121B),
    super.fadedBase = const Color(0xFF525866),
    super.fadedLight = const Color(0xFFE1E4EA),
    super.surfaceContainerLow = const Color(0xFF181B25),
    super.surfaceContainerHigh = const Color(0xFF222530),
    super.surfaceContainerLowest = const Color(0xFF0E121B),
    super.surfaceVariant = const Color(0xFF717784),
    super.disabledColor = const Color(0xFF222530),
  });
}
