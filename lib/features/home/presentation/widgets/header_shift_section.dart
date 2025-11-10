import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/home/presentation/widgets/header_section.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class HeaderAndShiftSection extends StatelessWidget {
  const HeaderAndShiftSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: AppSpacing.xxxl.r),
      color: context.colors.containerBackground,
      child: Column(
        children: [
          const HeaderSection(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
              color: context.colors.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md.h,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '24 فبراير 2025 | 09:13 صباحًا',
                      style: context.typography.regular14,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                        border: Border.all(color: context.colors.containerBorder),
                      ),
                      child: Row(
                        children: [
                          const AppVectorGraphic(path: Assets.vectorsLocationIcon),
                          SizedBox(width: AppSpacing.xs.r),
                          Text(
                            'الرياض',
                            style: context.typography.medium12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: context.localizations.timeLeftUntilYourShiftEnds,
                        style: context.typography.regular16,
                      ),
                      TextSpan(
                        text: ' 9:00 ',
                        style: context.typography.semiBold28,
                      ),
                      TextSpan(
                        text: context.localizations.hours,
                        style: context.typography.regular16,
                      ),
                    ],
                  ),
                ),
                PrimaryTextButton(
                  appButtonSize: AppButtonSize.xxLarge,
                  label: context.localizations.clockInClockOut,
                  onTap: () {
                    BottomSheetWrapper(
                      initialSize: 0.35.h,
                      maxChildSize: 0.35.h,
                      minChildSize: 0.35.h.sp,
                      removeAutoScroll: true,
                      disableDrag: true,
                      useRootNavigator: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl.r, vertical: AppSpacing.xl.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.md.h,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.localizations.inRange,
                                  style: context.typography.semiBold16.copyWith(
                                    color: context.colors.error,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs.r,
                                    vertical: AppSpacing.xxs.r,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.surface,
                                    borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                                    border: Border.all(color: context.colors.containerBorder),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const AppVectorGraphic(path: Assets.vectorsLocationIcon),
                                      SizedBox(width: AppSpacing.xs.r),
                                      Text(
                                        'الرياض',
                                        style: context.typography.medium14,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: AppSpacing.xxxl.r),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.xxl.r,
                                vertical: AppSpacing.xl.r,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.containerBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                              ),
                              child: Text(
                                '08:00 AM - 05:00 PM',
                                style: context.typography.regular16,
                              ),
                            ),
                            Text(
                              'الاربعاء 24 فبراير 2025',
                              style: context.typography.regular14,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '06:22 مساءً',
                              style: context.typography.semiBold36,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'آخر تسجيل حدث 09:23 صباحًا',
                              style: context.typography.regular14,
                              textAlign: TextAlign.center,
                            ),
                            PrimaryTextButton(
                              appButtonSize: AppButtonSize.xxLarge,
                              label: context.localizations.fingerPrintRegistration,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ).callSheet(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
