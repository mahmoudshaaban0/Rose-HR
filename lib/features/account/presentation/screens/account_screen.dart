import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/loading.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/account/presentation/cubit/account_cubit.dart';
import 'package:rose_hr/features/account/presentation/widgets/row_item.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountCubit>()..getAccountInfo(),
      child: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == AccountStatus.loading) {
            return const Center(child: LoadingWidget());
          }
          if (state.status == AccountStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'حدث خطأ ما'));
          } else if (state.status == AccountStatus.success) {
            final accountResponseModel = state.accountResponseModel;
            if (accountResponseModel == null) {
              return const Center(child: Text('لا يوجد بيانات'));
            }
            final data = accountResponseModel.result?.data;
            if (data == null) {
              return const Center(child: Text('لا يوجد بيانات'));
            }
            return Scaffold(
              backgroundColor: context.colors.containerBackground,
              appBar: PrimaryAppBar(
                title: 'البيانات الشخصية',
                actions: [
                  InkWell(
                    borderRadius: BorderRadius.circular(25.r),

                    onTap: () {
                      context.pushNamed(AppRoutes.updateAccount.name);
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
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await context.read<AccountCubit>().getAccountInfo();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.h,
                        children: [
                          Text('البيانات الشخصية', style: context.typography.semiBold18),
                          RowItem(title: 'الاسم الأول', value: data.name.toString()),
                          RowItem(title: 'الاسم الأخير', value: data.name.toString().split(' ').last),
                          RowItem(title: 'الجنس', value: data.gender.toString() == 'male' ? 'ذكر' : 'أنثى'),
                          RowItem(title: 'البريد الإلكتروني', value: data.privateEmail.toString()),
                          RowItem(title: 'الحالة الإجتماعية', value: data.marital.toString()),
                          RowItem(title: 'تاريخ الميلاد', value: data.birthday.toString()),
                          RowItem(title: 'رقم الجوال', value: data.phone.toString(), hasDivider: false),
                          SizedBox(height: AppSpacing.sm.h),
                          Text('تفاصيل الهوية', style: context.typography.semiBold18),
                          RowItem(title: 'الجنسية', value: data.country.toString()),
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
                          RowItem(title: 'اسم البنك', value: data.bankAccount?.bankName.toString() ?? ''),
                          RowItem(title: 'رقم الأيبان IBAN', value: data.bankAccount?.accountNumber.toString() ?? ''),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
