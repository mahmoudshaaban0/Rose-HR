import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:rose_hr/common/widgets/success_request_bottomsheet.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/widgets/file_upload_widget.dart';
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
import 'package:shimmer/shimmer.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  State<PermissionRequestScreen> createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  late final TextEditingController _reasonController;
  late final TextEditingController _durationController;
  late final FileUploadCubit _fileUploadCubit;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _durationController = TextEditingController();
    _fileUploadCubit = sl<FileUploadCubit>();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _durationController.dispose();
    _fileUploadCubit.close();
    super.dispose();
  }

  /// Validates and submits the permission request
  void _submitPermissionRequest(BuildContext context, PermissionRequestState state) {
    // Validate required fields
    if (state.permissionTypeId == null) {
      ToastService.showError(context.localizations.pleaseSelectPermissionType, gravity: ToastGravity.CENTER);
      return;
    }

    if (state.date == null) {
      ToastService.showError(context.localizations.pleaseSelectDate, gravity: ToastGravity.CENTER);
      return;
    }

    if (state.shiftId == null) {
      ToastService.showError(context.localizations.pleaseSelectShift, gravity: ToastGravity.CENTER);
      return;
    }

    // Type-specific validation
    if (state.permissionTypeId == 'mid_day') {
      if (state.startTime == null || state.endTime == null) {
        ToastService.showError(context.localizations.pleaseSelectStartAndEndTime);
        return;
      }

      // Validate time range
      final startDateTime = DateTime.parse(state.startTime!);
      final endDateTime = DateTime.parse(state.endTime!);
      final timeFrom = startDateTime.hour + (startDateTime.minute / 60.0);
      final timeTo = endDateTime.hour + (endDateTime.minute / 60.0);

      if (timeTo <= timeFrom) {
        ToastService.showError(context.localizations.endTimeMustBeAfterStartTime);
        return;
      }
    }

    if ((state.permissionTypeId == 'late_in' || state.permissionTypeId == 'early_out') &&
        state.partialExcuse &&
        state.requestedDuration == null) {
      ToastService.showError(context.localizations.pleaseSpecifyRequestedDuration);
      return;
    }

    // Build the request based on permission type
    final request = _buildPermissionRequest(state);

    if (request == null) {
      ToastService.showError(context.localizations.invalidPermissionRequestData);
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
      locale: 'en',
    );

    // Get attachments from file upload cubit if available
    List<AttachmentData>? attachments;
    if (_fileUploadCubit.state.hasFiles && _fileUploadCubit.state.allFilesUploaded) {
      attachments = _fileUploadCubit.state.uploadedFiles.map((file) {
        return AttachmentData(
          name: file.name,
          data: file.base64Data ?? '',
          mimetype: file.mimeType,
        );
      }).toList();
    }

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
          attachmentIds: attachments,
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
          attachmentIds: attachments,
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
          attachmentIds: attachments,
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
                  state.errorMessage ?? context.localizations.failedToFetchShiftInformation,
                );
              } else if (state.status == ShiftIdStatus.success) {
                // Automatically select the first shift when data is loaded
                final firstShift = state.shiftIdResponseModel?.result?.data?.firstOrNull;
                if (firstShift != null && firstShift.id != null) {
                  context.read<PermissionRequestCubit>().selectShiftId(firstShift.id!);
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
                  context.pop();
                  // Show success bottom sheet
                  BottomSheetWrapper(
                    closeBottomSheetOnDrag: false,
                    initialSize: .4.h,
                    maxChildSize: .4.h,
                    removeAutoScroll: true,
                    disableDrag: true,
                    useRootNavigator: true,
                    child: const SuccessRequestBottomsheet(),
                  ).callSheet(context);
                  context.read<PermissionRequestCubit>().clearAllFields();
                  _reasonController.clear();
                  _durationController.clear();
                  _fileUploadCubit.clearAllFiles();
                } else {
                  // Business logic error (e.g., 400 with success: false)
                  ToastService.showError(
                    gravity: ToastGravity.CENTER,
                    result?.message ?? context.localizations.failedToSubmitPermissionRequest,
                  );
                }
              } else if (state.status == PermissionRequestStatus.loading) {
                showDialog<void>(
                  context: context,
                  builder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
                );
              } else if (state.status == PermissionRequestStatus.error) {
                // Network or other errors
                context.pop();
                ToastService.showError(
                  gravity: ToastGravity.CENTER,
                  state.errorMessage ?? context.localizations.failedToSubmitPermissionRequest,
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
                                                Text(context.localizations.permissionType, style: context.typography.semiBold18),
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
                                                : context.localizations.defaultTime,
                                            value: state.startTime != null
                                                ? TimezoneHelper.format(
                                                    TimezoneHelper.createTimestamp(
                                                      AppTimezone.egypt,
                                                      DateTime.parse(state.startTime!),
                                                    ),
                                                    locale: 'en',
                                                    pattern: 'hh:mm a',
                                                  )
                                                : context.localizations.defaultTime,
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
                                                        context.read<PermissionRequestCubit>().selectStartTimeAndEndTime(
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
                                                : context.localizations.defaultTime,
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
                                                        context.read<PermissionRequestCubit>().selectStartTimeAndEndTime(
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
                                        : context.localizations.defaultDate,
                                    value: state.date != null
                                        ? TimezoneHelper.format(
                                            TimezoneHelper.createTimestamp(AppTimezone.egypt, DateTime.parse(state.date!)),
                                            locale: 'en',
                                            pattern: 'yyyy-MM-dd',
                                          )
                                        : context.localizations.defaultDate,
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
                                                    maximumYear: DateTime.now().year,
                                                    minimumYear: DateTime.now().year - 100,
                                                    onDateTimeChanged: (DateTime date) {
                                                      context.read<PermissionRequestCubit>().selectDate(date);
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

                                                context.read<PermissionRequestCubit>().selectDate(selectedDate);

                                                // Format date as yyyy-MM-dd for API
                                                final formattedDate = TimezoneHelper.format(
                                                  TimezoneHelper.createTimestamp(AppTimezone.egypt, selectedDate),
                                                  pattern: 'yyyy-MM-dd',
                                                  locale: 'en',
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
                                      } else if (shiftState.status == ShiftIdStatus.loading) {
                                        // create loading shimmer effect
                                        return Shimmer.fromColors(
                                          baseColor: context.colors.surfaceVariant,
                                          highlightColor: context.colors.containerBackground,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: AppSpacing.md.r),
                                            decoration: BoxDecoration(
                                              color: context.colors.containerBackground,
                                              borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                                            ),
                                            width: double.infinity,
                                            height: 40.h,
                                          ),
                                        );
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
                                                    Text(context.localizations.selectShift, style: context.typography.semiBold18),
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
                                                            cubit.selectShiftId(shift?.id ?? 0);
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
                              BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
                                builder: (context, permissionState) {
                                  return BlocBuilder<ShiftIdCubit, ShiftIdState>(
                                    builder: (context, shiftState) {
                                      if (shiftState.status == ShiftIdStatus.success) {
                                        final shifts = shiftState.shiftIdResponseModel?.result?.data;
                                        if (shifts != null && shifts.isNotEmpty) {
                                          final shift = shifts.firstWhere(
                                            (shift) => shift.id == shiftState.shiftIdResponseModel?.result?.data?.firstOrNull?.id,
                                          );

                                          // Show late arrival time if permission type is late_in
                                          if (permissionState.permissionTypeId == PermissionType.lateIn.id) {
                                            final lateInHours = shift.timeLateIn ?? 0.0;
                                            if (lateInHours > 0) {
                                              return Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  '${context.localizations.late} : ${lateInHours.toStringAsFixed(2)} ${context.localizations.hours}',
                                                  style: context.typography.medium16.copyWith(color: context.colors.error),
                                                  textAlign: TextAlign.start,
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          }

                                          // Show early out time if permission type is early_out
                                          if (permissionState.permissionTypeId == PermissionType.earlyOut.id) {
                                            final earlyOutHours = shift.timeEarlyOut ?? 0.0;
                                            if (earlyOutHours > 0) {
                                              return Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  '${context.localizations.late} : ${earlyOutHours.toStringAsFixed(2)} ${context.localizations.hours}',
                                                  style: context.typography.medium16.copyWith(color: context.colors.error),
                                                  textAlign: TextAlign.start,
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          }
                                        }
                                        return const SizedBox.shrink();
                                      }
                                      return const SizedBox.shrink();
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
                                        final newValue = !state.partialExcuse;
                                        cubit.togglePartialExcuse(newValue);
                                        if (newValue) {
                                          cubit.selectRequestedDuration(0.5);
                                        } else {
                                          _durationController.clear();
                                          cubit.selectRequestedDuration(null);
                                        }
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
                                                  _durationController.text = '0.5';
                                                  cubit.selectRequestedDuration(0.5);
                                                } else {
                                                  _durationController.clear();
                                                  cubit.selectRequestedDuration(null);
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

                                    // Show time field only if partial excuse is checked
                                    if (state.partialExcuse)
                                      AppTextField(
                                        controller: _durationController,
                                        title: context.localizations.enterTimeManually,
                                        hintTextLabel: '0.5',
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        textDirection: TextDirection.ltr,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
                                        ],
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            final duration = double.tryParse(value);
                                            if (duration != null && duration > 0) {
                                              cubit.selectRequestedDuration(duration);
                                            }
                                          } else {
                                            cubit.selectRequestedDuration(null);
                                          }
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
                                hintTextLabel: context.localizations.enterPermissionReasonHere,
                                maxLines: 4,
                              ),
                              Text(context.localizations.attachments, style: context.typography.medium16),
                              FileUploadWidget(
                                cubit: _fileUploadCubit,
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
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2.r,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.colors.black,
                                  ),
                                ),
                              ),
                            )
                          : PrimaryTextButton(
                              appButtonSize: AppButtonSize.xxLarge,
                              label: context.localizations.submitRequest,
                              onTap: state.permissionTypeId == null || state.shiftId == null || state.date == null
                                  ? null
                                  : () => _submitPermissionRequest(context, state),
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
