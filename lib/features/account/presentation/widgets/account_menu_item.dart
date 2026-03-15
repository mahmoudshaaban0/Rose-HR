import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// A list row for the account/HR section using [ListTile]: leading icon, title, subtitle, trailing chevron.
class AccountMenuItem extends StatelessWidget {
  const AccountMenuItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
    super.key,
    this.subtitle,
    this.showDivider = true,
  });

  final String iconPath;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
          ),
          horizontalTitleGap: AppSpacing.sm.w,
          leading: AppVectorGraphic(
            path: iconPath,
            width: 18.r,
            height: 18.r,
          ),
          title: Text(
            title,
            style: context.typography.medium16,
          ),
          subtitle: subtitle != null && subtitle!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    subtitle!,
                    style: context.typography.regular14.copyWith(
                      color: context.colors.iconSubtle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          trailing: Icon(CupertinoIcons.chevron_left, size: 18.r, color: context.colors.iconSubtle),
        ),
        if (showDivider) const AppDivider(),
      ],
    );
  }
}
