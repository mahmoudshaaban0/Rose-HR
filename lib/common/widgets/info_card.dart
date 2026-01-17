import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
    this.prefixIcon,
    this.showArrow = true,
    super.key,
  });
  final String title;
  final String subtitle;
  final String value;
  final VoidCallback? onTap;
  final String? prefixIcon;
  final bool showArrow;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.typography.medium16),
        SizedBox(height: AppSpacing.sm.h),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap ?? () {},
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.h),
              decoration: BoxDecoration(
                color: context.colors.containerBackground,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                border: Border.all(color: context.colors.dividerColor),
              ),
              child: Row(
                mainAxisAlignment: prefixIcon != null ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                spacing: AppSpacing.md.w,
                children: [
                  if (prefixIcon != null) AppVectorGraphic(path: prefixIcon!, width: 24.r, height: 24.r),
                  Text(subtitle, style: context.typography.regular16.copyWith(color: context.colors.onSurfaceVariant)),
                  if (prefixIcon != null) const Spacer(),
                  if (showArrow) Icon(Icons.keyboard_arrow_down_outlined, size: 16, color: context.colors.iconSubtle),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
