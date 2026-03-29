import 'package:flutter/material.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/features/account/presentation/widgets/account_menu_item.dart';
import 'package:rose_hr/features/general_settings/presentation/widgets/notifications_settings_bottom_sheet.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Settings row that opens notification toggles bottom sheet.
class GeneralSettingsNotificationsTile extends StatelessWidget {
  const GeneralSettingsNotificationsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountMenuItem(
      iconPath: Assets.vectorsNotifications,
      title: context.localizations.notifications,
      subtitle: context.localizations.notificationsSubtitle,
      onTap: () => NotificationsSettingsBottomSheet.show(context),
    );
  }
}
