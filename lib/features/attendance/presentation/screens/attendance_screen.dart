import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/date_helper.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/helpers/timezone_manager.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:rose_hr/features/attendance/presentation/cubit/attendance_details_cubit.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/attendance_calendar_container.dart';
import 'package:rose_hr/features/attendance/presentation/widgets/work_hours_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:timezone/timezone.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // selected
        BlocProvider(create: (context) => sl<AttendanceCubit>()..init()),
        BlocProvider(
          create: (context) {
            final selectedDate = TimezoneHelper.convertToLocal(TZDateTime.now(TimezoneManager.location)).toLocal();
            return sl<AttendanceDetailsCubit>()..getAttendanceSummaryByDate(dateTimeToString(selectedDate));
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     context.pushNamed(AppRoutes.holidayRequest.name);
            //   },
            //   child: const Icon(Icons.add),
            // ),
            appBar: PrimaryAppBar(title: context.localizations.attendance),
            body: SafeArea(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  final attendanceCubit = context.read<AttendanceCubit>();
                  final detailsCubit = context.read<AttendanceDetailsCubit>();
                  final selectedDay = attendanceCubit.state.selectedDay;
                  await Future.wait([
                    attendanceCubit.refresh(),
                    detailsCubit.getAttendanceSummaryByDate(dateTimeToString(selectedDay)),
                  ]);
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
                              final dateString = dateTimeToString(selectedDay);
                              context.read<AttendanceDetailsCubit>().getAttendanceSummaryByDate(dateString);
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
