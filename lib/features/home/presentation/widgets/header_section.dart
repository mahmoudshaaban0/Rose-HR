import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, this.hideNotificationIcon = false});
  final bool hideNotificationIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        AppManager.instance.getString(AppStrings.name) ?? context.localizations.noName,
        style: context.typography.semiBold18,
      ),
      subtitle: Text(
        AppManager.instance.getString(AppStrings.email) ?? context.localizations.noEmail,
        style: context.typography.regular14,
      ),
      leading: const AppVectorGraphic(path: Assets.vectorsUserPlaceHolder),
      trailing: hideNotificationIcon
          ? null
          : IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: context.colors.outlineVariant),
                  borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                ),
              ),
              onPressed: () {
                context.pushNamed(AppRoutes.notifications.name);
              },
              icon: AppVectorGraphic(
                width: 18.r,
                height: 18.r,
                path: Assets.vectorsNotifications,
                color: context.isDarkMode ? ColorFilter.mode(context.colors.white, BlendMode.srcIn) : null,
              ),
            ),
    );
  }
}
