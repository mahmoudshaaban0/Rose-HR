import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/attendance_calendar_container.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/work_hours_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AttendanceCubit>()..init(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PrimaryAppBar(title: context.localizations.attendance),
            body: SafeArea(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  await context.read<AttendanceCubit>().refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    spacing: AppSpacing.md.h,
                    children: [
                      Builder(
                        builder: (context) {
                          return AttendanceCalendarContainer(
                            onDaySelected: (selectedDay, focusedDay) {
                              context.read<AttendanceCubit>().onDaySelected(selectedDay, focusedDay);
                            },
                            onMonthChanged: (focusedDay) {
                              context.read<AttendanceCubit>().onMonthChanged(focusedDay);
                            },
                          );
                        },
                      ),
                      const WorkHoursSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
