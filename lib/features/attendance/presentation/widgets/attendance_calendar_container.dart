import 'package:flutter/material.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/attendance_calendar_widget.dart';

class AttendanceCalendarContainer extends StatefulWidget {
  const AttendanceCalendarContainer({
    this.onDaySelected,
    this.eventMarkerDates = const [],
    super.key,
  });

  final void Function(DateTime selectedDay, DateTime focusedDay)? onDaySelected;
  final List<DateTime> eventMarkerDates;

  @override
  State<AttendanceCalendarContainer> createState() => _AttendanceCalendarContainerState();
}

class _AttendanceCalendarContainerState extends State<AttendanceCalendarContainer> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AttendanceCalendarWidget(
          focusedDay: _focusedDay,
          key: ValueKey(_focusedDay),
          onDaySelected: widget.onDaySelected,
          eventMarkerDates: widget.eventMarkerDates,
        ),
      ],
    );
  }
}
