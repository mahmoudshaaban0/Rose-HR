import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CurrentRequestItem extends StatelessWidget {
  const CurrentRequestItem({
    required this.requestType,
    required this.requestDate,
    required this.requestNumber,
    required this.requestStatus,
    required this.requestColor,
    required this.requestResponse,
    required this.onViewRequest,
    super.key,
    this.onCancelRequest,
    this.onApproveRequest,
    this.onRejectRequest,
    this.showApproveReject = false,
  });
  final String requestType;
  final String requestDate;
  final String requestNumber;
  final String requestStatus;
  final Color requestColor;
  final String requestResponse;
  final void Function()? onCancelRequest;
  final void Function()? onApproveRequest;
  final void Function()? onRejectRequest;
  final void Function()? onViewRequest;
  final bool showApproveReject;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onViewRequest,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: context.colors.containerBackground,
          borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs.w),
              title: Text(requestType, style: context.typography.semiBold18),
              subtitle: Text(requestDate, style: context.typography.regular14),
              trailing: (onCancelRequest != null || showApproveReject)
                  ? InkWell(
                      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                      onTap: () {
                        if (showApproveReject) {
                          _showApproveRejectBottomSheet(context);
                        } else {
                          _showCancelBottomSheet(context);
                        }
                      },
                      child: Icon(
                        Icons.more_vert,
                        size: 20.r,
                        color: context.colors.onSurfaceVariant,
                      ),
                    )
                  : null,
            ),
            const AppDivider(),
            SizedBox(height: AppSpacing.sm.h),

            lineItem(
              context: context,
              icon: Assets.vectorsHashtag,
              title: context.localizations.requestNumber,
              trailingTitleColor: context.colors.onSurface,
              trailingTitle: requestNumber,
            ),
            SizedBox(height: AppSpacing.sm.h),
            lineItem(
              context: context,
              icon: Assets.vectorsPulseLine,
              title: context.localizations.requestStatus,
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w, vertical: AppSpacing.xs.h),
                decoration: BoxDecoration(
                  color: context.colors.statusPendingBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                  border: Border.all(color: context.colors.statusPendingBorder),
                ),
                child: Text(requestStatus, style: context.typography.medium12.copyWith(color: context.colors.statusPendingText)),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            // const AppDivider(),
            // SizedBox(height: AppSpacing.sm.h),
            // Row(
            //   spacing: AppSpacing.md.w,
            //   children: [
            //     AppVectorGraphic(path: Assets.vectorsDot, color: ColorFilter.mode(requestColor, BlendMode.srcIn)),
            //     Text(
            //       requestResponse,
            //       style: context.typography.medium14.copyWith(color: requestColor),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _showCancelBottomSheet(BuildContext context) {
    BottomSheetWrapper(
      initialSize: 0.12.h,
      minChildSize: 0.12.h,
      maxChildSize: 0.12.h,
      removeAutoScroll: true,
      disableDrag: true,
      useRootNavigator: true,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md.w),
        child: Column(
          spacing: AppSpacing.sm.h,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryTextButton(
              appButtonSize: AppButtonSize.xxLarge,
              label: context.localizations.cancelRequest,
              onTap: onCancelRequest,
            ),
          ],
        ),
      ),
    ).callSheet(context);
  }

  void _showApproveRejectBottomSheet(BuildContext context) {
    BottomSheetWrapper(
      useSolidBackground: true,
      initialSize: 0.35,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.md.h),
            PrimaryTextButton(
              label: context.localizations.approveRequest,
              onTap: onApproveRequest,
              overriddenBackgroundColor: context.colors.success,
            ),
            SizedBox(height: AppSpacing.md.h),
            PrimaryTextButton(
              label: context.localizations.rejectRequest,
              onTap: onRejectRequest,
              overriddenBackgroundColor: context.colors.error,
            ),
            SizedBox(height: AppSpacing.md.h),
          ],
        ),
      ),
    ).callSheet(context);
  }
}

Widget lineItem({
  required BuildContext context,
  required String icon,
  required String title,
  String? trailingTitle,
  Widget? trailing,
  Color? trailingTitleColor,
}) {
  return Row(
    spacing: AppSpacing.md.w,
    children: [
      AppVectorGraphic(path: icon),
      Text(title, style: context.typography.medium14),
      const Spacer(),
      if (trailingTitle != null)
        Text(
          trailingTitle,
          style: context.typography.medium14.copyWith(
            color: trailingTitleColor,
          ),
        ),
      if (trailing != null) trailing,
    ],
  );
}
