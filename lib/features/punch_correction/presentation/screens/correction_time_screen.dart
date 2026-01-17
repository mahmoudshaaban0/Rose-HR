import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/app_radio_button.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CorrectionTimeScreen extends StatefulWidget {
  const CorrectionTimeScreen({super.key});

  @override
  State<CorrectionTimeScreen> createState() => _CorrectionTimeScreenState();
}

class _CorrectionTimeScreenState extends State<CorrectionTimeScreen> {
  bool isManualTime = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: context.localizations.punchCorrection),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSpacing.md.h,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl.r, vertical: AppSpacing.xl.h),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                      ),
                      child: Column(
                        spacing: AppSpacing.lg.h,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppRadioButton<bool>(
                            value: true,
                            groupValue: isManualTime,
                            onChanged: (value) {
                              setState(() {});
                            },
                            label: context.localizations.enterTimeManually,
                          ),
                          const AppDivider(),
                          AppRadioButton<bool>(
                            value: false,
                            groupValue: false,
                            onChanged: (value) {},
                            label: context.localizations.selectFromRecordedFingerprints,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl.r, vertical: AppSpacing.xl.h),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                      ),
                      child: Column(
                        spacing: AppSpacing.lg.h,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            separatorBuilder: (context, index) {
                              return const AppDivider();
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
                                child: AppRadioButton<bool>(
                                  value: true,
                                  groupValue: isManualTime,
                                  labelStyle: context.typography.regular18.copyWith(
                                    color: context.colors.onSurface,
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  label: '11:30',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
              child: PrimaryTextButton(
                label: context.localizations.submit,
                onTap: () {},
                appButtonSize: AppButtonSize.xxLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
