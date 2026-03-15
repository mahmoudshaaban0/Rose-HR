import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class SuccessRequestBottomsheet extends StatelessWidget {
  const SuccessRequestBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md.h,
        children: [
          const AppVectorGraphic(path: Assets.vectorsPermissionReqeuestSuccessIcon),
          Text(
            context.localizations.thankYou,
            style: context.typography.regular16,
            textAlign: TextAlign.center,
          ),
          Text(
            context.localizations.requestSubmittedSuccessfully,
            style: context.typography.semiBold28.copyWith(color: context.colors.success),
            textAlign: TextAlign.center,
          ),
          PrimaryTextButton(
            label: context.localizations.done,
            appButtonSize: AppButtonSize.xxLarge,
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
        ],
      ),
    );
  }
}
