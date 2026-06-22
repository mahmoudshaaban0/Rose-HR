import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
  State<MyInformationAccountScreen> createState() =>
      _MyInformationAccountScreenState();
}

class _MyInformationAccountScreenState
    extends State<MyInformationAccountScreen> {
  bool _isEmpty(dynamic value) {
    if (value == null) return true;
    final text = value.toString().trim();
    return text.isEmpty || text == 'null' || text == 'false';
  }

  String _money(dynamic value) {
    final number = value is num ? value : num.tryParse(value.toString());
    if (number == null) return value.toString();
    return NumberFormat('#,##0.##').format(number);
  }

  /// Builds a titled section, dropping rows whose value is null/empty.
  /// Returns `null` when no rows remain so the whole section is hidden.
  Widget? _section(
    BuildContext context,
    String title,
    List<MapEntry<String, dynamic>> rows,
  ) {
    final visible = rows.where((row) => !_isEmpty(row.value)).toList();
    if (visible.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.typography.semiBold18),
        SizedBox(height: AppSpacing.sm.h),
        for (var i = 0; i < visible.length; i++)
          RowItem(
            title: visible[i].key,
            value: visible[i].value.toString(),
            hasDivider: i != visible.length - 1,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountCubit>()..getAccountInfo(),
      child: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == AccountStatus.initial ||
              state.status == AccountStatus.loading) {
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
              body: Center(
                child: Text(
                  state.errorMessage ??
                      context.localizations.somethingWentWrong,
                ),
              ),
            );
          }
          if (state.status == AccountStatus.success) {
            final accountResponseModel = state.accountResponseModel;
            if (accountResponseModel == null) {
              return Scaffold(
                backgroundColor: context.colors.containerBackground,
                appBar: PrimaryAppBar(
                  title: context.localizations.personalData,
                ),
                body: Center(child: Text(context.localizations.noData)),
              );
            }
            final data = accountResponseModel.result?.data;
            if (data == null) {
              return Scaffold(
                backgroundColor: context.colors.containerBackground,
                appBar: PrimaryAppBar(
                  title: context.localizations.personalData,
                ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.r,
                    vertical: AppSpacing.xl.r,
                  ),
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await context.read<AccountCubit>().getAccountInfo();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.lg.h,
                        children: [
                          _section(
                            context,
                            context.localizations.personalData,
                            [
                              MapEntry(
                                context.localizations.employeeNumber,
                                data.pin,
                              ),
                              MapEntry(
                                context.localizations.fullName,
                                data.name,
                              ),
                              MapEntry(
                                context.localizations.gender,
                                data.gender == null
                                    ? null
                                    : data.gender.toString() == 'male'
                                    ? context.localizations.male
                                    : context.localizations.female,
                              ),
                              MapEntry(
                                context.localizations.workEmail,
                                data.workEmail,
                              ),
                              MapEntry(
                                context.localizations.maritalStatus,
                                data.marital,
                              ),
                              MapEntry(
                                context.localizations.dateOfBirth,
                                data.birthday,
                              ),
                              MapEntry(
                                context.localizations.mobileNumber,
                                data.phone,
                              ),
                            ],
                          ),
                          _section(
                            context,
                            context.localizations.employmentData,
                            [
                              MapEntry(
                                context.localizations.joinDate,
                                data.joinDate,
                              ),
                              MapEntry(
                                context.localizations.jobTitle,
                                data.jobPosition,
                              ),
                              MapEntry(
                                context.localizations.department,
                                data.department,
                              ),
                              MapEntry(
                                context.localizations.businessUnit,
                                data.businessUnit,
                              ),
                              MapEntry(
                                context.localizations.workLocation,
                                data.workLocation,
                              ),
                              MapEntry(
                                context.localizations.directManager,
                                data.directManager,
                              ),
                            ],
                          ),
                          _section(
                            context,
                            context.localizations.identityDetails,
                            [
                              MapEntry(
                                context.localizations.nationality,
                                data.country,
                              ),
                              MapEntry(
                                context.localizations.religion,
                                data.religion,
                              ),
                              MapEntry(
                                context.localizations.identityNumber,
                                data.iqamaNumber,
                              ),
                              MapEntry(
                                context.localizations.identityExpiryDate,
                                data.iqamaExpiryDate,
                              ),
                            ],
                          ),
                          _section(context, context.localizations.address, [
                            MapEntry(
                              context.localizations.buildingNumber,
                              data.buildingNumber,
                            ),
                            MapEntry(
                              context.localizations.streetName,
                              data.street,
                            ),
                            MapEntry(
                              context.localizations.district,
                              data.state,
                            ),
                            MapEntry(context.localizations.city, data.city),
                            MapEntry(
                              context.localizations.postalCode,
                              data.zip,
                            ),
                          ]),
                          _section(
                            context,
                            context.localizations.salaryInformation,
                            [
                              MapEntry(
                                context.localizations.basicSalary,
                                _isEmpty(data.basicSalary)
                                    ? null
                                    : _money(data.basicSalary),
                              ),
                              MapEntry(
                                context.localizations.housingAllowance,
                                _isEmpty(data.housingAllowance)
                                    ? null
                                    : _money(data.housingAllowance),
                              ),
                              MapEntry(
                                context.localizations.transportationAllowance,
                                _isEmpty(data.transportationAllowance)
                                    ? null
                                    : _money(data.transportationAllowance),
                              ),
                              MapEntry(
                                context.localizations.communicationAllowance,
                                _isEmpty(data.communicationAllowance)
                                    ? null
                                    : _money(data.communicationAllowance),
                              ),
                              MapEntry(
                                context.localizations.supervisionAllowance,
                                _isEmpty(data.supervisionAllowance)
                                    ? null
                                    : _money(data.supervisionAllowance),
                              ),
                              MapEntry(
                                context.localizations.excellenceAllowance,
                                _isEmpty(data.excellenceAllowance)
                                    ? null
                                    : _money(data.excellenceAllowance),
                              ),
                              MapEntry(
                                context
                                    .localizations
                                    .transportationSupportAllowance,
                                _isEmpty(data.transportationSupportAllowance)
                                    ? null
                                    : _money(
                                        data.transportationSupportAllowance,
                                      ),
                              ),
                              MapEntry(
                                context.localizations.assignmentAllowance,
                                _isEmpty(data.assignmentAllowance)
                                    ? null
                                    : _money(data.assignmentAllowance),
                              ),
                              MapEntry(
                                context.localizations.otherAllowance,
                                _isEmpty(data.otherAllowance)
                                    ? null
                                    : _money(data.otherAllowance),
                              ),
                              MapEntry(
                                context.localizations.totalSalary,
                                _isEmpty(data.totalSalary)
                                    ? null
                                    : _money(data.totalSalary),
                              ),
                            ],
                          ),
                        ].whereType<Widget>().toList(),
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
