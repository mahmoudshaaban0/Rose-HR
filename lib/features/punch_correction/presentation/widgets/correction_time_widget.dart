import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

class CorrectionTimeWidget extends StatelessWidget {
  const CorrectionTimeWidget({
    required this.onCheckedChange,
    required this.title,
    required this.onCorrectTap,
    this.time,
    super.key,
    this.isChecked = false,
    this.showEarlyOutBadge = false,
    this.showLateInBadge = false,
    this.showFingerprintDevice = false,
    this.showTimeInErrorColor = false,
    this.correctionTime,
  });
  final void Function(bool) onCheckedChange;
  final String title;
  final void Function()? onCorrectTap;
  final String? time;
  final bool isChecked;
  final bool showLateInBadge;
  final bool showEarlyOutBadge;
  final bool showFingerprintDevice;
  final bool showTimeInErrorColor;
  final String? correctionTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: context.colors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Transform.scale(
                scale: 1.4,
                child: CupertinoCheckbox(
                  checkColor: context.colors.surface,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.focused)) {
                      return context.isLightMode ? context.colors.black : context.colors.black;
                    } else if (states.contains(WidgetState.disabled)) {
                      return context.isLightMode ? context.colors.onSurface : context.colors.surfaceVariant;
                    } else if (states.contains(WidgetState.selected)) {
                      return context.isLightMode ? context.colors.onSurface : context.colors.black;
                    } else {
                      return context.isLightMode ? context.colors.surface : context.colors.surfaceVariant;
                    }
                  }),
                  value: isChecked,
                  onChanged: (value) {
                    ThemeScopeWidget.of(context)?.changeTo(ThemeMode.dark);
                    onCheckedChange(value ?? false);
                  },
                ),
              ),
              Text(title, style: context.typography.regular16),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.directional(start: 35.w),
                child: Text(
                  time ?? '--:--',
                  style: context.typography.medium16.copyWith(
                    color: showTimeInErrorColor ? context.colors.error : context.colors.containerBorder,
                  ),
                ),
              ),
              if (correctionTime != null) ...[
                SizedBox(width: AppSpacing.xs.w),
                Icon(CupertinoIcons.arrow_left, size: 14.r, color: context.colors.onSurface),
                SizedBox(width: AppSpacing.xs.w),
                Text(
                  correctionTime ?? '--:--',
                  style: context.typography.medium16.copyWith(color: context.colors.containerBorder),
                ),
              ],
              const Spacer(),
              if (showLateInBadge || showEarlyOutBadge)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                  decoration: BoxDecoration(
                    color: context.colors.errorBadgeBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                    border: Border.all(color: context.colors.error),
                  ),
                  child: Text(
                    showLateInBadge ? context.localizations.lateArrival : context.localizations.earlyOut,
                    style: context.typography.medium12.copyWith(color: context.colors.error),
                  ),
                ),
              if (showLateInBadge || showEarlyOutBadge) SizedBox(width: AppSpacing.xs.w),
              if (showFingerprintDevice)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                  decoration: BoxDecoration(
                    color: context.colors.errorBadgeBackground,
                    borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                    border: Border.all(color: context.colors.iconSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppVectorGraphic(path: Assets.vectorsFingerprint),
                      SizedBox(width: AppSpacing.xs.w),
                      Text(
                        context.localizations.fingerprintDevice,
                        style: context.typography.medium12.copyWith(color: context.colors.iconSubtle),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: AppSpacing.sm.w),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.sm.h),
            child: Column(
              spacing: AppSpacing.sm.h,
              children: [
                const AppDivider(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppSpacing.lg),
                    splashColor: context.colors.onSurface.withValues(alpha: 0.1),
                    highlightColor: context.colors.onSurface.withValues(alpha: 0.05),
                    onTap: onCorrectTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.localizations.clickToSuggestCorrection, style: context.typography.regular16),

                        Icon(Icons.arrow_forward, size: 20.r, color: context.colors.onSurface),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
