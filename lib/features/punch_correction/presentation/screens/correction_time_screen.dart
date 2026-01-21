import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/common/widgets/app_radio_button.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/punch_correction/data/models/attendance_method_enum.dart';
import 'package:rose_hr/features/punch_correction/presentation/cubit/punch_correction_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CorrectionTimeScreen extends StatefulWidget {
  const CorrectionTimeScreen({required this.cubit, super.key});
  final PunchCorrectionCubit cubit;

  @override
  State<CorrectionTimeScreen> createState() => _CorrectionTimeScreenState();
}

class _CorrectionTimeScreenState extends State<CorrectionTimeScreen> {
  bool isManualTime = false;
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
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: 5,
                                        separatorBuilder: (context, index) {
                                          return const AppDivider();
                                        },
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h),
                                            child: AppRadioButton<bool>(
                                              value: true,
                                              groupValue: isManualTime,
                                              labelStyle: context.typography.regular18.copyWith(
                                                color: context.colors.onSurface,
                                              ),
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              label: '11:30',
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
                                                  // Calculate duration in hours from the selected time
                                                  final duration = date.hour + (date.minute / 60.0);
                                                  final cubit = context.read<PunchCorrectionCubit>();
                                                  // Use startTime for check-in, endTime for check-out
                                                  if (cubit.state.correctionType == 'in') {
                                                    cubit.selectStartTime(duration);
                                                  } else if (cubit.state.correctionType == 'out') {
                                                    cubit.selectEndTime(duration);
                                                  }
                                                },
                                                initialDateTime: DateTime(2000, 1, 1, 0, 30), // Start at 0:30 (0.5 hours)
                                                mode: CupertinoDatePickerMode.time,
                                              ),
                                            ),
                                          ),
                                        ],
                                        cancelButton: CupertinoButton(
                                          onPressed: () {
                                            final cubit = context.read<PunchCorrectionCubit>();
                                            // Set default time if none selected
                                            if (cubit.state.correctionType == 'in' && state.startTime == null) {
                                              cubit.selectStartTime(0.5); // Default to 30 minutes
                                            } else if (cubit.state.correctionType == 'out' && state.endTime == null) {
                                              cubit.selectEndTime(0.5); // Default to 30 minutes
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
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                  //   child: PrimaryTextButton(
                  //     label: context.localizations.submit,
                  //     onTap: () {},
                  //     appButtonSize: AppButtonSize.xxLarge,
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
