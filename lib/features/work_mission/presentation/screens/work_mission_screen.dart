import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
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
      SnackbarService.showError(context, 'الرجاء اختيار نوع المهمة');
      return;
    }

    if (state.shiftId == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectShift);
      return;
    }

    // Validate attachments (required for work missions)
    if (!_fileUploadCubit.state.hasFiles || !_fileUploadCubit.state.allFilesUploaded) {
      SnackbarService.showError(context, 'الرجاء إرفاق ملف واحد على الأقل');
      return;
    }

    // Type-specific validation
    if (state.workMissionTypeId == WorkMissionTypeModel.hours.id) {
      // For hours type: validate start time and end time
      if (state.startDate == null || state.endDate == null) {
        SnackbarService.showError(context, 'الرجاء اختيار وقت البدء والانتهاء');
        return;
      }

      // Validate time range
      final startDateTime = DateTime.parse(state.startDate!);
      final endDateTime = DateTime.parse(state.endDate!);
      final timeFrom = startDateTime.hour + (startDateTime.minute / 60.0);
      final timeTo = endDateTime.hour + (endDateTime.minute / 60.0);

      if (timeTo <= timeFrom) {
        SnackbarService.showError(context, 'يجب أن يكون وقت الانتهاء بعد وقت البدء');
        return;
      }
    } else if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
      // For days type: validate start date and end date
      if (state.startDate == null || state.endDate == null) {
        SnackbarService.showError(context, 'الرجاء اختيار تاريخ البدء والانتهاء');
        return;
      }

      // Validate date range
      final startDate = DateTime.parse(state.startDate!);
      final endDate = DateTime.parse(state.endDate!);

      if (endDate.isBefore(startDate)) {
        SnackbarService.showError(context, 'يجب أن يكون تاريخ الانتهاء بعد تاريخ البدء');
        return;
      }
    }

    // Build the request based on work mission type
    final request = _buildWorkMissionRequest(state);

    if (request == null) {
      SnackbarService.showError(context, 'بيانات طلب المهمة غير صحيحة');
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

      // Get today's date for the API
      final today = TimezoneHelper.format(
        TimezoneHelper.createTimestamp(DateTime.now()),
        pattern: 'yyyy-MM-dd',
        locale: 'en',
      );

      // Convert times to decimal hours
      final startDateTime = DateTime.parse(state.startDate!);
      final endDateTime = DateTime.parse(state.endDate!);
      final timeFrom = startDateTime.hour + (startDateTime.minute / 60.0);
      final timeTo = endDateTime.hour + (endDateTime.minute / 60.0);

      return WorkMissionRequestModel.hours(
        date: today,
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
                    initialSize: .4.h,
                    maxChildSize: .4.h,
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
                    (result?.message ?? 'فشل في إرسال طلب المهمة') as String,
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
                  state.errorMessage ?? 'فشل في إرسال طلب المهمة',
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: const PrimaryAppBar(
            title: 'طلب مهمة عمل',
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
                                      return InfoCard(
                                        title: 'نوع المهمة',
                                        subtitle: state.workMissionTypeId != null
                                            ? WorkMissionTypeModel.values
                                                  .firstWhere((element) => element.id == state.workMissionTypeId)
                                                  .name
                                            : 'اختار نوع المهمة',
                                        value: state.workMissionTypeId != null
                                            ? WorkMissionTypeModel.values
                                                  .firstWhere((element) => element.id == state.workMissionTypeId)
                                                  .name
                                            : 'اختار نوع المهمة',
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
                                                  Text('اختار نوع المهمة', style: context.typography.semiBold18),
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
                                                                      WorkMissionTypeModel.values[index].name,
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
                                  // BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                  //   builder: (context, state) {
                                  //     final cubit = context.read<WorkMissionCubit>();
                                  //     final shiftIdCubit = context.read<ShiftIdCubit>();
                                  //     return InfoCard(
                                  //       prefixIcon: Assets.vectorsCalendarFill,
                                  //       title: context.localizations.date,
                                  //       subtitle: state.date != null
                                  //           ? TimezoneHelper.format(
                                  //               TimezoneHelper.createTimestamp(
                                  //                 AppTimezone.egypt,
                                  //                 DateTime.parse(state.date!),
                                  //               ),
                                  //               locale: 'en',
                                  //               pattern: 'yyyy-MM-dd',
                                  //             )
                                  //           : context.localizations.defaultDate,
                                  //       value: state.date != null
                                  //           ? TimezoneHelper.format(
                                  //               TimezoneHelper.createTimestamp(
                                  //                 AppTimezone.egypt,
                                  //                 DateTime.parse(state.date!),
                                  //               ),
                                  //               locale: 'en',
                                  //               pattern: 'yyyy-MM-dd',
                                  //             )
                                  //           : context.localizations.defaultDate,
                                  //       showArrow: false,
                                  //       subTitlestyle: state.date != null
                                  //           ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                  //           : null,
                                  //       onTap: () {
                                  //         AppDatePicker.show(
                                  //           context,
                                  //           initialDate: state.date != null
                                  //               ? DateTime.parse(state.date!)
                                  //               : TimezoneHelper.now(AppTimezone.egypt),
                                  //           onDateChanged: (date) {
                                  //             cubit.selectDate(date);
                                  //           },
                                  //           onDateConfirmed: (selectedDate) {
                                  //             cubit.selectDate(selectedDate);

                                  //             // Format date as yyyy-MM-dd for API
                                  //             final formattedDate = TimezoneHelper.format(
                                  //               TimezoneHelper.createTimestamp(AppTimezone.egypt, selectedDate),
                                  //               pattern: 'yyyy-MM-dd',
                                  //               locale: 'en',
                                  //             );

                                  //             // Call getShiftId with formatted date
                                  //             shiftIdCubit.getShiftId(formattedDate);

                                  //             AppLogger.instance.logDebug('selected date: ${cubit.state.date}');
                                  //             AppLogger.instance.logDebug('fetching shift for date: $formattedDate');
                                  //           },
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // ),
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
                                              subtitle: selectedShift?.name ?? '-:-:-',
                                              subTitlestyle: selectedShift != null
                                                  ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                                  : null,
                                              value: selectedShift?.name ?? '-:-:-',
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
                                  BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                    builder: (context, state) {
                                      final cubit = context.read<WorkMissionCubit>();
                                      return InfoCard(
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        title: 'تبدأ من:',
                                        subtitle: state.startDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.startDate!),
                                                ),
                                                locale: 'en',
                                                pattern: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                    ? 'yyyy-MM-dd'
                                                    : 'hh:mm a',
                                              )
                                            : 'اختر تاريخ البدء',
                                        value: state.startDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.startDate!),
                                                ),
                                                locale: 'en',
                                                pattern: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                    ? 'yyyy-MM-dd'
                                                    : 'hh:mm a',
                                              )
                                            : 'اختر تاريخ البدء',
                                        showArrow: false,
                                        subTitlestyle: state.startDate != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          AppDatePicker.show(
                                            mode: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                ? CupertinoDatePickerMode.date
                                                : CupertinoDatePickerMode.time,
                                            context,
                                            initialDate: state.startDate != null
                                                ? DateTime.parse(state.startDate!)
                                                : TimezoneHelper.now(),
                                            onDateChanged: (date) {
                                              if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
                                                cubit.selectStartDate(date);
                                              } else {
                                                cubit.selectStartTime(date);
                                              }
                                            },
                                            onDateConfirmed: (selectedDate) {
                                              if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
                                                cubit.selectStartDate(selectedDate);
                                              } else {
                                                cubit.selectStartTime(selectedDate);
                                              }
                                              final formattedDate = TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(selectedDate),
                                                pattern: 'yyyy-MM-dd',
                                                locale: 'en',
                                              );
                                              AppLogger.instance.logDebug('selected start date: $formattedDate');
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<WorkMissionCubit, WorkMissionState>(
                                    builder: (context, state) {
                                      final cubit = context.read<WorkMissionCubit>();
                                      return InfoCard(
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        title: 'تنتهي في:',
                                        subtitle: state.endDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.endDate!),
                                                ),
                                                locale: 'en',
                                                pattern: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                    ? 'yyyy-MM-dd'
                                                    : 'hh:mm a',
                                              )
                                            : 'اختر تاريخ النهاية',
                                        value: state.endDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.endDate!),
                                                ),
                                                locale: 'en',
                                                pattern: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                    ? 'yyyy-MM-dd'
                                                    : 'hh:mm a',
                                              )
                                            : 'اختر تاريخ النهاية',
                                        showArrow: false,
                                        subTitlestyle: state.endDate != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          AppDatePicker.show(
                                            mode: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                ? CupertinoDatePickerMode.date
                                                : CupertinoDatePickerMode.time,
                                            context,
                                            initialDate: state.endDate != null
                                                ? DateTime.parse(state.endDate!)
                                                : TimezoneHelper.now(),
                                            minimumYear: state.startDate != null
                                                ? DateTime.parse(state.startDate!).year
                                                : DateTime.now().year - 100,
                                            onDateChanged: (date) {
                                              if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
                                                cubit.selectEndDate(date);
                                              } else {
                                                cubit.selectEndTime(date);
                                              }
                                            },
                                            onDateConfirmed: (selectedDate) {
                                              if (state.workMissionTypeId == WorkMissionTypeModel.days.id) {
                                                cubit.selectEndDate(selectedDate);
                                              } else {
                                                cubit.selectEndTime(selectedDate);
                                              }
                                              final formattedDate = TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(selectedDate),
                                                pattern: state.workMissionTypeId == WorkMissionTypeModel.days.id
                                                    ? 'yyyy-MM-dd'
                                                    : 'hh:mm a',
                                                locale: 'en',
                                              );
                                              AppLogger.instance.logDebug('selected end date: $formattedDate');
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),

                                  // InfoCard(
                                  //   title: 'الخدمات الإضافية',
                                  //   subtitle: 'حدد الخدمات التي تريدها',
                                  //   value: 'الخدمات الإضافية',
                                  //   onTap: () {},
                                  // ),
                                ],
                              ),
                            ),

                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                            //   decoration: BoxDecoration(
                            //     color: context.colors.containerBackground,
                            //     borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                            //   ),
                            //   child: Column(
                            //     children: [
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           Text('تذكرة الطيران', style: context.typography.semiBold16),
                            //           Transform.scale(
                            //             scale: 0.8,
                            //             child: Switch.adaptive(value: true, onChanged: (value) {}),
                            //           ),
                            //           // enable or disable
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
                                    hintTextLabel: 'أكتب ملاحظات المهمة إن وجدت...',
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
                                  label: 'إرسال',
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
