import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/account/presentation/widgets/account_menu_item.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.containerBackground,
      appBar: PrimaryAppBar(title: context.localizations.generalSettings),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.sm.h),
              child: Text(context.localizations.generalSettings, style: context.typography.medium16),
            ),
            const AppDivider(),
            AccountMenuItem(
              iconPath: Assets.vectorsLanguageIcon,
              title: context.localizations.language,
              onTap: () {},
            ),
            AccountMenuItem(
              iconPath: Assets.vectorsNotifications,
              title: context.localizations.notifications,
              subtitle: context.localizations.notificationsSubtitle,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
