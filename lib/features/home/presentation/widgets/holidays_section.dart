import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class HolidaysSection extends StatelessWidget {
  const HolidaysSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      ),
      child: Column(
        spacing: AppSpacing.md.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.localizations.accuredLeaveBalance,
            style: context.typography.semiBold16,
          ),
          const AppDivider(),
          Container(
            alignment: Alignment.center,
            height: 100.h,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '0 ايام',
                  style: context.typography.semiBold16,
                ),
                Text(
                  context.localizations.accuredLeaveBalance,
                  style: context.typography.regular14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
