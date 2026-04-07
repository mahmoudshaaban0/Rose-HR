import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/common/widgets/app_datepicker.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/file_upload_widget.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/success_request_bottomsheet.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/permission_request/data/models/permission_request_model.dart';
import 'package:rose_hr/features/permission_request/data/models/shift_id_response_model.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_cubit.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_state.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_request_model.dart';
import 'package:rose_hr/features/work_mission/data/models/work_mission_type_model.dart';
import 'package:rose_hr/features/work_mission/presentation/bloc/work_mission_cubit.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class WorkMissionScreen extends StatefulWidget {
  const WorkMissionScreen({super.key});

  @override
  State<WorkMissionScreen> createState() => _WorkMissionScreenState();
}

class _WorkMissionScreenState extends State<WorkMissionScreen> {
  late final TextEditingController _reasonController;
  late final FileUploadCubit _fileUploadCubit;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _fileUploadCubit = sl<FileUploadCubit>();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _fileUploadCubit.close();
    super.dispose();
  }

  /// Validates and submits the work mission request
  void _submitWorkMission(BuildContext context, WorkMissionState state) {
    // Validate required fields
    if (state.workMissionTypeId == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectWorkMissionType);
      return;
    }

    if (state.shiftId == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectShift);
      return;
    }

    // Validate attachments (required for work missions)
    if (!_fileUploadCubit.state.hasFiles || !_fileUploadCubit.state.allFilesUploaded) {
      SnackbarService.showError(context, context.localizations.pleaseAttachAtLeastOneFile);
      return;
    }

    // Type-specific validation
    if (state.workMissionTypeId == WorkMissionTypeModel.hours.id) {
      // For hours type: validate start time and end time
      if (state.startDate == null || state.endDate == null) {
        SnackbarService.showError(context, context.localizations.pleaseSelectStartAndEndTime);
        return;
      }

      // Validate time order — end after start (supports overnight spans)
      final startDT = DateTime.parse(state.startDate!);
      final endDT = DateTime.parse(state.endDate!);

      if (!endDT.isAfter(startDT)) {
        SnackbarService.showError(context, context.localizations.endTimeMustBeAfterStartTime);
        return;
      }
    } else if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
      // For days type: validate start date and end date
      if (state.startDate == null || state.endDate == null) {
        SnackbarService.showError(context, context.localizations.pleaseSelectHolidayDatesError);
        return;
      }

      // Validate date range
      final startDate = DateTime.parse(state.startDate!);
      final endDate = DateTime.parse(state.endDate!);

      if (startDate.isAfter(endDate)) {
        SnackbarService.showError(context, context.localizations.missionEndDateMustBeAfterStartDate);
        return;
      }
    }

    // Build the request based on work mission type
    final request = _buildWorkMissionRequest(state);

    if (request == null) {
      SnackbarService.showError(context, context.localizations.invalidWorkMissionRequestData);
      return;
    }

    // Submit the request
    context.read<WorkMissionCubit>().createWorkMission(request);
  }

  /// Builds the appropriate work mission request model based on the type
  WorkMissionRequestModel? _buildWorkMissionRequest(WorkMissionState state) {
    final reason = _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim();

    // Get attachments from file upload cubit (required)
    final attachments = _fileUploadCubit.state.uploadedFiles.map((file) {
      return AttachmentData(
        name: file.name,
        data: file.base64Data ?? '',
        mimetype: file.mimeType,
      );
    }).toList();

    if (state.workMissionTypeId == WorkMissionTypeModel.hours.id) {
      // For hours type
      if (state.startDate == null || state.endDate == null) {
        return null;
      }

      // Fallback to today (if user didn't pick a date yet)
      final today = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(DateTime.now()),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      final missionDate = state.date != null
          ? TimezoneHelper.format(
              TimezoneHelper.createTimestamp(DateTime.parse(state.date!)),
              pattern: 'yyyy-MM-dd',
              locale: 'en',
            )
          : today;

      // Convert times to decimal hours (rounded to 2dp to avoid float precision issues)
      final startDateTime = DateTime.parse(state.startDate!);
      final endDateTime = DateTime.parse(state.endDate!);
      final timeFrom = double.parse(
        (startDateTime.hour + (startDateTime.minute / 60.0)).toStringAsFixed(2),
      );
      final timeTo = double.parse(
        (endDateTime.hour + (endDateTime.minute / 60.0)).toStringAsFixed(2),
      );

      return WorkMissionRequestModel.hours(
        date: missionDate,
        shiftId: state.shiftId!,
        timeFrom: timeFrom,
        timeTo: timeTo,
        attachmentIds: attachments,
        reason: reason,
      );
    } else if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
      // For days type
      if (state.startDate == null || state.endDate == null) {
        return null;
      }

      // Format dates as yyyy-MM-dd
      final startDate = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(DateTime.parse(state.startDate!)),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      final endDate = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(DateTime.parse(state.endDate!)),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      return WorkMissionRequestModel.days(
        missionStartDate: startDate,
        missionEndDate: endDate,
        attachmentIds: attachments,
        reason: reason,
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<WorkMissionCubit>(),
        ),
        BlocProvider(
          create: (context) {
            final formattedDate = TimezoneHelper.format(
              TimezoneHelper.createTimestamp(DateTime.now()),
              pattern: 'yyyy-MM-dd',
              locale: 'en',
            );
            return sl<ShiftIdCubit>()..getShiftId(formattedDate);
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ShiftIdCubit, ShiftIdState>(
            listener: (context, state) {
              if (state.status == ShiftIdStatus.error) {
                SnackbarService.showError(
                  context,
                  state.errorMessage ?? context.localizations.failedToFetchShiftInformation,
                );
              } else if (state.status == ShiftIdStatus.success) {
                // Automatically select the first shift when data is loaded
                final firstShift = state.shiftIdResponseModel?.result?.data?.firstOrNull;
                if (firstShift != null && firstShift.id != null) {
                  context.read<WorkMissionCubit>().selectShiftId(firstShift.id!);
                  AppLogger.instance.logDebug('Auto-selected first shift: ${firstShift.name} (ID: ${firstShift.id})');
                }
              }
            },
          ),
          BlocListener<WorkMissionCubit, WorkMissionState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == WorkMissionStatus.success) {
                context.pop();
                // Check if the business logic succeeded
                final result = state.workMissionResponseModel?.result;

                if (result?.statusCode == 200) {
                  // Show success bottom sheet
                  BottomSheetWrapper(
                    closeBottomSheetOnDrag: false,
                    initialSize: .42.h,
                    maxChildSize: .42.h,
                    removeAutoScroll: true,
                    disableDrag: true,
                    useRootNavigator: true,
                    child: const SuccessRequestBottomsheet(),
                  ).callSheet(context);

                  // Clear the form fields and uploaded files
                  context.read<WorkMissionCubit>().clearAllFields();
                  _reasonController.clear();
                  _fileUploadCubit.clearAllFiles();
                } else {
                  // Business logic error (e.g., 400 with success: false)
                  SnackbarService.showError(
                    context,
                    result?.message?.toString() ?? context.localizations.failedToSubmitWorkMissionRequest,
                  );
                }
              } else if (state.status == WorkMissionStatus.loading) {
                showDialog<void>(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
                );
              } else if (state.status == WorkMissionStatus.error) {
                context.pop();
                // Network or other errors
                SnackbarService.showError(
                  context,
                  state.errorMessage ?? context.localizations.failedToSubmitWorkMissionRequest,
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: PrimaryAppBar(
            title: context.localizations.workMissionRequestTitle,
          ),
          body: Builder(
            builder: (context) {
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.md.w,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.md.w),
                              decoration: BoxDecoration(
                                color: context.colors.containerBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                              ),
                              child: Column(
                                spacing: AppSpacing.md.w,
                                children: [
                                  BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                    builder: (context, state) {
                                      final selectedType = WorkMissionTypeModel.values.firstWhereOrNull(
                                        (e) => e.id == state.workMissionTypeId,
                                      );
                                      final typeLabel =
                                          selectedType?.localizedName(context.localizations) ??
                                          context.localizations.selectWorkMissionType;

                                      return InfoCard(
                                        title: context.localizations.workMissionTypeLabel,
                                        subtitle: typeLabel,
                                        value: typeLabel,
                                        subTitlestyle: state.workMissionTypeId != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          final cubit = context.read<WorkMissionCubit>();
                                          BottomSheetWrapper(
                                            initialSize: .3.h,
                                            maxChildSize: .3.h,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                spacing: AppSpacing.md.h,
                                                children: [
                                                  Text(
                                                    context.localizations.selectWorkMissionType,
                                                    style: context.typography.semiBold18,
                                                  ),
                                                  BlocProvider.value(
                                                    value: cubit,
                                                    child: BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                                      builder: (context, state) {
                                                        return ListView.separated(
                                                          separatorBuilder: (context, index) => const AppDivider(),
                                                          itemCount: WorkMissionTypeModel.values.length,
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context, index) {
                                                            return InkWell(
                                                              onTap: () {
                                                                AppLogger.instance.logDebug(
                                                                  'selected work mission type id: ${WorkMissionTypeModel.values[index].id}',
                                                                );
                                                                context.read<WorkMissionCubit>().selectWorkMissionType(
                                                                  WorkMissionTypeModel.values[index].id,
                                                                );
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
                                                                      WorkMissionTypeModel.values[index].localizedName(
                                                                        context.localizations,
                                                                      ),
                                                                      style: context.typography.medium16.copyWith(
                                                                        color:
                                                                            WorkMissionTypeModel.values[index].id ==
                                                                                cubit.state.workMissionTypeId
                                                                            ? context.colors.success
                                                                            : null,
                                                                      ),
                                                                    ),
                                                                    if (WorkMissionTypeModel.values[index].id ==
                                                                        cubit.state.workMissionTypeId)
                                                                      const AppVectorGraphic(path: Assets.vectorsCheckline),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ).callSheet(context);
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                    builder: (context, state) {
                                      final cubit = context.read<WorkMissionCubit>();
                                      final shiftIdCubit = context.read<ShiftIdCubit>();

                                      final today = TimezoneHelper.format(
                                        TimezoneHelper.createTimestamp(DateTime.now()),
                                        pattern: 'yyyy-MM-dd',
                                        locale: 'en',
                                      );

                                      final selectedDate = state.date != null
                                          ? TimezoneHelper.format(
                                              TimezoneHelper.createTimestamp(DateTime.parse(state.date!)),
                                              pattern: 'yyyy-MM-dd',
                                              locale: 'en',
                                            )
                                          : today;

                                      final isHoursMission = state.workMissionTypeId == WorkMissionTypeModel.hours.id;

                                      return Visibility(
                                        visible: isHoursMission,
                                        child: InfoCard(
                                          prefixIcon: Assets.vectorsCalendarFill,
                                          title: context.localizations.date,
                                          subtitle: selectedDate,
                                          value: selectedDate,
                                          showArrow: false,
                                          subTitlestyle: context.typography.regular16.copyWith(
                                            color: context.colors.onSurface,
                                          ),
                                          onTap: () {
                                            AppDatePicker.show(
                                              context,
                                              mode: CupertinoDatePickerMode.date,
                                              initialDate: state.date != null ? DateTime.parse(state.date!) : DateTime.now(),
                                              onDateChanged: cubit.selectDate,
                                              onDateConfirmed: (selectedDate) {
                                                cubit.selectDate(selectedDate);

                                                final formattedDate = TimezoneHelper.format(
                                                  TimezoneHelper.createTimestamp(selectedDate),
                                                  pattern: 'yyyy-MM-dd',
                                                  locale: 'en',
                                                );

                                                shiftIdCubit.getShiftId(formattedDate);
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  BlocBuilder<ShiftIdCubit, ShiftIdState>(
                                    builder: (context, shiftState) {
                                      return BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                        builder: (context, workMissionState) {
                                          // Find the selected shift based on shiftId in WorkMissionState
                                          final shifts = shiftState.shiftIdResponseModel?.result?.data;
                                          Datum? selectedShift;

                                          if (shifts != null && shifts.isNotEmpty) {
                                            // Try to find the shift matching the selected shiftId
                                            selectedShift =
                                                shifts.firstWhereOrNull(
                                                  (shift) => shift.id == workMissionState.shiftId,
                                                ) ??
                                                shifts.firstOrNull;
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
                                              subtitle: selectedShift?.name ?? context.localizations.shiftNamePlaceholder,
                                              subTitlestyle: selectedShift != null
                                                  ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                                  : null,
                                              value: selectedShift?.name ?? context.localizations.shiftNamePlaceholder,
                                              onTap: () {
                                                final cubit = context.read<WorkMissionCubit>();
                                                BottomSheetWrapper(
                                                  initialSize: .3.h,
                                                  maxChildSize: .3.h,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      spacing: AppSpacing.md.h,
                                                      children: [
                                                        Text(
                                                          context.localizations.selectShift,
                                                          style: context.typography.semiBold18,
                                                        ),
                                                        ListView.separated(
                                                          separatorBuilder: (context, index) => const AppDivider(),
                                                          itemCount: shiftState.shiftIdResponseModel?.result?.data?.length ?? 0,
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemBuilder: (context, index) {
                                                            final shift = shiftState.shiftIdResponseModel?.result?.data?[index];
                                                            final isSelected = shift?.id == workMissionState.shiftId;

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
                                                                      shift?.name ?? context.localizations.shiftNamePlaceholder,
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
                                  BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                    builder: (context, state) {
                                      final cubit = context.read<WorkMissionCubit>();
                                      final isDays = state.workMissionTypeId == WorkMissionTypeModel.days.id;
                                      final startPlaceholder = isDays
                                          ? context.localizations.selectStartDate
                                          : context.localizations.pleaseSelectStartTime;

                                      return InfoCard(
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        title: context.localizations.startsFrom,
                                        subtitle: state.startDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.startDate!),
                                                ),
                                                locale: 'en',
                                                pattern: isDays ? 'yyyy-MM-dd' : 'hh:mm a',
                                              )
                                            : startPlaceholder,
                                        value: state.startDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.startDate!),
                                                ),
                                                locale: 'en',
                                                pattern: isDays ? 'yyyy-MM-dd' : 'hh:mm a',
                                              )
                                            : startPlaceholder,
                                        showArrow: false,
                                        subTitlestyle: state.startDate != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          final isHours = state.workMissionTypeId == WorkMissionTypeModel.hours.id;
                                          AppDatePicker.show(
                                            mode: isHours ? CupertinoDatePickerMode.time : CupertinoDatePickerMode.date,
                                            context,
                                            initialDate: state.startDate != null
                                                ? DateTime.parse(state.startDate!)
                                                : TimezoneHelper.now(),
                                            // For time mode: don't update on scroll — only save on confirm
                                            onDateChanged: isHours ? null : cubit.selectStartDate,
                                            onDateConfirmed: (selectedDate) {
                                              if (isHours) {
                                                cubit.selectStartTime(selectedDate);
                                              } else {
                                                cubit.selectStartDate(selectedDate);
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                    builder: (context, state) {
                                      final cubit = context.read<WorkMissionCubit>();
                                      final isDays = state.workMissionTypeId == WorkMissionTypeModel.days.id;
                                      final endPlaceholder = isDays
                                          ? context.localizations.selectEndDate
                                          : context.localizations.pleaseSelectEndTime;

                                      return InfoCard(
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        title: context.localizations.endsAt,
                                        subtitle: state.endDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.endDate!),
                                                ),
                                                locale: 'en',
                                                pattern: isDays ? 'yyyy-MM-dd' : 'hh:mm a',
                                              )
                                            : endPlaceholder,
                                        value: state.endDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.endDate!),
                                                ),
                                                locale: 'en',
                                                pattern: isDays ? 'yyyy-MM-dd' : 'hh:mm a',
                                              )
                                            : endPlaceholder,
                                        showArrow: false,
                                        subTitlestyle: state.endDate != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          final isHours = state.workMissionTypeId == WorkMissionTypeModel.hours.id;
                                          final startDT = state.startDate != null ? DateTime.parse(state.startDate!) : null;
                                          final currentEnd = state.endDate != null ? DateTime.parse(state.endDate!) : null;
                                          // initialDate must not be before startDT
                                          final initialEnd =
                                              (currentEnd != null && startDT != null && currentEnd.isBefore(startDT))
                                              ? startDT
                                              : (currentEnd ?? startDT ?? TimezoneHelper.now());
                                          AppDatePicker.show(
                                            mode: isHours ? CupertinoDatePickerMode.time : CupertinoDatePickerMode.date,
                                            context,
                                            initialDate: initialEnd,
                                            minimumDate: isHours ? null : startDT,
                                            minimumYear: startDT != null ? startDT.year : DateTime.now().year - 100,
                                            // For time mode: don't update on scroll — only save on confirm
                                            onDateChanged: isHours ? null : cubit.selectEndDate,
                                            onDateConfirmed: (selectedDate) {
                                              if (isHours) {
                                                cubit.selectEndTime(selectedDate);
                                              } else {
                                                cubit.selectEndDate(selectedDate);
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.md.w),
                              decoration: BoxDecoration(
                                color: context.colors.containerBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                              ),
                              child: Column(
                                spacing: AppSpacing.md.w,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextField(
                                    title: context.localizations.notes,
                                    controller: _reasonController,
                                    hintTextLabel: context.localizations.workMissionNotesHint,
                                    maxLines: 4,
                                  ),
                                  Text(
                                    context.localizations.attachments,
                                    style: context.typography.medium16,
                                    textAlign: TextAlign.start,
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.all(Radius.circular(AppSpacing.xxxl.r)),
                                    color: Colors.transparent,
                                    child: FileUploadWidget(
                                      cubit: _fileUploadCubit,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<WorkMissionCubit, WorkMissionState>(
                      builder: (context, state) {
                        final isLoading = state.status == WorkMissionStatus.loading;

                        return isLoading
                            ? Center(
                                child: SizedBox(
                                  width: 24.r,
                                  height: 24.r,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2.r,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.colors.success,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                                child: PrimaryTextButton(
                                  onTap: state.workMissionTypeId == null || state.shiftId == null
                                      ? null
                                      : () => _submitWorkMission(context, state),
                                  appButtonSize: AppButtonSize.xxLarge,
                                  label: context.localizations.send,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
