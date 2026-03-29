import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_switch.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Bottom sheet: toggles for app notifications and requests/replies notifications.
class NotificationsSettingsBottomSheet extends StatefulWidget {
  const NotificationsSettingsBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return BottomSheetWrapper(
      initialSize: 0.25.h,
      maxChildSize: 0.38.h,
      removeAutoScroll: true,
      disableDrag: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
        child: const NotificationsSettingsBottomSheet(),
      ),
    ).callSheet(context);
  }

  @override
  State<NotificationsSettingsBottomSheet> createState() => _NotificationsSettingsBottomSheetState();
}

class _NotificationsSettingsBottomSheetState extends State<NotificationsSettingsBottomSheet> {
  late bool _appNotificationsEnabled;
  late bool _requestsNotificationsEnabled;

  @override
  void initState() {
    super.initState();
    _appNotificationsEnabled = AppManager.instance.getBool(key: AppStrings.notificationsAppEnabled) ?? true;
    _requestsNotificationsEnabled = AppManager.instance.getBool(key: AppStrings.notificationsRequestsEnabled) ?? true;
  }

  Future<void> _setAppNotifications(bool value) async {
    await AppManager.instance.setBool(
      AppStrings.notificationsAppEnabled,
      value: value,
    );
    setState(() => _appNotificationsEnabled = value);
  }

  Future<void> _setRequestsNotifications(bool value) async {
    await AppManager.instance.setBool(
      AppStrings.notificationsRequestsEnabled,
      value: value,
    );
    setState(() => _requestsNotificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.localizations.notifications,
          style: context.typography.semiBold18,
        ),
        SizedBox(height: AppSpacing.lg.h),
        _NotificationToggleRow(
          title: context.localizations.appNotifications,
          value: _appNotificationsEnabled,
          onChanged: _setAppNotifications,
        ),
        const AppDivider(),
        _NotificationToggleRow(
          title: context.localizations.requestsAndRepliesNotifications,
          value: _requestsNotificationsEnabled,
          onChanged: _setRequestsNotifications,
        ),
      ],
    );
  }
}

class _NotificationToggleRow extends StatelessWidget {
  const _NotificationToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md.h,
        horizontal: AppSpacing.xs.r,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.typography.medium16,
            ),
          ),
          AppSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
