import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/date_helper.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/models/upload_file_model.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/utility/extensions.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/success_request_bottomsheet.dart';
import 'package:rose_hr/common/widgets/upload_file_placholder.dart';
import 'package:rose_hr/common/widgets/upload_source_bottom_sheet.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/permission_request/data/models/shift_id_response_model.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_cubit.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/shift_id_state.dart';
import 'package:rose_hr/features/punch_correction/data/models/correction_type_enum.dart';
import 'package:rose_hr/features/punch_correction/data/models/punch_correction_reasons_model.dart';
import 'package:rose_hr/features/punch_correction/presentation/cubit/punch_correction_cubit.dart';
import 'package:rose_hr/features/punch_correction/presentation/widgets/correction_time_widget.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:shimmer/shimmer.dart';

class PunchCorrectionScreen extends StatefulWidget {
  const PunchCorrectionScreen({super.key});

  @override
  State<PunchCorrectionScreen> createState() => _PunchCorrectionScreenState();
}

class _PunchCorrectionScreenState extends State<PunchCorrectionScreen> {
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

  /// Build a single file item with progress indicator
  Widget _buildFileItem(BuildContext context, UploadFileModel file) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.md.h,
        horizontal: AppSpacing.xl.w,
      ),
      decoration: BoxDecoration(
        color: context.colors.fileItemBackground,
        borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
        border: Border.all(color: context.colors.dividerColor),
      ),
      child: Row(
        children: [
          // File icon or loading indicator
          if (file.isUploading)
            SizedBox(
              width: 24.r,
              height: 24.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.r,
                value: file.uploadProgress,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.success,
                ),
              ),
            )
          else
            AppVectorGraphic(
              path: file.isPdf ? Assets.vectorsPdf : Assets.vectorsImage,
              width: 30.r,
              height: 30.r,
            ),
          SizedBox(width: AppSpacing.md.w),

          // File details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        file.name,
                        style: context.typography.medium16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs.w),
                    if (!file.isUploading)
                      InkWell(
                        onTap: () => _fileUploadCubit.removeFile(file.id),
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xs.r),
                          child: AppVectorGraphic(
                            path: Assets.vectorsTrash,
                            width: 16.w,
                            height: 16.h,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSpacing.xxs.h),
                _buildFileStatus(context, file),
              ],
            ),
          ),

          // Delete button
        ],
      ),
    );
  }

  /// Build file status text (size and upload status)
  Widget _buildFileStatus(BuildContext context, UploadFileModel file) {
    if (file.isUploading) {
      return Row(
        spacing: AppSpacing.xs.w,
        children: [
          Text(
            '${(file.uploadProgress * 100).toInt()}%',
            style: context.typography.regular14.copyWith(
              color: context.colors.containerBorder,
            ),
          ),
          Text(
            context.localizations.uploading,
            style: context.typography.regular14.copyWith(
              color: context.colors.containerBorder,
            ),
          ),
        ],
      );
    }

    if (file.hasError) {
      return Text(
        file.errorMessage ?? context.localizations.uploadFailed,
        style: context.typography.regular14.copyWith(
          color: context.colors.error,
        ),
      );
    }

    if (file.isUploadComplete) {
      return Row(
        spacing: AppSpacing.xs.w,
        children: [
          Text(
            file.formattedSize,
            style: context.typography.regular14.copyWith(
              color: context.colors.containerBorder,
            ),
          ),
          const AppVectorGraphic(
            path: Assets.vectorsSelectBoxRight,
            width: 16,
            height: 16,
          ),
          Text(
            context.localizations.uploadedSuccessfully,
            style: context.typography.regular14,
          ),
        ],
      );
    }

    return Text(
      file.formattedSize,
      style: context.typography.regular14.copyWith(
        color: context.colors.containerBorder,
      ),
    );
  }

  /// Validates and submits the punch correction request
  void _submitPunchCorrection(BuildContext context, PunchCorrectionState state) {
    // Validate required fields
    if (state.date == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectDate);
      return;
    }

    if (state.shiftId == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectShift);
      return;
    }

    if (state.correctionType == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectCorrectionType);
      return;
    }
    if (state.attendanceMethod == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectAttendanceMethod);
      return;
    }

    if (state.reasonId == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectReason);
      return;
    }

    // Validate that correction time is selected (stored in startTime for 'in' or endTime for 'out')
    final correctionTime = state.correctionType == CorrectionType.checkIn.id ? state.startTime : state.endTime;

    if (correctionTime == null) {
      SnackbarService.showError(context, context.localizations.pleaseSelectCorrectionTime);
      return;
    }

    // Format date as yyyy-MM-dd for API
    final formattedDate = TimezoneHelper.format(
      TimezoneHelper.createTimestamp(DateTime.parse(state.date!)),
      pattern: 'yyyy-MM-dd',
      locale: 'en',
    );

    // Get reason from controller
    final reason = _reasonController.text.trim().isEmpty ? '' : _reasonController.text.trim();

    // Submit the request using manual method with formatted date
    context.read<PunchCorrectionCubit>().submitPunchCorrection(
      formattedDate: formattedDate,
      reason: !reason.isNullOrEmpty ? '${state.reasonId} - $reason' : state.reasonId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PunchCorrectionCubit>(),
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
                SnackbarService.showError(
                  context,
                  state.errorMessage ?? context.localizations.failedToFetchShiftInformation,
                );
              } else if (state.status == ShiftIdStatus.success) {
                // Automatically select the first shift when data is loaded
                final firstShift = state.shiftIdResponseModel?.result?.data?.firstOrNull;
                if (firstShift != null && firstShift.id != null) {
                  context.read<PunchCorrectionCubit>().selectShiftId(firstShift.id!);
                  AppLogger.instance.logDebug('Auto-selected first shift: ${firstShift.name} (ID: ${firstShift.id})');
                }
              }
            },
          ),
          BlocListener<PunchCorrectionCubit, PunchCorrectionState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if (state.status == PunchCorrectionStatus.success) {
                // Check if the business logic succeeded
                final result = state.punchCorrectionResponseModel?.result;

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
                  // Clear the reason text field and uploaded files
                  _reasonController.clear();
                  _fileUploadCubit.reset();
                } else {
                  // Business logic error (e.g., 400 with success: false)
                  SnackbarService.showError(
                    context,
                    result?.message ?? context.localizations.failedToSubmitPunchCorrection,
                  );
                }
              } else if (state.status == PunchCorrectionStatus.error) {
                // Network or other errors
                SnackbarService.showError(
                  context,
                  state.errorMessage ?? context.localizations.failedToSubmitPunchCorrection,
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: context.colors.containerBackground,
              appBar: PrimaryAppBar(title: context.localizations.punchCorrection),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSpacing.md.h,
                          children: [
                            BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                              builder: (context, state) {
                                final cubit = context.read<PunchCorrectionCubit>();
                                final shiftIdCubit = context.read<ShiftIdCubit>();
                                return InfoCard(
                                  prefixIcon: Assets.vectorsCalendarFill,
                                  title: context.localizations.date,
                                  subtitle: state.date != null
                                      ? TimezoneHelper.format(
                                          TimezoneHelper.createTimestamp(DateTime.parse(state.date!)),
                                          locale: 'en',
                                          pattern: 'yyyy-MM-dd',
                                        )
                                      : context.localizations.defaultDate,
                                  value: state.date != null
                                      ? TimezoneHelper.format(
                                          TimezoneHelper.createTimestamp(DateTime.parse(state.date!)),
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
                                            Container(
                                              decoration: BoxDecoration(
                                                color: context.isLightMode ? null : context.colors.surfaceVariant,
                                                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                                              ),
                                              height: 200.h,
                                              child: Localizations.override(
                                                context: modalContext,
                                                locale: const Locale('en', 'US'),
                                                child: CupertinoDatePicker(
                                                  maximumYear: DateTime.now().year,
                                                  minimumYear: DateTime.now().year - 100,
                                                  onDateTimeChanged: (DateTime date) {
                                                    context.read<PunchCorrectionCubit>().selectDate(date);
                                                  },
                                                  initialDateTime: TimezoneHelper.now(),
                                                  mode: CupertinoDatePickerMode.date,
                                                ),
                                              ),
                                            ),
                                          ],
                                          cancelButton: CupertinoButton(
                                            color: context.isLightMode ? null : context.colors.surfaceVariant,
                                            onPressed: () {
                                              final selectedDate = cubit.state.date != null
                                                  ? DateTime.parse(cubit.state.date!)
                                                  : DateTime.now();

                                              context.read<PunchCorrectionCubit>().selectDate(selectedDate);

                                              // Format date as yyyy-MM-dd for API
                                              final formattedDate = TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(selectedDate),
                                                pattern: 'yyyy-MM-dd',
                                                locale: 'en',
                                              );

                                              // Call getShiftId with formatted date
                                              shiftIdCubit.getShiftId(formattedDate);

                                              Navigator.of(modalContext).pop();
                                              AppLogger.instance.logDebug('selected date: //${cubit.state.date}');
                                              AppLogger.instance.logDebug('fetching shift for date: ');
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
                                return BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                  builder: (context, punchCorrectionState) {
                                    // Find the selected shift based on shiftId in PermissionRequestState
                                    final shifts = shiftState.shiftIdResponseModel?.result?.data;
                                    Datum? selectedShift;

                                    if (shifts != null && shifts.isNotEmpty) {
                                      // Try to find the shift matching the selected shiftId
                                      selectedShift =
                                          shifts.firstWhereOrNull(
                                            (shift) => shift.id == punchCorrectionState.shiftId,
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
                                          final cubit = context.read<PunchCorrectionCubit>();
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
                                                      final isSelected = shift?.id == punchCorrectionState.shiftId;

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
                            Text(context.localizations.suggestedCorrectionTime, style: context.typography.medium16),
                            BlocBuilder<ShiftIdCubit, ShiftIdState>(
                              builder: (context, shiftState) {
                                return BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                  builder: (context, punchCorrectionState) {
                                    // Find the selected shift based on shiftId
                                    final shifts = shiftState.shiftIdResponseModel?.result?.data;
                                    final selectedShift =
                                        shifts?.firstWhereOrNull(
                                          (shift) => shift.id == punchCorrectionState.shiftId,
                                        ) ??
                                        shifts?.firstOrNull;

                                    // Get check-in time from selected shift (can be String datetime, false, or null)
                                    final checkInValue = selectedShift?.checkIn;
                                    final checkInTime = extractTimeFromDateTime(checkInValue);

                                    // Check if late-in time is not 0
                                    final timeLateIn = selectedShift?.timeLateIn;
                                    final hasLateIn = timeLateIn != null && timeLateIn != 0;

                                    // Determine which time to display:
                                    // If late-in exists (not 0), show late-in duration; otherwise show check-in time
                                    final displayTime = formatTimeToArabic(checkInTime);

                                    final isCheckInSelected = punchCorrectionState.correctionType == CorrectionType.checkIn.id;

                                    // Get correction time from startTime if available
                                    final correctionTime = punchCorrectionState.startTime != null
                                        ? formatDecimalHoursToTime(
                                            punchCorrectionState.startTime!,
                                            useArabic: Localizations.localeOf(context).languageCode == 'ar',
                                          )
                                        : null;

                                    return CorrectionTimeWidget(
                                      correctionTime: correctionTime,
                                      isChecked: isCheckInSelected,
                                      showLateInBadge: hasLateIn,
                                      showTimeInErrorColor: hasLateIn,
                                      title: context.localizations.recordedCheckInTime,
                                      time: displayTime,
                                      onCheckedChange: (value) {
                                        AppLogger.instance.logDebug('selected attendance method: ${CorrectionType.checkIn.id}');
                                        // Toggle: if already selected, clear selection; otherwise, select check-in
                                        if (value) {
                                          context.read<PunchCorrectionCubit>().selectCorrectionType(CorrectionType.checkIn.id);
                                        } else {
                                          context.read<PunchCorrectionCubit>().clearCorrectionType();
                                        }
                                      },
                                      onCorrectTap: punchCorrectionState.correctionType == CorrectionType.checkOut.id
                                          ? null
                                          : () {
                                              context.pushNamed(
                                                AppRoutes.correctionTime.name,
                                                extra: context.read<PunchCorrectionCubit>(),
                                              );
                                            },
                                    );
                                  },
                                );
                              },
                            ),
                            BlocBuilder<ShiftIdCubit, ShiftIdState>(
                              builder: (context, shiftState) {
                                return BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                  builder: (context, punchCorrectionState) {
                                    // Find the selected shift based on shiftId
                                    final shifts = shiftState.shiftIdResponseModel?.result?.data;
                                    final selectedShift =
                                        shifts?.firstWhereOrNull(
                                          (shift) => shift.id == punchCorrectionState.shiftId,
                                        ) ??
                                        shifts?.firstOrNull;

                                    // Get check-out time from selected shift (can be String datetime, false, or null)
                                    final checkOutValue = selectedShift?.checkOut;
                                    final checkOutTime = extractTimeFromDateTime(checkOutValue);

                                    // Check if early-out time is not 0
                                    final timeEarlyOut = selectedShift?.timeEarlyOut;
                                    final hasEarlyOut = timeEarlyOut != null && timeEarlyOut != 0;

                                    // Determine which time to display:
                                    // If early-out exists (not 0), show early-out duration; otherwise show check-out time
                                    final displayTime = formatTimeToArabic(checkOutTime);

                                    final isCheckOutSelected = punchCorrectionState.correctionType == CorrectionType.checkOut.id;

                                    // Get correction time from endTime if available
                                    final correctionTime = punchCorrectionState.endTime != null
                                        ? formatDecimalHoursToTime(
                                            punchCorrectionState.endTime!,
                                            useArabic: Localizations.localeOf(context).languageCode == 'ar',
                                          )
                                        : null;

                                    return CorrectionTimeWidget(
                                      correctionTime: correctionTime,
                                      isChecked: isCheckOutSelected,
                                      showEarlyOutBadge: hasEarlyOut,
                                      showTimeInErrorColor: hasEarlyOut,
                                      title: context.localizations.recordedCheckOutTime,
                                      time: displayTime,
                                      onCheckedChange: (value) {
                                        AppLogger.instance.logDebug('selected attendance method: ${CorrectionType.checkOut.id}');
                                        // Toggle: if already selected, clear selection; otherwise, select check-out
                                        if (value) {
                                          context.read<PunchCorrectionCubit>().selectCorrectionType(CorrectionType.checkOut.id);
                                        } else {
                                          context.read<PunchCorrectionCubit>().clearCorrectionType();
                                        }
                                      },
                                      onCorrectTap:
                                          context.read<PunchCorrectionCubit>().state.correctionType == CorrectionType.checkIn.id
                                          ? null
                                          : () {
                                              context.pushNamed(
                                                AppRoutes.correctionTime.name,
                                                extra: context.read<PunchCorrectionCubit>(),
                                              );
                                            },
                                    );
                                  },
                                );
                              },
                            ),

                            BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                              builder: (context, state) {
                                final cubit = context.read<PunchCorrectionCubit>();
                                // Find the selected reason name
                                final selectedReason = punchCorrectionReasons.firstWhereOrNull(
                                  (reason) => reason.id == state.reasonId,
                                );

                                return InfoCard(
                                  title: context.localizations.reason,
                                  subtitle:
                                      selectedReason?.label(context.localizations) ?? context.localizations.forgotFingerprint,
                                  subTitlestyle: selectedReason != null
                                      ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                      : null,
                                  value: selectedReason?.label(context.localizations) ?? context.localizations.enterDetailsHere,
                                  onTap: () {
                                    BottomSheetWrapper(
                                      initialSize: 0.5.h,
                                      maxChildSize: 0.5.h,
                                      removeAutoScroll: true,
                                      disableDrag: true,
                                      useRootNavigator: true,
                                      child: BlocProvider.value(
                                        value: cubit,
                                        child: BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                                          builder: (context, state) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                              child: Column(
                                                spacing: AppSpacing.md.h,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    context.localizations.selectCorrectionReason,
                                                    style: context.typography.medium18,
                                                  ),
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    separatorBuilder: (context, index) => const AppDivider(),
                                                    itemCount: punchCorrectionReasons.length,
                                                    itemBuilder: (context, index) {
                                                      final isSelected = punchCorrectionReasons[index].id == state.reasonId;
                                                      return InkWell(
                                                        onTap: () {
                                                          cubit.selectReasonId(punchCorrectionReasons[index].id);
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
                                                                punchCorrectionReasons[index].label(context.localizations),
                                                                style: context.typography.regular16.copyWith(
                                                                  color: isSelected ? context.colors.onSurface : null,
                                                                  fontWeight: isSelected ? FontWeight.w600 : null,
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
                                            );
                                          },
                                        ),
                                      ),
                                    ).callSheet(context);
                                  },
                                );
                              },
                            ),
                            AppTextField(
                              controller: _reasonController,
                              hintTextLabel: context.localizations.enterDetailsHere,
                              maxLines: 4,
                            ),

                            Text(context.localizations.attachments, style: context.typography.medium16),
                            BlocBuilder<FileUploadCubit, FileUploadState>(
                              bloc: _fileUploadCubit,
                              builder: (context, fileUploadState) {
                                // Hide upload area when uploading or when files exist
                                final shouldShowUploadArea = !fileUploadState.isAnyFileUploading && fileUploadState.files.isEmpty;

                                return Column(
                                  spacing: AppSpacing.md.h,
                                  children: [
                                    // Upload area - only show when no files are uploading or uploaded
                                    if (shouldShowUploadArea)
                                      UploadFilePlacholder(
                                        onTap: () {
                                          showUploadSourceSheet(
                                            context,
                                            onChooseImages: () => _fileUploadCubit.pickFiles(
                                              fileType: FilePickerType.image,
                                            ),
                                            onChooseFiles: () => _fileUploadCubit.pickFiles(
                                              fileType: FilePickerType.pdf,
                                            ),
                                          );
                                        },
                                        isMaxFilesReached: fileUploadState.isMaxFilesReached,
                                      ),

                                    // Show uploaded files
                                    ...fileUploadState.files.map((file) => _buildFileItem(context, file)),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: AppSpacing.xxxxl.h),
                          ],
                        ),
                      ),
                    ),

                    BlocBuilder<PunchCorrectionCubit, PunchCorrectionState>(
                      builder: (context, state) {
                        final isLoading = state.status == PunchCorrectionStatus.loading;

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
                                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
                                child: PrimaryTextButton(
                                  onTap:
                                      state.date == null ||
                                          state.shiftId == null ||
                                          state.correctionType == null ||
                                          state.attendanceMethod == null ||
                                          state.reasonId == null ||
                                          (state.startTime == null && state.endTime == null)
                                      ? null
                                      : () => _submitPunchCorrection(context, state),
                                  appButtonSize: AppButtonSize.xxLarge,
                                  label: context.localizations.submit,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
