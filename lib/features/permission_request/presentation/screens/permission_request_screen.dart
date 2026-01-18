import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/helpers/toast_service.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_type_model.dart';
import 'package:rose_hr/features/permission_request/data/models/shift_id_response_model.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/permission_request_cubit.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_cubit.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_state.dart';
import 'package:rose_hr/features/permission_request/presentation/widgets/payment_type_listview.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  State<PermissionRequestScreen> createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// Validates and submits the permission request
  void _submitPermissionRequest(BuildContext context, PermissionRequestState state) {
    // Validate required fields
    if (state.permissionTypeId == null) {
      ToastService.showError('Please select permission type');
      return;
    }

    if (state.date == null) {
      ToastService.showError('Please select a date');
      return;
    }

    if (state.shiftId == null) {
      ToastService.showError('Please select a shift');
      return;
    }

    // Type-specific validation
    if (state.permissionTypeId == 'mid_day') {
      if (state.startTime == null || state.endTime == null) {
        ToastService.showError('Please select start and end time');
        return;
      }

      // Validate time range
      final startDateTime = DateTime.parse(state.startTime!);
      final endDateTime = DateTime.parse(state.endTime!);
      final timeFrom = startDateTime.hour + (startDateTime.minute / 60.0);
      final timeTo = endDateTime.hour + (endDateTime.minute / 60.0);

      if (timeTo <= timeFrom) {
        ToastService.showError('End time must be after start time');
        return;
      }
    }

    if ((state.permissionTypeId == 'late_in' || state.permissionTypeId == 'early_out') &&
        state.partialExcuse &&
        state.requestedDuration == null) {
      ToastService.showError('Please specify the requested duration');
      return;
    }

    // Build the request based on permission type
    final request = _buildPermissionRequest(state);

    if (request == null) {
      ToastService.showError('Invalid permission request data');
      return;
    }

    // Submit the request
    context.read<PermissionRequestCubit>().createPermissionRequest(request);
  }

  /// Builds the appropriate permission request model based on the permission type
  PermissionRequestRequestModel? _buildPermissionRequest(PermissionRequestState state) {
    final reason = _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim();

    // Format date as yyyy-MM-dd
    final formattedDate = TimezoneHelper.format(
      TimezoneHelper.createTimestamp(AppTimezone.egypt, DateTime.parse(state.date!)),
      pattern: 'yyyy-MM-dd',
    );

    switch (state.permissionTypeId) {
      case 'mid_day':
        // Validate mid_day specific fields (silent validation, errors shown in submit method)
        if (state.startTime == null || state.endTime == null) {
          return null;
        }

        // Convert ISO8601 time strings to hours (float)
        final startDateTime = DateTime.parse(state.startTime!);
        final endDateTime = DateTime.parse(state.endTime!);

        final timeFrom = startDateTime.hour + (startDateTime.minute / 60.0);
        final timeTo = endDateTime.hour + (endDateTime.minute / 60.0);

        // Validate that end time is after start time (silent validation)
        if (timeTo <= timeFrom) {
          return null;
        }

        return PermissionRequestRequestModel.midDay(
          date: formattedDate,
          shiftId: state.shiftId!,
          timeFrom: timeFrom,
          timeTo: timeTo,
          reason: reason,
        );

      case 'late_in':
        // For late_in with partial excuse (silent validation)
        if (state.partialExcuse && state.requestedDuration == null) {
          return null;
        }

        return PermissionRequestRequestModel.lateIn(
          date: formattedDate,
          shiftId: state.shiftId!,
          partialExcuse: state.partialExcuse,
          requestedDuration: state.requestedDuration ?? 0.0,
          reason: reason,
        );

      case 'early_out':
        // For early_out with partial excuse (silent validation)
        if (state.partialExcuse && state.requestedDuration == null) {
          return null;
        }

        return PermissionRequestRequestModel.earlyOut(
          date: formattedDate,
          shiftId: state.shiftId!,
          partialExcuse: state.partialExcuse,
          requestedDuration: state.requestedDuration ?? 0.0,
          reason: reason,
        );

      default:
        AppLogger.instance.logError('Unknown permission type: ${state.permissionTypeId}');
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PermissionRequestCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ShiftIdCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ShiftIdCubit, ShiftIdState>(
            listener: (context, state) {
              if (state.status == ShiftIdStatus.error) {
                ToastService.showError(
                  state.errorMessage ?? 'Failed to fetch shift information',
                );
              } else if (state.status == ShiftIdStatus.success) {
                // Automatically select the first shift when data is loaded
                final firstShift = state.shiftIdResponseModel?.result?.data?.firstOrNull;
                if (firstShift != null && firstShift.id != null) {
                  context.read<PermissionRequestCubit>().sendShiftId(firstShift.id!);
                  AppLogger.instance.logDebug('Auto-selected first shift: ${firstShift.name} (ID: ${firstShift.id})');
                }
              }
            },
          ),
          BlocListener<PermissionRequestCubit, PermissionRequestState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == PermissionRequestStatus.success) {
                // Check if the business logic succeeded
                final result = state.permissionRequestResponseModel?.result;

                if (result?.statusCode == 200) {
                  // Show success bottom sheet
                  BottomSheetWrapper(
                    initialSize: .34.h,
                    maxChildSize: .34.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                      child: Column(
                        spacing: AppSpacing.md.h,
                        children: [
                          const AppVectorGraphic(path: Assets.vectorsPermissionReqeuestSuccessIcon),
                          Text(
                            'شكرًا لك',
                            style: context.typography.regular16,
                          ),
                          Text(
                            'تم تقديم طلبك بنجاح!',
                            style: context.typography.semiBold28.copyWith(color: context.colors.success),
                          ),
                        ],
                      ),
                    ),
                  ).callSheet(context);
                } else {
                  // Business logic error (e.g., 400 with success: false)
                  ToastService.showError(
                    gravity: ToastGravity.CENTER,
                    result?.message ?? 'Failed to submit permission request',
                  );
                }
              } else if (state.status == PermissionRequestStatus.error) {
                // Network or other errors
                ToastService.showError(
                  gravity: ToastGravity.CENTER,
                  state.errorMessage ?? 'Failed to submit permission request',
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: PrimaryAppBar(title: context.localizations.permissionRequest),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                    child: Column(
                      spacing: AppSpacing.md.h,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r, vertical: AppSpacing.xl.r),
                          decoration: BoxDecoration(
                            color: context.colors.containerBackground,
                            borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                          ),
                          child: Column(
                            spacing: AppSpacing.md.h,
                            children: [
                              BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                                builder: (context, state) {
                                  return InfoCard(
                                    title: context.localizations.permissionDayAndType,
                                    subtitle: state.permissionTypeName ?? context.localizations.permissionRequest,
                                    value: state.permissionTypeName ?? context.localizations.permissionRequest,
                                    subTitlestyle: state.permissionTypeName != null
                                        ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                        : null,
                                    onTap: () {
                                      final cubit = context.read<PermissionRequestCubit>();
                                      debugPrint('selected name: //${state.permissionTypeId}');
                                      BottomSheetWrapper(
                                        initialSize: .3.h,
                                        maxChildSize: .3.h,
                                        child: BlocProvider.value(
                                          value: cubit,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              spacing: AppSpacing.md.h,
                                              children: [
                                                Text('نوع الإستئذان', style: context.typography.semiBold18),
                                                PaymentTypeListview(
                                                  onSelected: (id) {
                                                    AppLogger.instance.logDebug('selected id: ');
                                                    AppLogger.instance.logDebug('selected name: ${state.permissionTypeId}');
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).callSheet(context);
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                                builder: (context, state) {
                                  if (state.permissionTypeId == PermissionType.midDay.id) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: InfoCard(
                                            prefixIcon: Assets.vectorsTime,
                                            title: context.localizations.startTime,
                                            subTitlestyle: state.startTime != null
                                                ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                                : null,
                                            subtitle: state.startTime != null
                                                ? TimezoneHelper.format(
                                                    TimezoneHelper.createTimestamp(
                                                      AppTimezone.egypt,
                                                      DateTime.parse(state.startTime!),
                                                    ),
                                                    locale: 'en',
                                                    pattern: 'hh:mm a',
                                                  )
                                                : '08:00 AM',
                                            value: state.startTime != null
                                                ? TimezoneHelper.format(
                                                    TimezoneHelper.createTimestamp(
                                                      AppTimezone.egypt,
                                                      DateTime.parse(state.startTime!),
                                                    ),
                                                    locale: 'en',
                                                    pattern: 'hh:mm a',
                                                  )
                                                : '08:00 AM',
                                            showArrow: false,
                                            onTap: () {
                                              // Default start time: 8:00 AM
                                              final defaultStartTime = DateTime(2000, 1, 1, 8);
                                              final initialStartTime = state.startTime != null
                                                  ? DateTime.parse(state.startTime!)
                                                  : defaultStartTime;
                                              var selectedStartTime = initialStartTime;

                                              showCupertinoModalPopup<void>(
                                                context: context,
                                                builder: (BuildContext modalContext) {
                                                  return CupertinoActionSheet(
                                                    cancelButton: CupertinoButton(
                                                      onPressed: () {
                                                        // Set the time when user confirms
                                                        context.read<PermissionRequestCubit>().sendStartTimeAndEndTime(
                                                          startTime: selectedStartTime.toIso8601String(),
                                                        );
                                                        Navigator.of(modalContext).pop();
                                                      },
                                                      child: Text(
                                                        context.localizations.done,
                                                        style: context.typography.regular16,
                                                      ),
                                                    ),
                                                    actions: [
                                                      SizedBox(
                                                        height: 200.h,
                                                        child: Localizations.override(
                                                          context: modalContext,
                                                          locale: const Locale(AppStrings.english, 'US'),
                                                          child: CupertinoDatePicker(
                                                            onDateTimeChanged: (DateTime date) {
                                                              selectedStartTime = date;
                                                            },
                                                            initialDateTime: initialStartTime,
                                                            mode: CupertinoDatePickerMode.time,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.md.w),
                                        Expanded(
                                          child: InfoCard(
                                            prefixIcon: Assets.vectorsTime,
                                            title: context.localizations.endTime,
                                            subtitle: state.endTime != null
                                                ? TimezoneHelper.format(
                                                    TimezoneHelper.createTimestamp(
                                                      AppTimezone.egypt,
                                                      DateTime.parse(state.endTime!),
                                                    ),
                                                    locale: 'en',
                                                    pattern: 'a hh:mm',
                                                  )
                                                : '08:00 AM',
                                            subTitlestyle: state.endTime != null
                                                ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                                : null,
                                            value: '',
                                            showArrow: false,
                                            onTap: () {
                                              // Default end time: 9:00 AM (1 hour after default start)
                                              final defaultEndTime = DateTime(2000, 1, 1, 9);
                                              final initialEndTime = state.endTime != null
                                                  ? DateTime.parse(state.endTime!)
                                                  : defaultEndTime;
                                              var selectedEndTime = initialEndTime;

                                              showCupertinoModalPopup<void>(
                                                context: context,
                                                builder: (BuildContext modalContext) {
                                                  return CupertinoActionSheet(
                                                    cancelButton: CupertinoButton(
                                                      onPressed: () {
                                                        // Set the time when user confirms
                                                        context.read<PermissionRequestCubit>().sendStartTimeAndEndTime(
                                                          endTime: selectedEndTime.toIso8601String(),
                                                        );
                                                        Navigator.of(modalContext).pop();
                                                      },
                                                      child: Text(
                                                        context.localizations.done,
                                                        style: context.typography.regular16,
                                                      ),
                                                    ),
                                                    actions: [
                                                      SizedBox(
                                                        height: 200.h,
                                                        child: Localizations.override(
                                                          context: modalContext,
                                                          locale: const Locale(AppStrings.english, 'US'),
                                                          child: CupertinoDatePicker(
                                                            onDateTimeChanged: (DateTime date) {
                                                              selectedEndTime = date;
                                                            },
                                                            initialDateTime: initialEndTime,
                                                            mode: CupertinoDatePickerMode.time,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                                builder: (context, state) {
                                  final cubit = context.read<PermissionRequestCubit>();
                                  final shiftIdCubit = context.read<ShiftIdCubit>();
                                  return InfoCard(
                                    prefixIcon: Assets.vectorsCalendarFill,
                                    title: context.localizations.date,
                                    subtitle: state.date != null
                                        ? TimezoneHelper.format(
                                            TimezoneHelper.createTimestamp(AppTimezone.egypt, DateTime.parse(state.date!)),
                                            locale: 'en',
                                            pattern: 'yyyy-MM-dd',
                                          )
                                        : '08 ابريل 2026',
                                    value: state.date != null
                                        ? TimezoneHelper.format(
                                            TimezoneHelper.createTimestamp(AppTimezone.egypt, DateTime.parse(state.date!)),
                                            locale: 'en',
                                            pattern: 'yyyy-MM-dd',
                                          )
                                        : '08 ابريل 2026',
                                    showArrow: false,
                                    subTitlestyle: state.date != null
                                        ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                        : null,
                                    onTap: () {
                                      showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext modalContext) {
                                          return CupertinoActionSheet(
                                            actions: [
                                              SizedBox(
                                                height: 200.h,
                                                child: Localizations.override(
                                                  context: modalContext,
                                                  locale: const Locale('en', 'US'),
                                                  child: CupertinoDatePicker(
                                                    onDateTimeChanged: (DateTime date) {
                                                      context.read<PermissionRequestCubit>().sendDate(date);
                                                    },
                                                    initialDateTime: TimezoneHelper.now(AppTimezone.egypt),
                                                    mode: CupertinoDatePickerMode.date,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            cancelButton: CupertinoButton(
                                              onPressed: () {
                                                final selectedDate = cubit.state.date != null
                                                    ? DateTime.parse(cubit.state.date!)
                                                    : DateTime.now();

                                                context.read<PermissionRequestCubit>().sendDate(selectedDate);

                                                // Format date as yyyy-MM-dd for API
                                                final formattedDate = TimezoneHelper.format(
                                                  TimezoneHelper.createTimestamp(AppTimezone.egypt, selectedDate),
                                                  pattern: 'yyyy-MM-dd',
                                                );

                                                // Call getShiftId with formatted date
                                                shiftIdCubit.getShiftId(formattedDate);

                                                Navigator.of(modalContext).pop();
                                                AppLogger.instance.logDebug('selected date: ${cubit.state.date}');
                                                AppLogger.instance.logDebug('fetching shift for date: $formattedDate');
                                              },
                                              child: Text(context.localizations.done, style: context.typography.regular16),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              BlocBuilder<ShiftIdCubit, ShiftIdState>(
                                builder: (context, shiftState) {
                                  return BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                                    builder: (context, permissionState) {
                                      // Find the selected shift based on shiftId in PermissionRequestState
                                      final shifts = shiftState.shiftIdResponseModel?.result?.data;
                                      Datum? selectedShift;

                                      if (shifts != null && shifts.isNotEmpty) {
                                        // Try to find the shift matching the selected shiftId
                                        try {
                                          selectedShift = shifts.firstWhere(
                                            (shift) => shift.id == permissionState.shiftId,
                                          );
                                        } on Exception catch (_) {
                                          // If not found, default to first shift
                                          selectedShift = shifts.firstOrNull;
                                        }
                                      }

                                      return Visibility(
                                        visible: shiftState.shiftIdResponseModel?.result?.data?.isNotEmpty ?? false,
                                        child: InfoCard(
                                          prefixIcon: Assets.vectorsTime,
                                          showArrow: false,
                                          title: context.localizations.shift,
                                          subtitle: selectedShift?.name ?? '-:-:-',
                                          subTitlestyle: selectedShift != null
                                              ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                              : null,
                                          value: selectedShift?.name ?? '-:-:-',
                                          onTap: () {
                                            final cubit = context.read<PermissionRequestCubit>();
                                            BottomSheetWrapper(
                                              initialSize: .3.h,
                                              maxChildSize: .3.h,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  spacing: AppSpacing.md.h,
                                                  children: [
                                                    Text('اختار الدوام', style: context.typography.semiBold18),
                                                    ListView.separated(
                                                      separatorBuilder: (context, index) => const AppDivider(),
                                                      itemCount: shiftState.shiftIdResponseModel?.result?.data?.length ?? 0,
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, index) {
                                                        final shift = shiftState.shiftIdResponseModel?.result?.data?[index];
                                                        final isSelected = shift?.id == permissionState.shiftId;

                                                        return InkWell(
                                                          onTap: () {
                                                            AppLogger.instance.logDebug(
                                                              'selected shift id: ${shift?.id}',
                                                            );
                                                            cubit.sendShiftId(shift?.id ?? 0);
                                                            context.pop();
                                                          },
                                                          child: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                              vertical: AppSpacing.lg.h,
                                                              horizontal: AppSpacing.lg.r,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  shift?.name ?? '-:-:-',
                                                                  style: context.typography.regular16.copyWith(
                                                                    color: isSelected ? context.colors.success : null,
                                                                    fontWeight: isSelected ? FontWeight.bold : null,
                                                                  ),
                                                                ),
                                                                if (isSelected)
                                                                  const AppVectorGraphic(path: Assets.vectorsCheckline),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ).callSheet(context);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                              //   builder: (context, state) {
                              //     return InfoCard(
                              //       title: context.localizations.choosePermissionReason,
                              //       subtitle: state.reasonTypeName ?? context.localizations.choosePermissionReason,
                              //       value: state.reasonTypeName ?? context.localizations.choosePermissionReason,
                              //       subTitlestyle: state.reasonTypeName != null
                              //           ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                              //           : null,
                              //       onTap: () {
                              //         final cubit = context.read<PermissionRequestCubit>();
                              //         BottomSheetWrapper(
                              //           initialSize: .3.h,
                              //           maxChildSize: .3.h,
                              //           child: BlocProvider.value(
                              //             value: cubit,
                              //             child: Padding(
                              //               padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                              //               child: Column(
                              //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                 spacing: AppSpacing.md.h,
                              //                 children: [
                              //                   Text('سبب الإستئذان', style: context.typography.semiBold18),
                              //                   ReasonListView(
                              //                     onSelected: (id) {},
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         ).callSheet(context);
                              //       },
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                          builder: (context, state) {
                            final cubit = context.read<PermissionRequestCubit>();
                            final isEarlyOutOrLateIn =
                                state.permissionTypeId == PermissionType.earlyOut.id ||
                                state.permissionTypeId == PermissionType.lateIn.id;

                            return Visibility(
                              visible: isEarlyOutOrLateIn,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r, vertical: AppSpacing.xl.r),
                                decoration: BoxDecoration(
                                  color: context.colors.containerBackground,
                                  borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: AppSpacing.md.h,
                                  children: [
                                    // Checkbox for partial excuse
                                    InkWell(
                                      onTap: () {
                                        cubit.togglePartialExcuse(!state.partialExcuse);
                                      },
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: 1.4,
                                            child: CupertinoCheckbox(
                                              value: state.partialExcuse,
                                              onChanged: (value) {
                                                cubit.togglePartialExcuse(value ?? false);
                                                if (value ?? false) {
                                                  cubit.sendRequestedDuration(0.5);
                                                } else {
                                                  cubit.sendRequestedDuration(null);
                                                }
                                              },
                                              activeColor: context.colors.onSurface,
                                            ),
                                          ),
                                          SizedBox(width: AppSpacing.sm.w),
                                          Expanded(
                                            child: Text(
                                              context.localizations.partialExcuse,
                                              style: context.typography.regular16.copyWith(
                                                color: context.colors.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Show time card only if partial excuse is checked
                                    if (state.partialExcuse)
                                      InfoCard(
                                        prefixIcon: Assets.vectorsTime,
                                        title: context.localizations.enterTimeManually,
                                        subtitle: state.requestedDuration != null
                                            ? '${state.requestedDuration} ${state.requestedDuration == 1 ? 'hour' : 'hours'}'
                                            : '0.5 hours',
                                        value: state.requestedDuration != null
                                            ? '${state.requestedDuration} ${state.requestedDuration == 1 ? 'hour' : 'hours'}'
                                            : '0.5 ${context.localizations.hours}',
                                        showArrow: false,
                                        subTitlestyle: state.requestedDuration != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          showCupertinoModalPopup<void>(
                                            context: context,
                                            builder: (BuildContext modalContext) {
                                              return CupertinoActionSheet(
                                                actions: [
                                                  SizedBox(
                                                    height: 200.h,
                                                    child: Localizations.override(
                                                      context: modalContext,
                                                      locale: const Locale('en', 'US'),
                                                      child: CupertinoDatePicker(
                                                        onDateTimeChanged: (DateTime date) {
                                                          // Calculate duration in hours from the selected time
                                                          final duration = date.hour + (date.minute / 60.0);
                                                          cubit.sendRequestedDuration(duration);
                                                        },
                                                        initialDateTime: DateTime(2000, 1, 1, 0, 30), // Start at 0:30 (0.5 hours)
                                                        mode: CupertinoDatePickerMode.time,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                cancelButton: CupertinoButton(
                                                  onPressed: () {
                                                    if (state.requestedDuration == null) {
                                                      cubit.sendRequestedDuration(0.5); // Default to 30 minutes
                                                    }
                                                    Navigator.of(modalContext).pop();
                                                    AppLogger.instance.logDebug('selected duration: ${state.requestedDuration}');
                                                  },
                                                  child: Text(context.localizations.done, style: context.typography.regular16),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r, vertical: AppSpacing.xl.r),
                          decoration: BoxDecoration(
                            color: context.colors.containerBackground,
                            borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppSpacing.md.h,
                            children: [
                              AppTextField(
                                controller: _reasonController,
                                title: context.localizations.reason,
                                hintTextLabel: 'أكتب سبب الإستئذان إن وجد...',
                                maxLines: 4,
                              ),
                              Text(context.localizations.attachments, style: context.typography.medium16),
                              DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  color: context.colors.dividerColor,
                                  radius: Radius.circular(AppSpacing.xxxxl.r),
                                  dashPattern: [10, 10],
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xxxxl.h, horizontal: AppSpacing.xxxxl.w),
                                    child: Center(
                                      child: Column(
                                        spacing: AppSpacing.sm.h,
                                        children: [
                                          const AppVectorGraphic(path: Assets.vectorsUploadCloud),
                                          Text(context.localizations.clickToUpload, style: context.typography.medium14),
                                          Text(context.localizations.fileFormatsHint, style: context.typography.regular14),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                  builder: (context, state) {
                    final isLoading = state.status == PermissionRequestStatus.loading;

                    return Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.r,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.containerBackground,
                        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                      ),
                      child: isLoading
                          ? Center(
                              child: SizedBox(
                                width: 24.r,
                                height: 24.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.r,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.colors.onSurface,
                                  ),
                                ),
                              ),
                            )
                          : PrimaryTextButton(
                              appButtonSize: AppButtonSize.xxLarge,
                              label: context.localizations.submitRequest,
                              onTap: () => _submitPermissionRequest(context, state),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
