import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/helpers/date_helper.dart';
import 'package:rose_hr/common/utility/extensions.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/attendance/data/models/attendance_summary_details_response_model.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_details_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class WorkHoursSection extends StatelessWidget {
  const WorkHoursSection({super.key});

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
          // ── Static title – never changes ─────────────────────────────────
          Text(
            context.localizations.workHours,
            style: context.typography.semiBold16,
          ),
          const AppDivider(),

          // ── Day-off / Leave / Public Holiday banner ──────────────────────
          BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
            buildWhen: (prev, curr) =>
                prev.attendanceSummaryDetailsResponse?.result?.data?.offDay !=
                    curr.attendanceSummaryDetailsResponse?.result?.data?.offDay ||
                prev.attendanceSummaryDetailsResponse?.result?.data?.leave !=
                    curr.attendanceSummaryDetailsResponse?.result?.data?.leave ||
                prev.attendanceSummaryDetailsResponse?.result?.data?.publicOff !=
                    curr.attendanceSummaryDetailsResponse?.result?.data?.publicOff,
            builder: (context, state) {
              final data = state.attendanceSummaryDetailsResponse?.result?.data;
              final isDayOff = data?.offDay ?? false;
              final isLeave = data?.leave ?? false;
              final isPublicOff = data?.publicOff ?? false;
              final description = data?.description;

              if (!isDayOff && !isLeave && !isPublicOff) return const SizedBox.shrink();

              return DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: context.colors.dividerColor,
                  radius: Radius.circular(AppSpacing.lg.r),
                  dashPattern: const [10, 5],
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.r,
                    vertical: AppSpacing.xl.r,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        context.localizations.dayOff,
                        style: context.typography.regular14,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      Text(
                        description.isNullOrEmpty ? context.localizations.enjoyYourHoliday : description!,
                        style: context.typography.semiBold16,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Per-shift work hours sections ─────────────────────────────────
          BlocBuilder<AttendanceDetailsCubit, AttendanceDetailsState>(
            builder: (context, state) {
              // Loading: shimmer placeholders keep the card labels visible
              if (state.status == AttendanceDetailsStatus.loading) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.attendance,
                            child: const _Shimmer(),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.leave,
                            child: const _Shimmer(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.workHours,
                            child: const _Shimmer(),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.difference,
                            child: const _Shimmer(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              final data = state.attendanceSummaryDetailsResponse?.result?.data;
              final shifts = data?.shifts ?? <ShiftData>[];
              final isAbsence = data?.absence ?? false;

              // Absence: show badge on attendance, placeholders for the rest
              if (isAbsence) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.attendance,
                            child: _Badge(
                              label: context.localizations.absent,
                              color: context.colors.error,
                              background: context.colors.errorBadgeBackground,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.leave,
                            child: Text(
                              '--:--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.workHours,
                            child: Text(
                              '--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.difference,
                            child: Text(
                              '--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              // No shifts: single placeholder section
              if (shifts.isEmpty) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.attendance,
                            child: Text(
                              '--:--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.leave,
                            child: Text(
                              '--:--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.workHours,
                            child: Text(
                              '--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md.w),
                        Expanded(
                          child: _InfoCard(
                            label: context.localizations.difference,
                            child: Text(
                              '--',
                              style: context.typography.semiBold16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              // Multiple shifts: render independent sections per shift.
              // The main header + divider above already say "Work Hours" for
              // the first shift, so we only repeat that small header for
              // subsequent shifts.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.md.h,
                children: [
                  // First shift uses the global header
                  _PerShiftWorkHours(shift: shifts.first),
                  // Subsequent shifts: divider + same "Work Hours" header, then section
                  for (var i = 1; i < shifts.length; i++) ...[
                    SizedBox(height: AppSpacing.md.h),
                    Text(
                      context.localizations.workHours,
                      style: context.typography.semiBold16,
                      textAlign: TextAlign.start,
                    ),
                    const AppDivider(),
                    SizedBox(height: AppSpacing.sm.h),
                    _PerShiftWorkHours(shift: shifts[i]),
                    SizedBox(height: AppSpacing.xxl.h),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Value-only widgets – each has its own small BlocBuilder so only the value
// re-renders on state change; the static label card never flickers.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Per-shift work hours section
// ─────────────────────────────────────────────────────────────────────────────
class _PerShiftWorkHours extends StatelessWidget {
  const _PerShiftWorkHours({required this.shift});

  final ShiftData shift;

  @override
  Widget build(BuildContext context) {
    final numericDiff = shift.totalLateTimeValue;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final formattedDiff = formatHoursToArabic(
      shift.totalLateTime,
      useArabicNumerals: isArabic,
      hourSingular: context.localizations.hour,
      hourDual: isArabic ? 'ساعتان' : context.localizations.hours,
      hourPlural: context.localizations.hours,
      minuteSingular: context.localizations.minute,
      minuteDual: isArabic ? 'دقيقتان' : context.localizations.minutes,
      minutePlural: context.localizations.minutes,
    );

    final String displayDiff;
    final Color diffColor;

    if (numericDiff == null) {
      displayDiff = formattedDiff;
      diffColor = context.colors.onSurface;
    } else if (numericDiff < 0) {
      displayDiff = '+ ${formattedDiff.replaceFirst('- ', '')}';
      diffColor = context.colors.success;
    } else {
      displayDiff = '- $formattedDiff';
      diffColor = context.colors.error;
    }

    return Column(
      children: [
        // Row 1: Check-in | Check-out
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                label: context.localizations.attendance,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatTimeToArabic(
                          shift.checkInTime,
                          useArabicNumerals: Localizations.localeOf(context).languageCode == 'ar',
                          amLabel: context.localizations.timePeriodAm,
                          pmLabel: context.localizations.timePeriodPm,
                        ),
                        style: context.typography.semiBold16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    if (shift.hasLateIn)
                      Flexible(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _Badge(
                            label: context.localizations.lateAttendance,
                            color: context.colors.error,
                            background: context.colors.errorBadgeBackground,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _InfoCard(
                label: context.localizations.leave,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        formatTimeToArabic(
                          shift.checkOutTime,
                          useArabicNumerals: Localizations.localeOf(context).languageCode == 'ar',
                          amLabel: context.localizations.timePeriodAm,
                          pmLabel: context.localizations.timePeriodPm,
                        ),
                        style: context.typography.semiBold16,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    if (shift.hasEarlyOut)
                      Flexible(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: _Badge(
                            label: context.localizations.earlyCheckout,
                            color: context.colors.error,
                            background: context.colors.errorBadgeBackground,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md.h),
        // Row 2: Work hours | Difference
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                label: context.localizations.workHours,
                child: Text(
                  formatHoursToArabic(
                    shift.totalWorkTime,
                    useArabicNumerals: Localizations.localeOf(context).languageCode == 'ar',
                    hourSingular: context.localizations.hour,
                    hourDual: Localizations.localeOf(context).languageCode == 'ar' ? 'ساعتان' : context.localizations.hours,
                    hourPlural: context.localizations.hours,
                    minuteSingular: context.localizations.minute,
                    minuteDual: Localizations.localeOf(context).languageCode == 'ar' ? 'دقيقتان' : context.localizations.minutes,
                    minutePlural: context.localizations.minutes,
                  ),
                  style: context.typography.semiBold16,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _InfoCard(
                label: context.localizations.difference,
                child: Text(
                  displayDiff,
                  style: context.typography.semiBold16.copyWith(color: diffColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared card shell – always rendered, label never flickers
// ─────────────────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.r,
        vertical: AppSpacing.xl.r,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs.h,
        children: [
          // Static label – always visible, never inside BlocBuilder
          Text(label, style: context.typography.regular14),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared badge (late / absent / early-out)
// ─────────────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs.r,
        vertical: AppSpacing.xxs.r,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.xs.r),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: context.typography.medium12.copyWith(color: color),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline shimmer – shown in value area while loading
// ─────────────────────────────────────────────────────────────────────────────
class _Shimmer extends StatelessWidget {
  const _Shimmer();

  @override
  Widget build(BuildContext context) {
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
  }
}
