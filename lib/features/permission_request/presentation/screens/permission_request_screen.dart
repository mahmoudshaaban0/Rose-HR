import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class PermissionRequestScreen extends StatelessWidget {
  const PermissionRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: context.localizations.permissionRequest),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                child: Column(
                  spacing: AppSpacing.md.h,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r, vertical: AppSpacing.xl.r),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                      ),
                      child: Column(
                        spacing: AppSpacing.md.h,
                        children: [
                          InfoCard(
                            title: context.localizations.permissionDayAndType,
                            subtitle: context.localizations.permissionRequest,
                            value: context.localizations.permissionRequest,
                            onTap: () {},
                          ),
                          InfoCard(
                            prefixIcon: Assets.vectorsCalendarFill,
                            title: context.localizations.date,
                            subtitle: '10/29/2025',
                            value: '08 ابريل 2025',
                            showArrow: false,
                            onTap: () {},
                          ),
                          InfoCard(
                            title: context.localizations.choosePermissionReason,
                            subtitle: context.localizations.choosePermissionReason,
                            value: context.localizations.choosePermissionReason,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r, vertical: AppSpacing.xl.r),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.md.h,
                        children: [
                          AppTextField(
                            controller: TextEditingController(),
                            title: context.localizations.reason,
                            hintTextLabel: 'أكتب سبب الإستئذان إن وجد...',
                            maxLines: 4,
                          ),
                          Text(context.localizations.attachments, style: context.typography.medium16),
                          DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              color: context.colors.dividerColor,
                              radius: Radius.circular(AppSpacing.xxxxl.r),
                              dashPattern: [10, 10],
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxxl.h, horizontal: AppSpacing.xxxxl.w),
                                child: Center(
                                  child: Column(
                                    spacing: AppSpacing.sm.h,
                                    children: [
                                      const AppVectorGraphic(path: Assets.vectorsUploadCloud),
                                      Text(context.localizations.clickToUpload, style: context.typography.medium14),
                                      Text(context.localizations.fileFormatsHint, style: context.typography.regular14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.r,
              ),
              decoration: BoxDecoration(
                color: context.colors.containerBackground,
                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
              ),
              child: PrimaryTextButton(
                appButtonSize: AppButtonSize.xxLarge,
                label: context.localizations.submitRequest,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
