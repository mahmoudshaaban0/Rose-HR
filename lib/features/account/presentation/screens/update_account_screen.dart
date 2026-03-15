import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class UpdateAccountScreen extends StatelessWidget {
  const UpdateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.containerBackground,
      appBar: PrimaryAppBar(title: context.localizations.editPersonalData),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md.h,
              children: [
                Text(
                  context.localizations.generalInformation,
                  style: context.typography.semiBold18,
                ),
                const AppDivider(),
                AppTextField(
                  title: context.localizations.fullNameInArabic,
                  hintTextLabel: context.localizations.fullNameInArabic,
                  enabled: false,
                  suffixIcon: const AppVectorGraphic(path: Assets.vectorsLockLine),
                  controller: TextEditingController(),
                ),
                AppTextField(
                  title: context.localizations.emailAddress,
                  hintTextLabel: context.localizations.emailAddress,
                  controller: TextEditingController(),
                ),
                InfoCard(
                  title: context.localizations.gender,
                  subtitle: context.localizations.gender,
                  value: context.localizations.gender,
                  onTap: () {},
                ),
                InfoCard(
                  title: context.localizations.maritalStatus,
                  subtitle: context.localizations.maritalStatus,
                  value: context.localizations.maritalStatus,
                  onTap: () {},
                ),
                // تاريخ الميلاد
                InfoCard(
                  title: context.localizations.dateOfBirth,
                  subtitle: context.localizations.dateOfBirth,
                  value: context.localizations.dateOfBirth,
                  onTap: () {},
                ),
                // رقم الجوال
                InfoCard(
                  title: context.localizations.mobileNumber,
                  subtitle: context.localizations.mobileNumber,
                  value: context.localizations.mobileNumber,
                  onTap: () {},
                ),
                Text(
                  context.localizations.bankAccountDetails,
                  style: context.typography.semiBold18,
                ),
                const AppDivider(),
                AppTextField(
                  title: context.localizations.bankName,
                  hintTextLabel: context.localizations.bankName,
                  enabled: false,
                  suffixIcon: const AppVectorGraphic(path: Assets.vectorsLockLine),
                ),
                AppTextField(
                  title: context.localizations.ibanNumber,
                  hintTextLabel: context.localizations.ibanNumber,
                  enabled: false,
                  suffixIcon: const AppVectorGraphic(path: Assets.vectorsLockLine),
                ),
                PrimaryTextButton(
                  appButtonSize: AppButtonSize.xxLarge,
                  label: context.localizations.save,
                  onTap: () {
                    // context.goNamed(AppRoutes.login.name);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
