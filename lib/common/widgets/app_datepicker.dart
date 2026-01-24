import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// A reusable Cupertino-style date picker component
///
/// Features:
/// - Displays a modal date picker in iOS style
/// - Supports customizable date range (min/max years)
/// - Handles timezone conversion
/// - Provides callbacks for date selection
///
/// Example:
/// ```dart
/// AppDatePicker.show(
///   context,
///   initialDate: DateTime.now(),
///   onDateConfirmed: (selectedDate) {
///     print('Selected: $selectedDate');
///   },
/// );
/// ```
class AppDatePicker {
  /// Shows a Cupertino-style date picker modal
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing the modal
  /// - [initialDate]: The initially selected date (defaults to current Egypt time)
  /// - [minimumYear]: Minimum selectable year (defaults to 100 years ago)
  /// - [maximumYear]: Maximum selectable year (defaults to current year)
  /// - [onDateChanged]: Optional callback triggered on each date scroll change
  /// - [onDateConfirmed]: Callback triggered when user confirms the date
  /// - [timezone]: Target timezone for date handling (defaults to Egypt)
  /// - [buttonText]: Custom text for the confirmation button (defaults to localized "done")
  static Future<void> show(
    BuildContext context, {
    required ValueChanged<DateTime> onDateConfirmed,
    DateTime? initialDate,
    int? minimumYear,
    int? maximumYear,
    ValueChanged<DateTime>? onDateChanged,
    AppTimezone timezone = AppTimezone.egypt,
    String? buttonText,
    CupertinoDatePickerMode? mode,
  }) async {
    var tempSelectedDate = initialDate ?? TimezoneHelper.now();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext modalContext) {
        return CupertinoActionSheet(
          actions: [
            Container(
              decoration: BoxDecoration(
                color: context.isLightMode ? null : context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
              ),
              height: 200.h,
              child: Localizations.override(
                context: modalContext,
                locale: const Locale('en', 'US'),
                child: CupertinoDatePicker(
                  maximumYear: maximumYear ?? DateTime.now().year,
                  minimumYear: minimumYear ?? (DateTime.now().year - 100),
                  onDateTimeChanged: (DateTime date) {
                    tempSelectedDate = date;
                    onDateChanged?.call(date);
                  },
                  initialDateTime: initialDate ?? TimezoneHelper.now(),
                  mode: mode ?? CupertinoDatePickerMode.date,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoButton(
            color: context.isLightMode ? null : context.colors.surfaceVariant,
            onPressed: () {
              Navigator.of(modalContext).pop();
              onDateConfirmed(tempSelectedDate);
            },
            child: Text(
              buttonText ?? context.localizations.done,
              style: context.typography.regular16,
            ),
          ),
        );
      },
    );
  }

  /// Shows a simple date picker without dark mode styling
  ///
  /// This is a lighter version suitable for simpler use cases
  static Future<void> showSimple(
    BuildContext context, {
    required ValueChanged<DateTime> onDateConfirmed,
    DateTime? initialDate,
    int? minimumYear,
    int? maximumYear,
    ValueChanged<DateTime>? onDateChanged,
    AppTimezone timezone = AppTimezone.egypt,
    String? buttonText,
    CupertinoDatePickerMode? mode,
  }) async {
    var tempSelectedDate = initialDate ?? TimezoneHelper.now();

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext modalContext) {
        return CupertinoActionSheet(
          actions: [
            SizedBox(
              height: 200.h,
              child: Localizations.override(
                context: modalContext,
                locale: const Locale('en', 'US'),
                child: CupertinoDatePicker(
                  maximumYear: maximumYear ?? DateTime.now().year,
                  minimumYear: minimumYear ?? (DateTime.now().year - 100),
                  onDateTimeChanged: (DateTime date) {
                    tempSelectedDate = date;
                    onDateChanged?.call(date);
                  },
                  initialDateTime: initialDate ?? TimezoneHelper.now(),
                  mode: mode ?? CupertinoDatePickerMode.date,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoButton(
            onPressed: () {
              Navigator.of(modalContext).pop();
              onDateConfirmed(tempSelectedDate);
            },
            child: Text(
              buttonText ?? context.localizations.done,
              style: context.typography.regular16,
            ),
          ),
        );
      },
    );
  }
}
