import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class UploadFilePlacholder extends StatelessWidget {
  const UploadFilePlacholder({required this.onTap, required this.isMaxFilesReached, super.key});
  final void Function()? onTap;
  final bool isMaxFilesReached;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        color: context.colors.dividerColor,
        radius: Radius.circular(AppSpacing.xxxxl.r),
        dashPattern: [10, 10],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.xxxxl.r),
        onTap: isMaxFilesReached
            ? null
            : () {
                onTap?.call();
              },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.xxxxl.h,
            horizontal: AppSpacing.xxxxl.w,
          ),
          child: Center(
            child: Column(
              spacing: AppSpacing.sm.h,
              children: [
                const AppVectorGraphic(path: Assets.vectorsUploadCloud),
                Text(
                  context.localizations.clickToUpload,
                  style: context.typography.medium14,
                ),
                Text(
                  context.localizations.fileFormatsHint,
                  style: context.typography.regular14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
