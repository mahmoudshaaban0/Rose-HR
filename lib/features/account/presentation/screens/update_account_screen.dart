import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
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
      appBar: const PrimaryAppBar(title: 'تعديل البيانات الشخصية'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md.h,
              children: [
                Text(
                  'المعلومات العامة',
                  style: context.typography.semiBold18,
                ),
                const AppDivider(),
                AppTextField(
                  title: 'الاسم كامل باللغة العربية',
                  hintTextLabel: 'الاسم كامل باللغة العربية',
                  enabled: false,
                  suffixIcon: const AppVectorGraphic(path: Assets.vectorsLockLine),
                  controller: TextEditingController(),
                ),
                AppTextField(
                  title: 'البريد الإلكتروني',
                  hintTextLabel: 'البريد الإلكتروني',
                  controller: TextEditingController(),
                ),
                InfoCard(
                  title: 'الجنس',
                  subtitle: 'الجنس',
                  value: 'الجنس',
                  onTap: () {},
                ),
                InfoCard(
                  title: 'الحالة الإجتماعية',
                  subtitle: 'الحالة الإجتماعية',
                  value: 'الحالة الإجتماعية',
                  onTap: () {},
                ),
                // تاريخ الميلاد
                InfoCard(
                  title: 'تاريخ الميلاد',
                  subtitle: 'تاريخ الميلاد',
                  value: 'تاريخ الميلاد',
                  onTap: () {},
                ),
                // رقم الجوال
                InfoCard(
                  title: 'رقم الجوال',
                  subtitle: 'رقم الجوال',
                  value: 'رقم الجوال',
                  onTap: () {},
                ),
                Text(
                  'تفاصيل الحساب البنكي',
                  style: context.typography.semiBold18,
                ),
                const AppDivider(),
                const AppTextField(
                  title: 'اسم البنك',
                  hintTextLabel: 'اسم البنك',
                  enabled: false,
                  suffixIcon: AppVectorGraphic(path: Assets.vectorsLockLine),
                ),
                const AppTextField(
                  title: 'رقم الأيبان IBAN',
                  hintTextLabel: 'رقم الأيبان IBAN',
                  enabled: false,
                  suffixIcon: AppVectorGraphic(path: Assets.vectorsLockLine),
                ),
                PrimaryTextButton(
                  appButtonSize: AppButtonSize.xxLarge,
                  label: 'حفظ',
                  onTap: () {
                    context.goNamed(AppRoutes.login.name);
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
