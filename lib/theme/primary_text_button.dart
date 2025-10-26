import 'package:flutter/material.dart';
import 'package:rose_hr/theme/app_text_buttons.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// {@template primary_text_button}
/// A custom primary text button widget that adapts to the platform.
/// {@endtemplate}
class PrimaryTextButton extends AppTextButton {
  /// {@macro primary_text_button}
  const PrimaryTextButton({
    required super.label,
    super.key,
    super.onTap,
    super.leading,
    super.trailing,
    super.appButtonSize,
    this.overriddenBackgroundColor,
  });

  final Color? overriddenBackgroundColor;

  @override
  Color backgroundColor(BuildContext context) {
    return overriddenBackgroundColor ?? context.buttonTheme.primaryText;
  }

  @override
  Color disabledColor(BuildContext context) {
    return context.buttonTheme.primaryDisabled;
  }

  @override
  Color focusColor(BuildContext context) {
    return context.buttonTheme.primaryFocused;
  }

  @override
  Color hoverColor(BuildContext context) {
    return context.buttonTheme.primaryHover;
  }

  @override
  Color textColor(BuildContext context) {
    return context.isLightMode ? context.colors.surface : context.colors.surface;
  }
}
