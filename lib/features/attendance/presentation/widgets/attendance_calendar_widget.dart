import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/helpers/toast_service.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class AttendanceCalendarWidget extends StatefulWidget {
  const AttendanceCalendarWidget({
    required this.focusedDay,
    this.onDaySelected,
    this.onMonthChanged,
    this.timezone = AppTimezone.egypt,
    super.key,
  });

  final DateTime focusedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final void Function(DateTime focusedDay)? onMonthChanged;

  /// The timezone to use for displaying dates and determining "today"
  final AppTimezone timezone;

  @override
  State<AttendanceCalendarWidget> createState() => _AttendanceCalendarWidgetState();
}

class _AttendanceCalendarWidgetState extends State<AttendanceCalendarWidget> {
  late tz.TZDateTime _selectedDay;
  late tz.TZDateTime _focusedDay;

  /// Get the current time in the configured timezone
  tz.TZDateTime get _now => TimezoneHelper.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _now;
    _focusedDay = TimezoneHelper.toTimezone(widget.focusedDay, widget.timezone);
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDay = tz.TZDateTime(
        _focusedDay.location,
        _focusedDay.year,
        _focusedDay.month - 1,
      );
    });
    widget.onMonthChanged?.call(_focusedDay);
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = tz.TZDateTime(
        _focusedDay.location,
        _focusedDay.year,
        _focusedDay.month + 1,
      );
    });
    widget.onMonthChanged?.call(_focusedDay);
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formatter = DateFormat('MMMM yyyy', locale.toString());
    // Initialize intl for the calendar
    Intl.defaultLocale = locale.toString();

    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state.status == AttendanceStatus.error) {
          ToastService.showError(state.error ?? context.localizations.anErrorOccurred);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AttendanceStatus.loading;

        return Container(
          decoration: BoxDecoration(
            color: context.colors.containerBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSpacing.md.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: isLoading ? null : _goToPreviousMonth,
                      child: Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: isLoading ? context.colors.textDisabled : null,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatter.format(_focusedDay),
                          style: context.typography.semiBold16,
                        ),
                        if (isLoading) ...[
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colors.info,
                            ),
                          ),
                        ],
                      ],
                    ),
                    GestureDetector(
                      onTap: isLoading ? null : _goToNextMonth,
                      child: Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: isLoading ? context.colors.textDisabled : null,
                      ),
                    ),
                  ],
                ),
                TableCalendar(
                  firstDay: DateTime(2024),
                  lastDay: DateTime(2030, 12, 31),
                  focusedDay: _focusedDay,
                  locale: locale.toString(),
                  selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
                  onDaySelected: isLoading
                      ? null
                      : (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = TimezoneHelper.toTimezone(selectedDay, widget.timezone);
                            _focusedDay = TimezoneHelper.toTimezone(focusedDay, widget.timezone);
                          });
                          widget.onDaySelected?.call(selectedDay, focusedDay);
                        },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = TimezoneHelper.toTimezone(focusedDay, widget.timezone);
                    });
                    widget.onMonthChanged?.call(focusedDay);
                  },
                  headerVisible: false,
                  weekendDays: const [DateTime.friday, DateTime.saturday],
                  daysOfWeekHeight: 40.h,
                  rowHeight: 50.h,

                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: context.typography.regular14.copyWith(
                      color: context.colors.iconSubtle,
                    ),
                    weekendStyle: context.typography.regular14.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    cellMargin: const EdgeInsets.all(4),
                    defaultDecoration: BoxDecoration(
                      border: Border.all(color: context.colors.dividerColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: context.colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.colors.dividerColor),
                    ),
                    todayDecoration: BoxDecoration(
                      border: Border.all(color: context.colors.dividerColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    weekendDecoration: BoxDecoration(
                      color: context.colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledDecoration: BoxDecoration(
                      color: context.colors.surface.withValues(alpha: 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    defaultTextStyle: context.typography.medium16,
                    selectedTextStyle: context.typography.medium16.copyWith(color: context.colors.white),
                    todayTextStyle: context.typography.medium16.copyWith(color: context.colors.onSurface),
                    weekendTextStyle: context.typography.medium16.copyWith(color: context.colors.weekendColor),
                    disabledTextStyle: context.typography.regular14.copyWith(color: context.colors.textDisabled),
                    markerDecoration: BoxDecoration(
                      color: context.colors.error,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    markersMaxCount: 1,
                  ),
                  calendarBuilders: CalendarBuilders(
                    // Custom builder for default days to show attendance status
                    defaultBuilder: (context, day, focusedDay) {
                      return _buildDayCell(context, day, state, isSelected: false, isToday: false);
                    },
                    // Custom builder for today
                    todayBuilder: (context, day, focusedDay) {
                      return _buildDayCell(context, day, state, isSelected: false, isToday: true);
                    },
                    // Custom builder for selected day
                    selectedBuilder: (context, day, focusedDay) {
                      return _buildDayCell(context, day, state, isSelected: true, isToday: false);
                    },
                    // Custom builder for weekend days
                    holidayBuilder: (context, day, focusedDay) {
                      return _buildDayCell(context, day, state, isSelected: false, isToday: false, isWeekend: true);
                    },
                    markerBuilder: (context, date, events) {
                      // Markers are now handled in the custom day builders
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build a custom day cell with attendance status markers
  Widget _buildDayCell(
    BuildContext context,
    DateTime day,
    AttendanceState state, {
    required bool isSelected,
    required bool isToday,
    bool isWeekend = false,
  }) {
    final hasIncomplete = state.hasIncompleteAttendance(day);
    final isOffDay = state.isOffDay(day);
    final isPublicOff = state.isPublicOff(day);
    final isLeave = state.isLeaveDay(day);
    final isAbsenceDay = state.isAbsenceDay(day);
    // Determine cell background color based on attendance status
    Color? backgroundColor;
    var borderColor = context.colors.dividerColor;
    var textStyle = context.typography.medium16;

    if (isSelected && (hasIncomplete || isAbsenceDay)) {
      // Selected day with incomplete attendance or absence - red background
      backgroundColor = context.colors.error;
      textStyle = textStyle.copyWith(color: context.colors.white);
      borderColor = context.colors.error;
    } else if (isSelected) {
      backgroundColor = context.colors.black;
      textStyle = textStyle.copyWith(color: context.colors.white);
    } else if (isOffDay || isWeekend) {
      // Weekend/off day - subtle background
      backgroundColor = context.colors.surfaceContainerLow;
      textStyle = textStyle.copyWith(color: context.colors.weekendColor);
    } else if (isToday) {
      borderColor = context.colors.info;
      textStyle = textStyle.copyWith(color: context.colors.onSurface);
    } else if (isLeave) {
      backgroundColor = context.colors.surfaceContainerLow;
      textStyle = textStyle.copyWith(color: context.colors.weekendColor);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Public holiday triangle marker - top left corner
          if (isPublicOff)
            Positioned(
              top: 0,
              left: 0,
              child: ClipPath(
                clipper: _TopLeftTriangleClipper(),
                child: Container(width: 16.w, height: 16.w, color: context.colors.containerBorder),
              ),
            ),
          // Day number
          Center(
            child: Text('${day.day}', style: textStyle),
          ),
          // Leave marker - blue dot at bottom
          // if (isLeave)
          //   Positioned(
          //     bottom: 6.h,
          //     child: Container(
          //       width: 6.w,
          //       height: 6.w,
          //       decoration: BoxDecoration(color: context.colors.leaveColor, shape: BoxShape.circle),
          //     ),
          //   ),
          // Incomplete attendance or absence marker - red dot at bottom (if leave is not shown)
          if ((hasIncomplete || isAbsenceDay) && !isLeave)
            Positioned(
              bottom: 6.h,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(color: context.colors.error, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom clipper to create a triangle in the top-left corner
class _TopLeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
