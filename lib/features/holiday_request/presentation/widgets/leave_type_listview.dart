import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/holiday_request/presentation/bloc/holiday_request_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class LeaveTypeListView extends StatefulWidget {
  const LeaveTypeListView({super.key});

  @override
  State<LeaveTypeListView> createState() => _LeaveTypeListViewState();
}

class _LeaveTypeListViewState extends State<LeaveTypeListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
      builder: (context, state) {
        // Show shimmer loading effect
        if (state.status == HolidayRequestStatus.loading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
            child: Column(
              spacing: AppSpacing.md.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.localizations.leaveType, style: context.typography.semiBold16),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const AppDivider(),
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: context.colors.surfaceVariant,
                        highlightColor: context.colors.containerBackground,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.lg.h,
                            horizontal: AppSpacing.lg.r,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                                ),
                                width: 300.w,
                                height: 16.h,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        final leaveTypes = state.leaveTypesResponseModel?.result?.data;

        if (leaveTypes == null || leaveTypes.isEmpty) {
          return Center(
            child: Text(
              context.localizations.noLeaveTypesAvailable,
              style: context.typography.regular16,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
          child: Column(
            spacing: AppSpacing.md.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.localizations.leaveType, style: context.typography.semiBold16),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemCount: leaveTypes.length,
                  itemBuilder: (context, index) {
                    final leaveType = leaveTypes[index];
                    final isSelected = state.selectedLeaveTypeId == leaveType.id;

                    return InkWell(
                      onTap: () {
                        context.read<HolidayRequestCubit>().selectLeaveType(
                          leaveType.name ?? '',
                          leaveType.id ?? 0,
                        );
                        context.pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.lg.h,
                          horizontal: AppSpacing.lg.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              leaveType.name ?? '',
                              style: isSelected ? context.typography.medium16 : context.typography.regular16,
                            ),
                            if (isSelected) const AppVectorGraphic(path: Assets.vectorsCheckline),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
