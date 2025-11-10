import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/theme/app_colors.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendarWidget extends StatefulWidget {
  const AttendanceCalendarWidget({
    required this.focusedDay,
    this.onDaySelected,
    this.eventMarkerDates = const [],
    super.key,
  });

  final DateTime focusedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final List<DateTime> eventMarkerDates;

  @override
  State<AttendanceCalendarWidget> createState() => _AttendanceCalendarWidgetState();
}

class _AttendanceCalendarWidgetState extends State<AttendanceCalendarWidget> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasEvent(DateTime day) {
    return widget.eventMarkerDates.any((eventDate) => _isSameDay(eventDate, day));
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final formatter = DateFormat('MMMM yyyy', locale.toString());
    // Initialize intl for the calendar
    Intl.defaultLocale = locale.toString();

    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSpacing.md.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.chevron_left,
                size: 24,
              ),
              Text(
                formatter.format(DateTime.now()),
                style: context.typography.semiBold16,
              ),
              const Icon(
                Icons.chevron_right,
                size: 24,
              ),
            ],
          ),
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: widget.focusedDay,
            locale: locale.toString(),
            selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              widget.onDaySelected?.call(selectedDay, focusedDay);
            },
            headerVisible: false,
            weekendDays: const [DateTime.friday, DateTime.saturday],
            daysOfWeekHeight: 40.h,
            rowHeight: 50.h,

            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: context.typography.regular14.copyWith(
                color: colors.iconSubtle,
              ),
              weekendStyle: context.typography.regular14.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(4),
              defaultDecoration: BoxDecoration(
                border: Border.all(color: colors.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              selectedDecoration: BoxDecoration(
                color: colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.dividerColor),
              ),
              todayDecoration: BoxDecoration(
                border: Border.all(color: colors.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              outsideDecoration: BoxDecoration(
                border: Border.all(color: colors.dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              weekendDecoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              disabledDecoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              defaultTextStyle: context.typography.medium16,
              selectedTextStyle: context.typography.medium16.copyWith(color: colors.white),
              todayTextStyle: context.typography.medium16.copyWith(color: colors.onSurface),
              weekendTextStyle: context.typography.medium16.copyWith(color: Color(0xffDBCCBB)),
              outsideTextStyle: context.typography.regular14.copyWith(color: colors.textDisabled),
              disabledTextStyle: context.typography.regular14.copyWith(color: colors.textDisabled),
              markerDecoration: BoxDecoration(
                color: colors.error,
                shape: BoxShape.circle,
              ),
              markerSize: 6,
              markersMaxCount: 1,
            ),
            calendarBuilders: CalendarBuilders(
              outsideBuilder: (context, day, focusedDay) {
                // Hide dates from other months
                return const SizedBox.shrink();
              },
              markerBuilder: (context, date, events) {
                if (_hasEvent(date)) {
                  return Positioned(
                    bottom: 8,
                    child: Container(
                      width: 6,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
