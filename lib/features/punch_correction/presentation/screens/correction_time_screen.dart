import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/common/widgets/app_radio_button.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/punch_correction/data/models/attendance_method_enum.dart';
import 'package:rose_hr/features/punch_correction/presentation/cubit/punch_correction_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class CorrectionTimeScreen extends StatefulWidget {
  const CorrectionTimeScreen({required this.cubit, super.key});
  final PunchCorrectionCubit cubit;

  @override
  State<CorrectionTimeScreen> createState() => _CorrectionTimeScreenState();
}

class _CorrectionTimeScreenState extends State<CorrectionTimeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch attendance logs for today's date by default, or the selected date
    _fetchLogsForCurrentDate();
  }

  void _fetchLogsForCurrentDate() {
    final state = widget.cubit.state;
    final dateToFetch = state.date != null
        ? TimezoneHelper.format(
            TimezoneHelper.createTimestamp(DateTime.parse(state.date!)),
            pattern: 'yyyy-MM-dd',
            locale: 'en',
          )
        : TimezoneHelper.format(
            TimezoneHelper.createTimestamp(TimezoneHelper.now()),
            pattern: 'yyyy-MM-dd',
            locale: 'en',
          );
    widget.cubit.fetchAttendanceLogs(dateToFetch);
  }

  String _formatTimeOnly(DateTime dateTime) {
    // Convert to local timezone using TimezoneHelper and format as time only
    final localTime = TimezoneHelper.toLocalTimezone(dateTime);
    return TimezoneHelper.format(
      localTime,
      pattern: 'hh:mm a',
      locale: 'en',
    );
  }

  double _dateTimeToDecimalHours(DateTime dateTime) {
    // Convert to local timezone to get correct hour/minute
    final localTime = TimezoneHelper.toLocalTimezone(dateTime);
    return localTime.hour + (localTime.minute / 60.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PrimaryAppBar(title: context.localizations.punchCorrection),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: AppSpacing.md.h,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl.r, vertical: AppSpacing.xl.h),
                            decoration: BoxDecoration(
                              color: context.colors.containerBackground,
                            ),
                            child: Column(
                              spacing: AppSpacing.lg.h,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                  builder: (context, state) {
                                    return AppRadioButton<String>(
                                      value: AttendanceMethod.manual.id,
                                      groupValue: state.attendanceMethod,
                                      onChanged: (value) {
                                        if (value != null) {
                                          AppLogger.instance.logDebug('selected attendance method: $value');
                                          context.read<PunchCorrectionCubit>().selectAttendanceMethod(value);
                                        }
                                      },
                                      label: context.localizations.enterTimeManually,
                                    );
                                  },
                                ),
                                const AppDivider(),
                                BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                  builder: (context, state) {
                                    return AppRadioButton<String>(
                                      value: AttendanceMethod.attendanceLog.id,
                                      groupValue: state.attendanceMethod,
                                      onChanged: (value) {
                                        if (value != null) {
                                          AppLogger.instance.logDebug('selected attendance method: $value');
                                          context.read<PunchCorrectionCubit>().selectAttendanceMethod(value);
                                        }
                                      },
                                      label: context.localizations.selectFromRecordedFingerprints,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl.r, vertical: AppSpacing.xl.h),
                            decoration: BoxDecoration(
                              color: context.colors.containerBackground,
                            ),
                            child: Column(
                              spacing: AppSpacing.lg.h,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                  builder: (context, state) {
                                    if (state.attendanceMethod == AttendanceMethod.attendanceLog.id) {
                                      // Show loading shimmer
                                      if (state.attendanceLogsStatus == AttendanceLogsStatus.loading) {
                                        return Shimmer.fromColors(
                                          baseColor: context.colors.surfaceVariant,
                                          highlightColor: context.colors.containerBackground,
                                          child: Column(
                                            children: List.generate(
                                              3,
                                              (index) => Padding(
                                                padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
                                                child: Container(
                                                  height: 40.h,
                                                  decoration: BoxDecoration(
                                                    color: context.colors.containerBackground,
                                                    borderRadius: BorderRadius.circular(AppSpacing.md.r),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      // Show error message
                                      if (state.attendanceLogsStatus == AttendanceLogsStatus.error) {
                                        return Center(
                                          child: Text(
                                            state.errorMessage ?? context.localizations.anErrorOccurred,
                                            style: context.typography.regular16.copyWith(
                                              color: context.colors.error,
                                            ),
                                          ),
                                        );
                                      }

                                      // Show attendance logs
                                      final logs = state.attendanceLogs?.result?.data ?? [];

                                      if (logs.isEmpty) {
                                        return Center(
                                          child: Text(
                                            context.localizations.noData,
                                            style: context.typography.regular16.copyWith(
                                              color: context.colors.onSurfaceVariant,
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: logs.length,
                                        separatorBuilder: (context, index) {
                                          return const AppDivider();
                                        },
                                        itemBuilder: (context, index) {
                                          final log = logs[index];
                                          final logTime = log.actionDatetime;
                                          if (logTime == null) return const SizedBox.shrink();

                                          final decimalHours = _dateTimeToDecimalHours(logTime);

                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
                                            child: AppRadioButton<int>(
                                              value: log.id ?? 0,
                                              groupValue: state.attendanceLogId,
                                              labelStyle: context.typography.regular18.copyWith(
                                                color: context.colors.onSurface,
                                              ),
                                              onChanged: (value) {
                                                if (value != null && log.id != null) {
                                                  context.read<PunchCorrectionCubit>().selectLogTime(
                                                    decimalHours,
                                                    log.id!,
                                                  );
                                                  // Go back to previous screen after selection
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              label: _formatTimeOnly(logTime),
                                            ),
                                          );
                                        },
                                      );
                                    } else if (state.attendanceMethod == AttendanceMethod.manual.id) {
                                      return CupertinoActionSheet(
                                        actions: [
                                          SizedBox(
                                            height: 200.h,
                                            child: Localizations.override(
                                              context: context,
                                              locale: const Locale('en', 'US'),
                                              child: CupertinoDatePicker(
                                                onDateTimeChanged: (DateTime date) {
                                                  final duration = date.hour + (date.minute / 60.0);
                                                  final cubit = context.read<PunchCorrectionCubit>();
                                                  if (cubit.state.correctionType == 'in') {
                                                    cubit.selectStartTime(duration);
                                                  } else if (cubit.state.correctionType == 'out') {
                                                    cubit.selectEndTime(duration);
                                                  }
                                                },
                                                initialDateTime: DateTime(2000, 1, 1, 0, 30),
                                                mode: CupertinoDatePickerMode.time,
                                              ),
                                            ),
                                          ),
                                        ],
                                        cancelButton: CupertinoButton(
                                          onPressed: () {
                                            final cubit = context.read<PunchCorrectionCubit>();
                                            if (cubit.state.correctionType == 'in' && state.startTime == null) {
                                              cubit.selectStartTime(0.5);
                                            } else if (cubit.state.correctionType == 'out' && state.endTime == null) {
                                              cubit.selectEndTime(0.5);
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(context.localizations.done, style: context.typography.regular16),
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
