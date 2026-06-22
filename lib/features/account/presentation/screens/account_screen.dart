import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/account/presentation/widgets/account_menu_item.dart';
import 'package:rose_hr/features/home/presentation/widgets/header_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      // appBar: PrimaryAppBar(
      //   title: context.localizations.personalData,
      //   actions: [
      //     InkWell(
      //       borderRadius: BorderRadius.circular(25.r),
      //       onTap: () {
      //         context.pushNamed(AppRoutes.updateAccount.name);
      //       },
      //       child: Container(
      //         margin: EdgeInsets.only(left: 4.w, right: 4.w),
      //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      //         decoration: BoxDecoration(
      //           color: context.colors.containerBackground,
      //           borderRadius: BorderRadius.circular(16.r),
      //           border: Border.all(color: context.colors.dividerColor),
      //         ),
      //         child: Row(
      //           children: [
      //             AppVectorGraphic(
      //               path: Assets.vectorsEdit,
      //               color: context.isDarkMode ? ColorFilter.mode(context.colors.white, BlendMode.srcIn) : null,
      //             ),
      //             SizedBox(width: 2.w),
      //             Text(
      //               context.localizations.edit,
      //               style: context.typography.medium14,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8.h,
                  children: [
                    ColoredBox(
                      color: context.colors.containerBackground,
                      child: const HeaderSection(hideNotificationIcon: true),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h, horizontal: AppSpacing.lg.w),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.localizations.hrInformation,
                            style: context.typography.medium16,
                          ),
                          SizedBox(height: AppSpacing.xl.h),
                          const AppDivider(),
                          AccountMenuItem(
                            iconPath: Assets.vectorsPersonalInformationIcon,
                            title: context.localizations.personalData,
                            subtitle: context.localizations.personalinfo,
                            onTap: () => context.pushNamed(AppRoutes.myInformation.name),
                          ),
                          // AccountMenuItem(
                          //   iconPath: Assets.vectorsHashtag,
                          //   title: context.localizations.employmentData,
                          //   subtitle: context.localizations.employmentDataSubtitle,
                          //   onTap: () {},
                          // ),
                          // AccountMenuItem(
                          //   iconPath: Assets.vectorsImage,
                          //   title: context.localizations.financialDetails,
                          //   subtitle: context.localizations.financialDetailsSubtitle,
                          //   onTap: () {},
                          // ),
                          // AccountMenuItem(
                          //   iconPath: Assets.vectorsCalendarFill,
                          //   title: context.localizations.vacations,
                          //   subtitle: context.localizations.vacationsSubtitle,
                          //   onTap: () {},
                          // ),
                          AccountMenuItem(
                            iconPath: Assets.vectorsGeneralSettingsIcon,
                            title: context.localizations.generalSettings,
                            subtitle: context.localizations.generalSettingsSubtitle,
                            onTap: () => context.pushNamed(AppRoutes.generalSettings.name),
                          ),
                          AccountMenuItem(
                            iconPath: Assets.vectorsChangePasswordIcon,
                            title: context.localizations.changePassword,
                            subtitle: context.localizations.changePasswordSubtitle,
                            showDivider: false,
                            onTap: () => context.pushNamed(AppRoutes.forgetPassword.name),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.lg.w, AppSpacing.md.h, AppSpacing.lg.w, AppSpacing.md.h),
              child: PrimaryTextButton(
                appButtonSize: AppButtonSize.xlarge,
                label: context.localizations.logout,
                overriddenBackgroundColor: context.colors.error,
                onTap: () {
                  context.goNamed(AppRoutes.login.name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
