import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/timezone_manager.dart';
import 'package:rose_hr/features/home/presentation/cubit/home_cubit.dart';
import 'package:rose_hr/features/home/presentation/cubit/timezone_cubit.dart';
import 'package:rose_hr/features/home/presentation/widgets/header_shift_section.dart';
import 'package:rose_hr/features/home/presentation/widgets/holidays_section.dart';
import 'package:rose_hr/features/home/presentation/widgets/new_request_section.dart';
import 'package:rose_hr/features/requests/presentation/cubit/pending_manager_requests_cubit.dart';
import 'package:rose_hr/features/requests/presentation/widgets/team_requests_section.dart';
import 'package:rose_hr/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TimezoneCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<PendingRequestsCubit>()..getPendingManagerRequests(),
        ),
        BlocProvider(
          create: (context) => sl<HomeCubit>()..getHome(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  await TimezoneManager.refreshFromGps();
                  if (!context.mounted) return;
                  await Future.wait([
                    context.read<TimezoneCubit>().refreshTimezone(),
                    context
                        .read<PendingRequestsCubit>()
                        .getPendingManagerRequests(),
                    context.read<HomeCubit>().getHome(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    spacing: AppSpacing.md.h,
                    children: [
                      const HeaderAndShiftSection(),
                      const NewRequestSection(),
                      const TeamRequestsSection(),
                      const HolidaysSection(),
                      SizedBox(height: AppSpacing.md.h),
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
