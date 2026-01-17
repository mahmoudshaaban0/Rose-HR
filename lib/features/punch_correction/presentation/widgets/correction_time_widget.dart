import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CorrectionTimeWidget extends StatefulWidget {
  const CorrectionTimeWidget({required this.onCheckedChange, required this.title, required this.onCorrectTap, super.key});
  final void Function(bool) onCheckedChange;
  final String title;
  final VoidCallback onCorrectTap;
  @override
  State<CorrectionTimeWidget> createState() => _CorrectionTimeWidgetState();
}

class _CorrectionTimeWidgetState extends State<CorrectionTimeWidget> {
  bool isChecked = false;
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
                  activeColor: context.colors.onSurface,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return context.colors.onSurface;
                    }
                    return context.colors.surface;
                  }),

                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                      widget.onCheckedChange(isChecked);
                    });
                  },
                ),
              ),
              Text(widget.title, style: context.typography.regular16),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text('--:--', style: context.typography.regular16),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                decoration: BoxDecoration(
                  color: context.colors.errorBadgeBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                  border: Border.all(color: context.colors.error),
                ),
                child: Text(
                  context.localizations.lateArrival,
                  style: context.typography.medium12.copyWith(color: context.colors.error),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                decoration: BoxDecoration(
                  color: context.colors.errorBadgeBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                  border: Border.all(color: context.colors.iconSubtle),
                ),
                child: Row(
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
                    onTap: widget.onCorrectTap,
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
