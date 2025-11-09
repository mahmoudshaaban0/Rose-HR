import 'package:flutter/material.dart';
import 'package:rose_hr/common/helpers/adapt.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/attendance_calendar_container.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/work_hours_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventDates = [
      DateTime(2025, 3, 4),
      DateTime(2025, 3, 10),
      DateTime(2025, 3, 15),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          spacing: AppSpacing.md.h(context),
          children: [
            SizedBox(height: AppSpacing.md.h(context)),
            AttendanceCalendarContainer(
              eventMarkerDates: eventDates,
              onDaySelected: (selectedDay, focusedDay) {},
            ),
            const WorkHoursSection(),
          ],
        ),
      ),
    );
  }
}
