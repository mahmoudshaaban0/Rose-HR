import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// {@template app_text_field}
/// A customizable text field widget with various customization options.
/// {@endtemplate}
class AppTextField extends StatelessWidget {
  /// {@macro app_text_field}
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.helperText,
    this.errorText,
    this.suffixIcon,
    this.suffixIconConstraints = const BoxConstraints(minHeight: 24, minWidth: 40),
    this.prefixIcon,
    this.prefixIconConstraints = const BoxConstraints(minHeight: 24, minWidth: 40),
    this.autofillHints,
    this.onEditingComplete,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
    this.required = false,
    this.title,
    this.hintTextLabel,
    this.textInputAction,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The label text for the text field.
  final String? hintTextLabel;

  /// Whether the text field is enabled.
  final bool enabled;

  /// Whether the text field is obscured.
  final bool obscureText;

  /// Called when the text field value changes.
  final ValueChanged<String>? onChanged;

  /// The autovalidate mode for the text field.
  final AutovalidateMode autovalidateMode;

  /// The validator for the text field.
  final FormFieldValidator<String>? validator;

  /// The helper text for the text field.
  final String? helperText;

  /// The error text for the text field.
  final String? errorText;

  /// The suffix icon for the text field.
  final Widget? suffixIcon;

  /// The constraints for the suffix icon.
  final BoxConstraints? suffixIconConstraints;

  /// The prefix icon for the text field.
  final Widget? prefixIcon;

  /// The constraints for the prefix icon.
  final BoxConstraints? prefixIconConstraints;

  /// The autofillhints for app text field.
  final Iterable<String>? autofillHints;

  /// Called when the text field value completed.
  final VoidCallback? onEditingComplete;

  /// The input formatters for the text field.
  final List<TextInputFormatter>? inputFormatters;

  /// The keyboard type for the text field.
  final TextInputType? keyboardType;

  /// the maximum lines available in text field.
  final int maxLines;
  final bool required;
  final String? title;
  final String? hintText;
  final TextInputAction? textInputAction;
  // content padding
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // i want this to add a star if this filed is required or not K
        Row(
          children: [
            Text(title ?? '', style: context.typography.medium16),
            if (required) Text('*', style: context.typography.medium16.copyWith(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onEditingComplete: onEditingComplete,
          autofillHints: autofillHints,
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          validator: validator,
          maxLines: maxLines,
          style: WidgetStateTextStyle.resolveWith((states) {
            late final Color textColor;

            if (states.contains(WidgetState.error)) {
              textColor = context.inputTheme.focusedTextDefault;
            } else if (states.contains(WidgetState.focused)) {
              textColor = context.inputTheme.focusedTextDefault;
            } else if (states.contains(WidgetState.disabled)) {
              textColor = context.inputTheme.disabledText;
            } else {
              textColor = context.inputTheme.defaultText;
            }

            return context.inputTheme.inputPlaceHolder.textStyle.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'itfMirsalC',
            );
          }),
          cursorColor: context.inputTheme.focusedTextDefault,
          cursorHeight: 16,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            contentPadding: contentPadding,
            hintText: hintTextLabel,
            hintStyle: WidgetStateTextStyle.resolveWith((states) {
              late final Color textColor;

              textColor = context.colors.onSurfaceVariant;

              return context.inputTheme.inputPlaceHolder.textStyle.copyWith(
                color: textColor,
                fontSize: 16,
                fontFamily: 'itfMirsalC',
              );
            }),
            labelStyle: WidgetStateTextStyle.resolveWith((states) {
              late final Color textColor;

              if (states.contains(WidgetState.error)) {
                textColor = context.inputTheme.errorTextDefault;
              } else if (states.contains(WidgetState.focused)) {
                textColor = context.inputTheme.focusedOnBrand;
              } else if (states.contains(WidgetState.disabled)) {
                textColor = context.inputTheme.disabledText;
              } else {
                textColor = context.inputTheme.defaultText;
              }

              return context.inputTheme.inputPlaceHolder.textStyle.copyWith(
                color: textColor,
                fontSize: 16,
                fontFamily: 'itfMirsalC',
              );
            }),
            floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
              late final Color textColor;

              if (states.contains(WidgetState.error)) {
                textColor = context.inputTheme.errorTextDefault;
              } else if (states.contains(WidgetState.focused)) {
                textColor = context.inputTheme.focusedOnBrand;
              } else {
                textColor = context.inputTheme.defaultText;
              }

              return context.inputTheme.inputPlaceHolder.textStyle.copyWith(color: textColor);
            }),
            filled: true,
            fillColor: enabled ? context.colors.surface : context.colors.surfaceContainerHigh,
            border: WidgetStateInputBorder.resolveWith((states) {
              late final Color borderColor;

              if (states.contains(WidgetState.error)) {
                borderColor = context.inputTheme.borderError;
              } else if (states.contains(WidgetState.focused)) {
                borderColor = context.colors.fadedDark;
              } else if (states.contains(WidgetState.disabled)) {
                borderColor = context.colors.surfaceContainerHigh;
              } else if (states.contains(WidgetState.hovered)) {
                borderColor = context.inputTheme.borderHover;
              } else {
                borderColor = context.colors.outlineVariant;
              }

              return OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide(color: borderColor),
              );
            }),
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            helperText: helperText,
            helperStyle: WidgetStateTextStyle.resolveWith((states) {
              late final Color textColor;

              if (states.contains(WidgetState.error)) {
                textColor = context.inputTheme.errorTextDefault;
              } else if (states.contains(WidgetState.focused)) {
                textColor = context.inputTheme.focusedOnBrand;
              } else if (states.contains(WidgetState.disabled)) {
                textColor = context.inputTheme.disabledText;
              } else {
                textColor = context.inputTheme.defaultText;
              }

              return context.inputTheme.inputPlaceHolder.textStyle.copyWith(color: textColor);
            }),
            errorText: errorText,
            errorStyle: context.inputTheme.inputPlaceHolder.textStyle.copyWith(
              color: context.inputTheme.errorTextDefault,
              fontSize: 12,
              fontFamily: 'itfMirsalC',
            ),

            suffixIcon: suffixIcon != null ? FittedBox(fit: BoxFit.scaleDown, child: suffixIcon) : null,
            prefixIcon: prefixIcon != null ? FittedBox(fit: BoxFit.scaleDown, child: prefixIcon) : null,
            suffixIconConstraints: suffixIconConstraints,
            prefixIconConstraints: prefixIconConstraints,
          ),
        ),
      ],
    );
  }
}

extension on Color {
  TextStyle get textStyle => TextStyle(color: this);
}
