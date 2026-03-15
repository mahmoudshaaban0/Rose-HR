import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Modern SnackBar service following Material Design 3 guidelines and best UX practices
///
/// Best Practices Implemented:
/// - Error messages appear at the TOP for maximum visibility
/// - Success/Info/Warning messages appear at the BOTTOM (Material Design standard)
/// - Short duration for success/info (4 seconds)
/// - Longer duration for errors/warnings (6 seconds)
/// - Uses app theme colors and typography
/// - Includes icons for better visual communication
/// - Rounded corners for modern look
/// - Proper padding and margins
/// - Action button support for important actions
/// - Close icon for manual dismissal
class SnackbarService {
  SnackbarService._();

  /// Default duration for success and info messages (4 seconds)
  static const Duration _shortDuration = Duration(seconds: 4);

  /// Default duration for error and warning messages (6 seconds)
  static const Duration _longDuration = Duration(seconds: 6);

  /// Show a success message
  ///
  /// [message] - The message to display
  /// [context] - The BuildContext to show the snackbar in
  /// [duration] - Optional custom duration (defaults to 4 seconds)
  /// [action] - Optional action button
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: _SnackbarType.success,
      duration: duration ?? _shortDuration,
      action: action,
    );
  }

  /// Show an error message
  ///
  /// [message] - The message to display
  /// [context] - The BuildContext to show the snackbar in
  /// [duration] - Optional custom duration (defaults to 6 seconds)
  /// [action] - Optional action button (e.g., "Retry")
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: _SnackbarType.error,
      duration: duration ?? _longDuration,
      action: action,
    );
  }

  /// Show a warning message
  ///
  /// [message] - The message to display
  /// [context] - The BuildContext to show the snackbar in
  /// [duration] - Optional custom duration (defaults to 6 seconds)
  /// [action] - Optional action button
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: _SnackbarType.warning,
      duration: duration ?? _longDuration,
      action: action,
    );
  }

  /// Show an info message
  ///
  /// [message] - The message to display
  /// [context] - The BuildContext to show the snackbar in
  /// [duration] - Optional custom duration (defaults to 4 seconds)
  /// [action] - Optional action button
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    _show(
      context: context,
      message: message,
      type: _SnackbarType.info,
      duration: duration ?? _shortDuration,
      action: action,
    );
  }

  /// Show a custom snackbar with full control
  ///
  /// [context] - The BuildContext to show the snackbar in
  /// [message] - The message to display
  /// [backgroundColor] - Custom background color
  /// [textColor] - Custom text color
  /// [icon] - Custom icon
  /// [duration] - Custom duration
  /// [action] - Optional action button
  static void showCustom({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    Duration duration = _shortDuration,
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: textColor,
              size: 20.r,
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Text(
              message,
              style: context.typography.medium14.copyWith(
                color: textColor,
              ),
              softWrap: true,
              maxLines: 5,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      action: action,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Hide the current snackbar if one is showing
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Internal method to show snackbar with consistent styling
  static void _show({
    required BuildContext context,
    required String message,
    required _SnackbarType type,
    required Duration duration,
    SnackBarAction? action,
  }) {
    final colors = context.colors;
    final Color backgroundColor;
    final Color textColor;
    final IconData icon;

    switch (type) {
      case _SnackbarType.success:
        backgroundColor = colors.success;
        textColor = colors.white;
        icon = Icons.check_circle_outline;
      case _SnackbarType.error:
        backgroundColor = colors.error;
        textColor = colors.white;
        icon = Icons.error_outline;
      case _SnackbarType.warning:
        backgroundColor = colors.warning;
        textColor = colors.black;
        icon = Icons.warning_amber_outlined;
      case _SnackbarType.info:
        backgroundColor = colors.info;
        textColor = colors.white;
        icon = Icons.info_outline;
    }

    // Errors appear at the top for better visibility
    final isError = type == _SnackbarType.error;

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: context.typography.medium14.copyWith(
                color: textColor,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: isError ? true : false,
      margin: isError
          ? EdgeInsets.only(
              bottom: message.length > 70
                  ? MediaQuery.of(context).size.height - 200.h
                  : MediaQuery.of(context).size.height - 150.h,
              left: 10.w,
              right: 10.w,
            )
          : EdgeInsets.all(16.r),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      action: action?.copyWith(
        textColor: textColor,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

/// Internal enum for snackbar types
enum _SnackbarType {
  success,
  error,
  warning,
  info,
}

/// Extension to create action with custom text color
extension on SnackBarAction {
  SnackBarAction copyWith({Color? textColor}) {
    return SnackBarAction(
      label: label,
      onPressed: onPressed,
      textColor: textColor ?? this.textColor,
    );
  }
}
