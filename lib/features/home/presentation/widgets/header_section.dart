import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        context.localizations.home,
        style: context.typography.regular14,
      ),
      subtitle: Text(
        context.localizations.home,
        style: context.typography.semiBold18,
      ),
      leading: const AppVectorGraphic(path: Assets.vectorsUserPlaceHolder),
      trailing: IconButton(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: context.colors.outlineVariant),
            borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
          ),
        ),
        onPressed: () {
          ThemeScopeWidget.of(context)?.changeTo(ThemeMode.light);
        },
        icon: AppVectorGraphic(
          path: Assets.vectorsNotifications,
          color: ColorFilter.mode(context.colors.onSurface, BlendMode.srcIn),
        ),
      ),
    );
  }
}
