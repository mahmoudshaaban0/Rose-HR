import 'package:flutter/material.dart';
import 'package:rose_hr/theme/app_text_buttons.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// {@template outline_text_button}
/// A custom outline text button widget that adapts to the platform.
/// {@endtemplate}
class OutlineTextButton extends AppTextButton {
  /// {@macro outline_text_button}
  const OutlineTextButton({
    required super.label,
    super.key,
    super.onTap,
    super.leading,
    super.trailing,
    super.appButtonSize,
    this.overriddenBorderColor,
  });

  final Color? overriddenBorderColor;

  @override
  Color backgroundColor(BuildContext context) {
    return overriddenBorderColor ?? context.colors.surfaceDim;
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
    return context.buttonTheme.primaryText;
  }

  @override
  BorderSide defaultBorder(BuildContext context) {
    return const BorderSide(color: Colors.transparent);
  }
}
