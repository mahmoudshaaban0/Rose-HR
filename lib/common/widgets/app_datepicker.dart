import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// {@template app_date_picker}
/// A reusable iOS-style date picker widget that displays in a bottom sheet.
/// Provides a callback with the selected date value.
/// {@endtemplate}
class AppDatePicker extends StatefulWidget {
  /// {@macro app_date_picker}
  const AppDatePicker({
    required this.onDateSelected,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.mode = CupertinoDatePickerMode.date,
    super.key,
  });

  /// Callback function that returns the selected date
  final ValueChanged<DateTime> onDateSelected;

  /// Initial date to display in the picker
  final DateTime? initialDate;

  /// Minimum selectable date
  final DateTime? minimumDate;

  /// Maximum selectable date
  final DateTime? maximumDate;

  /// Date picker mode (date, time, dateAndTime)
  final CupertinoDatePickerMode mode;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _DatePickerHeader(
            onCancel: () => Navigator.of(context).pop(),
            onDone: () {
              widget.onDateSelected(_selectedDate);
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: Localizations.override(
              context: context,
              locale: const Locale('en', 'US'),
              child: CupertinoDatePicker(
                mode: widget.mode,
                initialDateTime: _selectedDate,
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
                backgroundColor: context.colors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// {@template date_picker_header}
/// Header widget for the date picker with Cancel and Done buttons
/// {@endtemplate}
class _DatePickerHeader extends StatelessWidget {
  /// {@macro date_picker_header}
  const _DatePickerHeader({
    required this.onCancel,
    required this.onDone,
  });

  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colors.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DatePickerActionButton(
            label: context.localizations.cancel,
            onPressed: onCancel,
          ),
          _DatePickerActionButton(
            label: context.localizations.done,
            onPressed: onDone,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

/// {@template date_picker_action_button}
/// Action button widget used in the date picker header
/// {@endtemplate}
class _DatePickerActionButton extends StatelessWidget {
  /// {@macro date_picker_action_button}
  const _DatePickerActionButton({
    required this.label,
    required this.onPressed,
    this.isBold,
  });

  final String label;
  final VoidCallback onPressed;
  final bool? isBold;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Text(
        label,
        style: (isBold ?? false)
            ? context.typography.semiBold16.copyWith(
                color: context.colors.info,
              )
            : context.typography.regular16.copyWith(
                color: context.colors.info,
              ),
      ),
    );
  }
}

/// Extension to show the date picker as a modal bottom sheet
extension AppDatePickerExtension on BuildContext {
  /// Shows the iOS-style date picker in a modal bottom sheet
  Future<void> showAppDatePicker({
    required ValueChanged<DateTime> onDateSelected,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.date,
  }) {
    return showModalBottomSheet<void>(
      context: this,
      builder: (BuildContext context) {
        return AppDatePicker(
          onDateSelected: onDateSelected,
          initialDate: initialDate,
          minimumDate: minimumDate,
          maximumDate: maximumDate,
          mode: mode,
        );
      },
    );
  }
}
