import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

typedef IconBuilder = Widget Function(Color iconColor);

abstract class AppTextButton extends StatelessWidget {
  /// {@macro app_text_button}
  const AppTextButton({
    required this.label,
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.appButtonSize = AppButtonSize.medium,
  });

  /// The label for the text button.
  final String label;

  /// The callback function for the text button.
  final VoidCallback? onTap;

  /// The leading icon for the text button.
  final IconBuilder? leading;

  /// The trailing icon for the text button.
  final IconBuilder? trailing;

  /// The size of the text button.
  final AppButtonSize appButtonSize;

  /// The background color for the text button.
  Color backgroundColor(BuildContext context);

  /// The focus color for the text button.
  Color focusColor(BuildContext context);

  /// The hover color for the text button.
  Color hoverColor(BuildContext context);

  /// The disabled color for the text button.
  Color disabledColor(BuildContext context);

  /// The text color for the text button.
  Color textColor(BuildContext context);

  /// The disabled text color for the text button.
  Color disabledTextColor(BuildContext context) {
    return context.colors.textDisabled;
  }

  /// The default border for the text button.
  BorderSide defaultBorder(BuildContext context) => BorderSide.none;

  /// The focused border for the text button.
  BorderSide focusedBorder(BuildContext context) => BorderSide.none;

  /// The hover border for the text button.
  BorderSide hoverBorder(BuildContext context) => BorderSide.none;

  /// The disabled border for the text button.
  BorderSide disabledBorder(BuildContext context) => BorderSide.none;

  @override
  Widget build(BuildContext context) {
    final betweenSpace = switch (appButtonSize) {
      AppButtonSize.small || AppButtonSize.xSmall || AppButtonSize.medium => AppSpacing.xs,
      AppButtonSize.large || AppButtonSize.xlarge => AppSpacing.sm,
      AppButtonSize.xxLarge => AppSpacing.lg,
    };

    final inputTextColor = WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledTextColor(context);
        }

        return textColor(context);
      },
    );

    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor(context);
            }

            if (states.contains(WidgetState.hovered)) {
              return hoverColor(context);
            }

            if (states.contains(WidgetState.focused)) {
              return focusColor(context);
            }

            if (states.contains(WidgetState.pressed)) {
              return backgroundColor(context);
            }

            return backgroundColor(context);
          },
        ),
        shape: WidgetStateProperty.resolveWith(
          (states) {
            final shape = RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSpacing.xxl.r)),
            );

            if (states.contains(WidgetState.disabled)) {
              return shape.copyWith(side: disabledBorder(context));
            }

            if (states.contains(WidgetState.focused)) {
              return shape.copyWith(side: focusedBorder(context));
            }

            if (states.contains(WidgetState.hovered)) {
              return shape.copyWith(side: hoverBorder(context));
            }

            if (states.contains(WidgetState.pressed)) {
              return shape.copyWith(side: focusedBorder(context));
            }

            return shape.copyWith(side: defaultBorder(context));
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor(context);
            }

            if (states.contains(WidgetState.hovered)) {
              return hoverColor(context);
            }

            if (states.contains(WidgetState.focused)) {
              return focusColor(context);
            }

            if (states.contains(WidgetState.pressed)) {
              return backgroundColor(context);
            }

            return backgroundColor(context);
          },
        ),
        foregroundColor: inputTextColor,
        fixedSize: WidgetStateProperty.all(
          switch (appButtonSize) {
            AppButtonSize.small || AppButtonSize.xSmall => const Size(double.infinity, 36),
            AppButtonSize.medium => const Size(double.infinity, 40),
            AppButtonSize.large => const Size(double.infinity, 44),
            AppButtonSize.xlarge => const Size(double.infinity, 48),
            AppButtonSize.xxLarge => const Size(double.infinity, 56),
          },
        ),
        padding: WidgetStateProperty.all(
          switch (appButtonSize) {
            AppButtonSize.small || AppButtonSize.xSmall => const EdgeInsets.symmetric(horizontal: 12),
            AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16),
            AppButtonSize.large => const EdgeInsets.symmetric(horizontal: 16),
            AppButtonSize.xlarge => const EdgeInsets.symmetric(horizontal: 20),
            AppButtonSize.xxLarge => const EdgeInsets.symmetric(horizontal: 38),
          },
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!(
              onTap != null ? textColor(context) : disabledTextColor(context),
            ),
            SizedBox(width: betweenSpace),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: Text(
              label,
              style:
                  (switch (appButtonSize) {
                    AppButtonSize.small || AppButtonSize.xSmall => context.typography.regular16,
                    AppButtonSize.medium => context.typography.regular18,
                    AppButtonSize.large => context.typography.regular22,
                    AppButtonSize.xlarge => context.typography.bold28,
                    AppButtonSize.xxLarge => context.typography.medium18,
                  }).copyWith(
                    color: onTap != null ? textColor(context) : disabledTextColor(context),
                  ),
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: betweenSpace),
            trailing!(
              onTap != null ? textColor(context) : disabledTextColor(context),
            ),
          ],
        ],
      ),
    );
  }
}
