import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class NewRequestSection extends StatelessWidget {
  const NewRequestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.r,
        vertical: AppSpacing.xl.r,
      ),
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      ),
      child: Column(
        spacing: AppSpacing.md.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.localizations.newRequest,
            style: context.typography.semiBold16,
          ),
          const AppDivider(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              spacing: AppSpacing.md.w,
              children: [
                RequestItem(
                  title: context.localizations.attendanceCorrection,
                  onTap: () {
                    context.pushNamed(AppRoutes.punchCorrection.name);
                  },
                ),
                RequestItem(
                  title: context.localizations.workMission,
                  onTap: () {
                    context.pushNamed(AppRoutes.workMission.name);
                  },
                ),
                RequestItem(
                  title: context.localizations.holidayRequest,
                  onTap: () {
                    context.pushNamed(AppRoutes.holidayRequest.name);
                  },
                ),
                RequestItem(
                  title: context.localizations.permissionRequest,
                  onTap: () {
                    context.pushNamed(AppRoutes.permissionRequest.name);
                  },
                ),
                RequestItem(
                  title: context.localizations.resignation,
                  onTap: () {
                    context.pushNamed(AppRoutes.resignation.name);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestItem extends StatelessWidget {
  const RequestItem({
    required this.title,
    required this.onTap,
    super.key,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
          ),
        ),
        onPressed: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.r,
              vertical: AppSpacing.xxxxl.r,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: context.typography.semiBold16,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
