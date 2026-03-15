import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Shows a bottom sheet with two options: Images or Files.
/// Uses [BottomSheetWrapper].
/// [onChooseImages] and [onChooseFiles] are called after the sheet is popped.
void showUploadSourceSheet(
  BuildContext context, {
  required VoidCallback onChooseImages,
  required VoidCallback onChooseFiles,
}) {
  BottomSheetWrapper(
    initialSize: 0.22,
    maxChildSize: 0.22,
    removeAutoScroll: true,
    disableDrag: true,
    useRootNavigator: true,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.r,
          vertical: AppSpacing.md.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  onChooseImages();
                },
                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.lg.h,
                    horizontal: AppSpacing.md.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppVectorGraphic(
                        path: Assets.vectorsImage,
                        width: 40.w,
                        height: 40.h,
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Text(
                        context.localizations.chooseImages,
                        style: context.typography.medium16,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            VerticalDivider(
              color: context.colors.dividerColor,
              thickness: 1,
              width: 1,
              indent: AppSpacing.md.h,
              endIndent: AppSpacing.md.h,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  onChooseFiles();
                },
                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.lg.h,
                    horizontal: AppSpacing.md.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppVectorGraphic(
                        path: Assets.vectorsPdf,
                        width: 40.w,
                        height: 40.h,
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Text(
                        context.localizations.chooseFiles,
                        style: context.typography.medium16,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ).callSheet(context);
}
