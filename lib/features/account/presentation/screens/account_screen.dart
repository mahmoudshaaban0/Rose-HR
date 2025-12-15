import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/account/presentation/widgets/row_item.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.containerBackground,
      appBar: PrimaryAppBar(
        title: 'البيانات الشخصية',
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(25.r),
            onDoubleTap: () {
              ThemeScopeWidget.of(context)?.changeTo(ThemeMode.light);
            },
            onTap: () {
              ThemeScopeWidget.of(context)?.changeTo(ThemeMode.dark);
            },
            child: Container(
              margin: EdgeInsets.only(left: 4.w, right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.colors.containerBackground,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: context.colors.dividerColor),
              ),
              child: Row(
                children: [
                  AppVectorGraphic(
                    path: Assets.vectorsEdit,
                    color: context.isDarkMode ? ColorFilter.mode(context.colors.white, BlendMode.srcIn) : null,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'تعديل',
                    style: context.typography.medium14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.h,
              children: [
                Text('البيانات الشخصية', style: context.typography.semiBold18),
                const RowItem(title: 'الاسم الأول', value: 'محمود'),
                const RowItem(title: 'الاسم الأخير', value: 'شعبان'),
                const RowItem(title: 'الجنس', value: 'ذكر'),
                const RowItem(title: 'البريد الإلكتروني', value: 'mohamed@example.com'),
                const RowItem(title: 'الحالة الإجتماعية', value: 'أعزب'),
                const RowItem(title: 'تاريخ الميلاد', value: '1999-01-01'),
                const RowItem(title: 'رقم الجوال', value: '01234567890', hasDivider: false),
                SizedBox(height: AppSpacing.sm.h),
                Text('تفاصيل الهوية', style: context.typography.semiBold18),
                const RowItem(title: 'الجنسية', value: 'مصري'),
                const RowItem(title: 'الديانة', value: 'مسلم'),
                const RowItem(title: 'نوع الهوية', value: '12345678901234'),
                const RowItem(title: 'رقم الهوية', value: 'مصري'),
                const RowItem(title: 'تاريخ إنتهاء الهوية', value: '1999-01-01'),
                SizedBox(height: AppSpacing.sm.h),
                Text('العنوان', style: context.typography.semiBold18),
                const RowItem(title: 'رقم المبني', value: '1234567890'),
                const RowItem(title: 'اسم الشارع', value: 'محمد علي'),
                const RowItem(title: 'المنطقه', value: 'المنطقة الشرقية'),
                const RowItem(title: 'المدينه', value: 'الرياض'),
                const RowItem(title: 'الرمز البريدي', value: '123456'),
                SizedBox(height: AppSpacing.sm.h),
                Text('تفاصيل الحساب البنكي', style: context.typography.semiBold18),
                const RowItem(title: 'اسم البنك', value: 'البنك المصري'),
                const RowItem(title: 'رقم الأيبان IBAN', value: '12345678901234'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
