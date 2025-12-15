import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/attendance_calendar_container.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/work_hours_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

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
      appBar: PrimaryAppBar(title: context.localizations.attendance),
      body: SafeArea(
        child: Column(
          spacing: AppSpacing.md.h,
          children: [
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
