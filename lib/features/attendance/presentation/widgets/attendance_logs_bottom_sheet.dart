import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_logs_response_model.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_details_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class AttendanceLogsBottomSheet extends StatelessWidget {
  const AttendanceLogsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl.r,
        vertical: AppSpacing.xl.r,
      ),
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg.h,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.localizations.attendanceLogs,
                style: context.typography.semiBold18,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  size: 24.r,
                  color: context.colors.onSurface,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          // Logs list
          BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
            buildWhen: (prev, curr) =>
                prev.attendanceLogsStatus != curr.attendanceLogsStatus ||
                prev.attendanceLogsResponse != curr.attendanceLogsResponse,
            builder: (context, state) {
              // Loading state
              if (state.attendanceLogsStatus == AttendanceLogsStatus.loading) {
                return SizedBox(
                  height: 300.h,
                  child: ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
                    itemBuilder: (context, index) => _LogItemShimmer(),
                  ),
                );
              }

              // Error state
              if (state.attendanceLogsStatus == AttendanceLogsStatus.error) {
                return SizedBox(
                  height: 300.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppSpacing.md.h,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.r,
                          color: context.colors.error,
                        ),
                        Text(
                          state.logsError ?? context.localizations.somethingWentWrong,
                          style: context.typography.regular14,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Success state
              final logs = state.attendanceLogsResponse?.result?.data ?? [];

              if (logs.isEmpty) {
                return SizedBox(
                  height: 300.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: AppSpacing.md.h,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48.r,
                          color: context.colors.onSurfaceVariant,
                        ),
                        Text(
                          context.localizations.noAttendanceLogsFound,
                          style: context.typography.regular14,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: logs.length,
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _LogItem(log: log);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  const _LogItem({required this.log});

  final Datum log;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final actionTime = log.actionDatetime;

    String formattedTime;
    if (actionTime != null) {
      // Format the DateTime object directly
      // Check if we need to convert from UTC to local
      final localTime = actionTime.isUtc ? actionTime.toLocal() : actionTime;

      final hour = localTime.hour;
      final minute = localTime.minute;
      final period = hour >= 12 ? context.localizations.timePeriodPm : context.localizations.timePeriodAm;
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;

      final hourStr = hour12.toString();
      final minuteStr = minute.toString().padLeft(2, '0');

      if (isArabic) {
        final arabicHour = _convertToArabicNumerals(hourStr);
        final arabicMinute = _convertToArabicNumerals(minuteStr);
        // Hide minutes if they are 0, like formatTimeToArabic does
        formattedTime = minute == 0 ? '$arabicHour $period' : '$arabicHour:$arabicMinute $period';
      } else {
        // Hide minutes if they are 0, like formatTimeToArabic does
        formattedTime = minute == 0 ? '$hourStr $period' : '$hourStr:$minuteStr $period';
      }
    } else {
      formattedTime = '--:--';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.r,
        vertical: AppSpacing.lg.r,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: context.colors.infoContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fingerprint,
              size: 24.r,
              color: context.colors.info,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs.h,
              children: [
                Text(
                  context.localizations.punch,
                  style: context.typography.semiBold14,
                ),
                Directionality(
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: Text(
                    formattedTime,
                    style: context.typography.medium14.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _convertToArabicNumerals(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    var result = input;
    for (var i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }
}

class _LogItemShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceVariant,
      highlightColor: context.colors.surface,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.r,
          vertical: AppSpacing.lg.r,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs.h,
                children: [
                  Container(
                    width: 120.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                    ),
                  ),
                  Container(
                    width: 80.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
