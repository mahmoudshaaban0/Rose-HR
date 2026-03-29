import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/loading.dart';
import 'package:rose_hr/features/account/presentation/cubit/account_cubit.dart';
import 'package:rose_hr/features/account/presentation/widgets/row_item.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class MyInformationAccountScreen extends StatefulWidget {
  const MyInformationAccountScreen({super.key});

  @override
  State<MyInformationAccountScreen> createState() => _MyInformationAccountScreenState();
}

class _MyInformationAccountScreenState extends State<MyInformationAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountCubit>()..getAccountInfo(),
      child: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == AccountStatus.initial || state.status == AccountStatus.loading) {
            return Scaffold(
              backgroundColor: context.colors.containerBackground,
              appBar: PrimaryAppBar(title: context.localizations.personalData),
              body: const Center(child: LoadingWidget()),
            );
          }
          if (state.status == AccountStatus.error) {
            return Scaffold(
              backgroundColor: context.colors.containerBackground,
              appBar: PrimaryAppBar(title: context.localizations.personalData),
              body: Center(child: Text(state.errorMessage ?? context.localizations.somethingWentWrong)),
            );
          }
          if (state.status == AccountStatus.success) {
            final accountResponseModel = state.accountResponseModel;
            if (accountResponseModel == null) {
              return Scaffold(
                backgroundColor: context.colors.containerBackground,
                appBar: PrimaryAppBar(title: context.localizations.personalData),
                body: Center(child: Text(context.localizations.noData)),
              );
            }
            final data = accountResponseModel.result?.data;
            if (data == null) {
              return Scaffold(
                backgroundColor: context.colors.containerBackground,
                appBar: PrimaryAppBar(title: context.localizations.personalData),
                body: Center(child: Text(context.localizations.noData)),
              );
            }
            return Scaffold(
              backgroundColor: context.colors.containerBackground,
              appBar: PrimaryAppBar(
                title: context.localizations.personalData,
                // actions: [
                // InkWell(
                //   borderRadius: BorderRadius.circular(25.r),

                //   onTap: () {
                //     context.pushNamed(AppRoutes.updateAccount.name);
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(left: 4.w, right: 4.w),
                //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                //     decoration: BoxDecoration(
                //       color: context.colors.containerBackground,
                //       borderRadius: BorderRadius.circular(16.r),
                //       border: Border.all(color: context.colors.dividerColor),
                //     ),
                //     child: Row(
                //       children: [
                //         AppVectorGraphic(
                //           path: Assets.vectorsEdit,
                //           color: context.isDarkMode ? ColorFilter.mode(context.colors.white, BlendMode.srcIn) : null,
                //         ),
                //         SizedBox(width: 2.w),
                //         Text(
                //           context.localizations.edit,
                //           style: context.typography.medium14,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // ],
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
                          Text(context.localizations.personalData, style: context.typography.semiBold18),
                          RowItem(title: context.localizations.firstName, value: data.name.toString()),
                          RowItem(title: context.localizations.lastName, value: data.name.toString().split(' ').last),
                          RowItem(
                            title: context.localizations.gender,
                            value: data.gender.toString() == 'male' ? context.localizations.male : context.localizations.female,
                          ),
                          RowItem(title: context.localizations.emailAddress, value: data.privateEmail.toString()),
                          RowItem(title: context.localizations.maritalStatus, value: data.marital.toString()),
                          RowItem(title: context.localizations.dateOfBirth, value: data.birthday.toString()),
                          RowItem(title: context.localizations.mobileNumber, value: data.phone.toString(), hasDivider: false),
                          SizedBox(height: AppSpacing.sm.h),
                          Text(context.localizations.identityDetails, style: context.typography.semiBold18),
                          RowItem(title: context.localizations.nationality, value: data.country.toString()),
                          RowItem(title: context.localizations.religion, value: context.localizations.muslim),
                          RowItem(title: context.localizations.identityType, value: '12345678901234'),
                          RowItem(title: context.localizations.identityNumber, value: context.localizations.egyptian),
                          RowItem(title: context.localizations.identityExpiryDate, value: '1999-01-01'),
                          SizedBox(height: AppSpacing.sm.h),
                          Text(context.localizations.address, style: context.typography.semiBold18),
                          RowItem(title: context.localizations.buildingNumber, value: '1234567890'),
                          RowItem(title: context.localizations.streetName, value: 'محمد علي'),
                          RowItem(title: context.localizations.district, value: 'المنطقة الشرقية'),
                          RowItem(title: context.localizations.city, value: 'الرياض'),
                          RowItem(title: context.localizations.postalCode, value: '123456'),
                          SizedBox(height: AppSpacing.sm.h),
                          Text(context.localizations.bankAccountDetails, style: context.typography.semiBold18),
                          RowItem(title: context.localizations.bankName, value: data.bankAccount?.bankName.toString() ?? ''),
                          RowItem(
                            title: context.localizations.ibanNumber,
                            value: data.bankAccount?.accountNumber.toString() ?? '',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            backgroundColor: context.colors.containerBackground,
            appBar: PrimaryAppBar(title: context.localizations.personalData),
            body: const Center(child: LoadingWidget()),
          );
        },
      ),
    );
  }
}
