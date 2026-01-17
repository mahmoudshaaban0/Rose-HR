import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/common/widgets/app_datepicker.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/punch_correction/presentation/widgets/correction_time_widget.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class PunchCorrectionScreen extends StatelessWidget {
  const PunchCorrectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.containerBackground,
      appBar: PrimaryAppBar(title: context.localizations.punchCorrection),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.md.h,
                  children: [
                    InfoCard(
                      prefixIcon: Assets.vectorsCalendarFill,
                      title: context.localizations.date,
                      subtitle: '10/29/2025',
                      value: '10/29/2025',
                      onTap: () {
                        context.showAppDatePicker(onDateSelected: (date) {});
                      },
                    ),
                    InfoCard(
                      title: context.localizations.shift,
                      subtitle: '08:00 AM - 05:00 PM ',
                      value: '08:00 AM - 05:00 PM ',
                      showArrow: false,
                      onTap: null,
                    ),
                    Text(context.localizations.suggestedCorrectionTime, style: context.typography.medium16),
                    CorrectionTimeWidget(
                      title: context.localizations.recordedCheckInTime,
                      onCheckedChange: (value) {},
                      onCorrectTap: () {
                        context.pushNamed(AppRoutes.correctionTime.name);
                      },
                    ),
                    CorrectionTimeWidget(
                      onCheckedChange: (value) {},
                      title: context.localizations.recordedCheckOutTime,
                      onCorrectTap: () {
                        AppLogger.instance.logInfo('onCorrectTap');
                      },
                    ),

                    InfoCard(
                      title: context.localizations.reason,
                      subtitle: context.localizations.forgotFingerprint,
                      value: context.localizations.enterDetailsHere,
                      onTap: () {
                        BottomSheetWrapper(
                          initialSize: 0.5.h,
                          maxChildSize: 0.5.h,
                          removeAutoScroll: true,
                          disableDrag: true,
                          useRootNavigator: true,
                          child: Column(
                            children: [
                              Text(context.localizations.reason, style: context.typography.medium16),
                            ],
                          ),
                        ).callSheet(context);
                      },
                    ),
                    AppTextField(
                      controller: TextEditingController(),
                      hintTextLabel: context.localizations.enterDetailsHere,
                      maxLines: 4,
                    ),

                    Text(context.localizations.attachments, style: context.typography.medium16),
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: context.colors.dividerColor,
                        radius: Radius.circular(AppSpacing.xxxxl.r),
                        dashPattern: [10, 10],
                      ),
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
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: PrimaryTextButton(
                onTap: () {},
                appButtonSize: AppButtonSize.xxLarge,
                label: context.localizations.submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
