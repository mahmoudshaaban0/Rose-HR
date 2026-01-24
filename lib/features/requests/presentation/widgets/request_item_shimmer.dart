import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class RequestItemShimmer extends StatelessWidget {
  const RequestItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceVariant,
      highlightColor: context.colors.containerBackground,
      child: Container(
        height: 300.h,
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: context.colors.containerBackground,
          borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and subtitle shimmer
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                        ),
                        width: 200.w,
                        height: 20.h,
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      Container(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                        ),
                        width: 150.w,
                        height: 16.h,
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                  ),
                  width: 24.w,
                  height: 24.h,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            // Divider
            Container(
              height: 1.h,
              width: double.infinity,
              color: context.colors.surfaceVariant,
            ),
            SizedBox(height: AppSpacing.md.h),
            // Request number shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                  ),
                  width: 100.w,
                  height: 16.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                  ),
                  width: 80.w,
                  height: 16.h,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            // Request status shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                  ),
                  width: 100.w,
                  height: 16.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.md.r),
                  ),
                  width: 100.w,
                  height: 28.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
