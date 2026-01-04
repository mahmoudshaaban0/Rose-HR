import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/helpers/date_helper.dart';
import 'package:rose_hr/common/utility/extensions.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_details_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class WorkHoursSection extends StatelessWidget {
  const WorkHoursSection({super.key});

  /// Helper method to determine if the late-in badge should be shown
  /// Returns true only if lateInTime contains actual late time data
  bool _shouldShowLateInBadge(dynamic lateInTime) {
    // Handle null case
    if (lateInTime == null) return false;

    // Handle boolean false case
    if (lateInTime == false) return false;

    // Handle numeric zero case
    if (lateInTime is num && lateInTime == 0.0) return false;

    // Handle list case (e.g., [0.0])
    if (lateInTime is List) {
      if (lateInTime.isEmpty) return false;
      // Check if all elements are zero
      return lateInTime.any((element) => element != 0.0 && element != 0);
    }

    // If we get here, it's a non-zero value, so show the badge
    return true;
  }

  /// Helper method to determine if the early-out badge should be shown
  /// Returns true only if earlyOutTime contains actual early out time data
  bool _shouldShowEarlyOutBadge(dynamic earlyOutTime) {
    // Handle null case
    if (earlyOutTime == null) return false;

    // Handle boolean false case
    if (earlyOutTime == false) return false;

    // Handle numeric zero case
    if (earlyOutTime is num && earlyOutTime == 0.0) return false;

    // Handle list case (e.g., [0.0])
    if (earlyOutTime is List) {
      if (earlyOutTime.isEmpty) return false;
      // Check if all elements are zero
      return earlyOutTime.any((element) => element != 0.0 && element != 0);
    }

    // If we get here, it's a non-zero value, so show the badge
    return true;
  }

  /// Helper method to extract numeric value from dynamic data
  /// Returns the numeric value or null if invalid
  double? _extractNumericValue(dynamic data) {
    try {
      if (data == null) return null;
      if (data is num) return data.toDouble();
      if (data is List && data.isNotEmpty) {
        final value = data.first;
        if (value is num) return value.toDouble();
        return double.tryParse(value.toString());
      }
      return double.tryParse(data.toString());
    } on FormatException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      ),
      child: Column(
        spacing: AppSpacing.md.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.localizations.workHours,
            style: context.typography.semiBold16,
          ),
          const AppDivider(),
          BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
            builder: (context, state) {
              // data
              final data = state.attendanceSummaryDetailsResponse?.result?.data;
              final isDayOff = data?.offDay;
              final isLeave = data?.leave;
              final isPublicOff = data?.publicOff;
              final description = data?.description;
              return Visibility(
                visible: (isDayOff ?? false) || (isLeave ?? false) || (isPublicOff ?? false),
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: context.colors.dividerColor,
                    radius: Radius.circular(AppSpacing.lg.r),
                    dashPattern: [10, 5],
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'يوم راحة',
                          style: context.typography.regular14,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          description.isNullOrEmpty ? 'استمتع في عطلتك، لبداية اسبوع مُثمر' : description!,
                          style: context.typography.semiBold16,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localizations.attendance,
                        style: context.typography.regular14,
                      ),
                      BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
                        builder: (context, state) {
                          if (state.status == AttendanceDetailsStatus.loading) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // i need a shimmer effect
                                Shimmer.fromColors(
                                  baseColor: context.colors.surfaceVariant,
                                  highlightColor: context.colors.surface,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.colors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                                    ),
                                    width: 50.w,
                                    height: 18.h,
                                  ),
                                ),
                              ],
                            );
                          } else if (state.status == AttendanceDetailsStatus.success) {
                            final data = state.attendanceSummaryDetailsResponse?.result?.data;
                            final isAbsence = data?.absence;
                            // checkintime
                            final checkInTime = data?.checkInTime;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // if the user is not absent, show the check in time
                                if (!(isAbsence ?? false))
                                  Flexible(
                                    child: Text(
                                      formatTimeToArabic(checkInTime),
                                      style: context.typography.semiBold16,
                                    ),
                                  ),
                                // if the user is absent, show the absent badge
                                Visibility(
                                  visible: isAbsence ?? false,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF3F1),
                                      borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                                      border: Border.all(color: context.colors.error),
                                    ),
                                    child: Text(
                                      'غائب',
                                      style: context.typography.medium12.copyWith(color: context.colors.error),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _shouldShowLateInBadge(data?.lateInTime),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF3F1),
                                      borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                                      border: Border.all(color: context.colors.error),
                                    ),
                                    child: Text(
                                      'حضور متأخر',
                                      style: context.typography.medium12.copyWith(color: context.colors.error),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '--:--',
                                    style: context.typography.semiBold16,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localizations.leave,
                        style: context.typography.regular14,
                      ),
                      BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
                        builder: (context, state) {
                          if (state.status == AttendanceDetailsStatus.loading) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: context.colors.surfaceVariant,
                                  highlightColor: context.colors.surface,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: context.colors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                                    ),
                                    width: 50.w,
                                    height: 18.h,
                                  ),
                                ),
                              ],
                            );
                          } else if (state.status == AttendanceDetailsStatus.success) {
                            final data = state.attendanceSummaryDetailsResponse?.result?.data;
                            final checkOutTime = data?.checkOutTime;
                            final earlyOutTime = data?.earlyOutTime;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    formatTimeToArabic(checkOutTime),
                                    style: context.typography.semiBold16,
                                  ),
                                ),
                                Visibility(
                                  visible: _shouldShowEarlyOutBadge(earlyOutTime),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.r, vertical: AppSpacing.xxs.r),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFF3F1),
                                      borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                                      border: Border.all(color: context.colors.error),
                                    ),
                                    child: Text(
                                      'إنصراف مبكر',
                                      style: context.typography.medium12.copyWith(color: context.colors.error),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '--:--',
                                    style: context.typography.semiBold16,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localizations.workHours,
                        style: context.typography.regular14,
                      ),
                      BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
                        builder: (context, state) {
                          if (state.status == AttendanceDetailsStatus.loading) {
                            return Shimmer.fromColors(
                              baseColor: context.colors.surfaceVariant,
                              highlightColor: context.colors.surface,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                                ),
                                width: 80.w,
                                height: 18.h,
                              ),
                            );
                          } else if (state.status == AttendanceDetailsStatus.success) {
                            final data = state.attendanceSummaryDetailsResponse?.result?.data;
                            final totalWorkTime = data?.totalWorkTime;
                            return Text(
                              formatHoursToArabic(totalWorkTime),
                              style: context.typography.semiBold16,
                            );
                          } else {
                            return Text(
                              '--',
                              style: context.typography.semiBold16,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.r, vertical: AppSpacing.xl.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.localizations.difference,
                        style: context.typography.regular14,
                      ),
                      BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
                        builder: (context, state) {
                          if (state.status == AttendanceDetailsStatus.loading) {
                            return Shimmer.fromColors(
                              baseColor: context.colors.surfaceVariant,
                              highlightColor: context.colors.surface,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                                ),
                                width: 80.w,
                                height: 18.h,
                              ),
                            );
                          } else if (state.status == AttendanceDetailsStatus.success) {
                            final data = state.attendanceSummaryDetailsResponse?.result?.data;
                            final totalLateTime = data?.totalLateTime;

                            // Extract numeric value to determine sign
                            final numericValue = _extractNumericValue(totalLateTime);
                            final formattedTime = formatHoursToArabic(totalLateTime);

                            // Determine display based on numeric value
                            // totalLateTime logic:
                            // - Positive value = deficit/late (worked less than required) → show with - prefix
                            // - Negative value = overtime (worked more than required) → show with + prefix
                            // - Zero or null → show as is without prefix
                            final String displayTime;
                            if (numericValue == null || numericValue == 0) {
                              displayTime = formattedTime;
                            } else if (numericValue < 0) {
                              // Negative value = overtime, remove the - and add +
                              displayTime = '+ ${formattedTime.replaceFirst('- ', '')}';
                            } else {
                              // Positive value = deficit/late, add - prefix
                              displayTime = '- $formattedTime';
                            }

                            return Text(
                              displayTime,
                              style: context.typography.semiBold16.copyWith(
                                color: numericValue != null && numericValue < 0 ? context.colors.error : context.colors.success,
                              ),
                            );
                          } else {
                            return Text(
                              '--',
                              style: context.typography.semiBold16,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
