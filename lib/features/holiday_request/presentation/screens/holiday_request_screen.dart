import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/helpers/toast_service.dart';
import 'package:rose_hr/common/models/upload_file_model.dart';
import 'package:rose_hr/common/widgets/app_datepicker.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/success_request_bottomsheet.dart';
import 'package:rose_hr/common/widgets/upload_file_placholder.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/holiday_request/presentation/bloc/holiday_request_cubit.dart';
import 'package:rose_hr/features/holiday_request/presentation/widgets/leave_type_listview.dart';
import 'package:rose_hr/features/holiday_request/presentation/widgets/visa_type_listview.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class HolidayRequestScreen extends StatefulWidget {
  const HolidayRequestScreen({super.key});

  @override
  State<HolidayRequestScreen> createState() => _HolidayRequestScreenState();
}

class _HolidayRequestScreenState extends State<HolidayRequestScreen> {
  late final FileUploadCubit _fileUploadCubit;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _fileUploadCubit = sl<FileUploadCubit>();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _fileUploadCubit.close();
    _descriptionController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HolidayRequestCubit>()..getAllLeaveTypes(),
      child: BlocListener<HolidayRequestCubit, HolidayRequestState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == HolidayRequestStatus.submitted) {
            // Check if the business logic succeeded
            final result = state.holidayRequestResponseModel?.result;

            if (result?.success ?? false) {
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
              // Clear the description text field and uploaded files
              _descriptionController.clear();
              _fileUploadCubit.reset();
            } else {
              // Business logic error (e.g., 400 with success: false)
              ToastService.showError(
                gravity: ToastGravity.CENTER,
                result?.message ?? 'فشل إرسال الطلب',
              );
            }
          } else if (state.status == HolidayRequestStatus.submitError) {
            // Network or other errors
            ToastService.showError(
              gravity: ToastGravity.CENTER,
              state.errorMessage ?? 'فشل إرسال الطلب',
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: const PrimaryAppBar(
                title: 'طلب إجازة',
              ),
              body: SafeArea(
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
                                  BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                                    builder: (context, state) {
                                      final cubit = context.read<HolidayRequestCubit>();

                                      return InfoCard(
                                        title: 'نوع الإجازة',
                                        subtitle: state.selectedLeaveTypeName ?? 'اختر نوع الإجازة',
                                        subTitlestyle: state.selectedLeaveTypeName != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        value: state.selectedLeaveTypeName ?? 'اختر نوع الإجازة',
                                        onTap: () {
                                          BottomSheetWrapper(
                                            disableDrag: true,
                                            initialSize: .5.h,
                                            maxChildSize: .5.h,
                                            child: BlocProvider.value(
                                              value: cubit,
                                              child: const LeaveTypeListView(),
                                            ),
                                          ).callSheet(context);
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                                    builder: (context, state) {
                                      final cubit = context.read<HolidayRequestCubit>();
                                      return InfoCard(
                                        title: 'تبدأ من:',
                                        subtitle: state.startDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  AppTimezone.egypt,
                                                  DateTime.parse(state.startDate!),
                                                ),
                                                locale: 'en',
                                                pattern: 'yyyy-MM-dd',
                                              )
                                            : 'اختر تاريخ البدء',
                                        value: state.startDate ?? 'اختر تاريخ البدء',
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        showArrow: false,
                                        subTitlestyle: state.startDate != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          AppDatePicker.show(
                                            context,
                                            mode: CupertinoDatePickerMode.date,
                                            initialDate: state.startDate != null
                                                ? DateTime.parse(state.startDate!)
                                                : TimezoneHelper.now(AppTimezone.egypt),
                                            onDateChanged: cubit.selectStartDate,
                                            onDateConfirmed: cubit.selectStartDate,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                                    builder: (context, state) {
                                      final cubit = context.read<HolidayRequestCubit>();
                                      return InfoCard(
                                        title: 'تنتهي في:',
                                        subtitle: state.endDate != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  AppTimezone.egypt,
                                                  DateTime.parse(state.endDate!),
                                                ),
                                                locale: 'en',
                                                pattern: 'yyyy-MM-dd',
                                              )
                                            : 'اختر تاريخ النهاية',
                                        value: state.endDate ?? 'اختر تاريخ النهاية',
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        showArrow: false,
                                        subTitlestyle: state.endDate != null
                                            ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                            : null,
                                        onTap: () {
                                          AppDatePicker.show(
                                            context,
                                            mode: CupertinoDatePickerMode.date,
                                            initialDate: state.endDate != null
                                                ? DateTime.parse(state.endDate!)
                                                : state.startDate != null
                                                ? DateTime.parse(state.startDate!)
                                                : TimezoneHelper.now(AppTimezone.egypt),
                                            minimumYear: state.startDate != null
                                                ? DateTime.parse(state.startDate!).year
                                                : DateTime.now().year - 100,
                                            onDateChanged: cubit.selectEndDate,
                                            onDateConfirmed: cubit.selectEndDate,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                              builder: (context, state) {
                                final cubit = context.read<HolidayRequestCubit>();
                                // Check if selected leave type is annual leave
                                final isAnnualLeave =
                                    state.selectedLeaveTypeName != null &&
                                    (state.selectedLeaveTypeName!.toLowerCase().contains('annual') ||
                                        state.selectedLeaveTypeName!.contains('سنوية'));

                                return Visibility(
                                  visible: isAnnualLeave,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                                    decoration: BoxDecoration(
                                      color: context.colors.containerBackground,
                                      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('هل ترغب في استلام الراتب مُقدمًا؟', style: context.typography.semiBold16),
                                            Transform.scale(
                                              scale: 0.8,
                                              child: Switch.adaptive(
                                                value: state.advanceSalary,
                                                onChanged: cubit.toggleAdvanceSalary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                              builder: (context, state) {
                                final cubit = context.read<HolidayRequestCubit>();
                                // Check if selected leave type is annual leave
                                final isAnnualLeave =
                                    state.selectedLeaveTypeName != null &&
                                    (state.selectedLeaveTypeName!.toLowerCase().contains('annual') ||
                                        state.selectedLeaveTypeName!.contains('سنوية'));

                                return Visibility(
                                  visible: isAnnualLeave,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
                                    decoration: BoxDecoration(
                                      color: context.colors.containerBackground,
                                      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('تذكرة الطيران', style: context.typography.semiBold16),
                                            Transform.scale(
                                              scale: 0.8,
                                              child: Switch.adaptive(
                                                value: state.airTicket,
                                                onChanged: cubit.toggleAirTicket,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Visa Type InfoCard - visible only when airTicket is enabled
                            BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                              builder: (context, state) {
                                final cubit = context.read<HolidayRequestCubit>();

                                return Visibility(
                                  visible: state.airTicket,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w, vertical: AppSpacing.md.w),
                                    decoration: BoxDecoration(
                                      color: context.colors.containerBackground,
                                      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                                    ),
                                    child: Column(
                                      spacing: AppSpacing.md.w,
                                      children: [
                                        InfoCard(
                                          title: 'نوع التأشيرة',
                                          subtitle: state.visaTypeName ?? 'اختر نوع التأشيرة',
                                          subTitlestyle: state.visaTypeName != null
                                              ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                              : null,
                                          value: state.visaTypeName ?? 'اختر نوع التأشيرة',
                                          onTap: () {
                                            BottomSheetWrapper(
                                              disableDrag: true,
                                              initialSize: .3.h,
                                              maxChildSize: .3.h,
                                              child: BlocProvider.value(
                                                value: cubit,
                                                child: const VisaTypeListView(),
                                              ),
                                            ).callSheet(context);
                                          },
                                        ),
                                        InfoCard(
                                          title: 'مدة التأشيرة',
                                          subtitle: state.visaPeriod ?? 'أدخل مدة التأشيرة',
                                          subTitlestyle: state.visaPeriod != null
                                              ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                              : null,
                                          value: state.visaPeriod ?? 'أدخل مدة التأشيرة',
                                          onTap: () {
                                            _showVisaPeriodDialog(context, cubit, state.visaPeriod);
                                          },
                                        ),
                                        InfoCard(
                                          title: 'تاريخ التأشيرة',
                                          subtitle: state.visaDate != null
                                              ? TimezoneHelper.format(
                                                  TimezoneHelper.createTimestamp(
                                                    AppTimezone.egypt,
                                                    DateTime.parse(state.visaDate!),
                                                  ),
                                                  locale: 'en',
                                                  pattern: 'yyyy-MM-dd',
                                                )
                                              : 'اختر تاريخ التأشيرة',
                                          value: state.visaDate ?? 'اختر تاريخ التأشيرة',
                                          prefixIcon: Assets.vectorsCalendarFill,
                                          showArrow: false,
                                          subTitlestyle: state.visaDate != null
                                              ? context.typography.regular16.copyWith(color: context.colors.onSurface)
                                              : null,
                                          onTap: () {
                                            AppDatePicker.show(
                                              context,
                                              mode: CupertinoDatePickerMode.date,
                                              initialDate: state.visaDate != null
                                                  ? DateTime.parse(state.visaDate!)
                                                  : TimezoneHelper.now(AppTimezone.egypt),
                                              onDateChanged: cubit.selectVisaDate,
                                              onDateConfirmed: cubit.selectVisaDate,
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
                              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w, vertical: AppSpacing.md.w),
                              decoration: BoxDecoration(
                                color: context.colors.containerBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                              ),
                              child: Column(
                                spacing: AppSpacing.md.w,
                                children: [
                                  AppTextField(
                                    title: context.localizations.reason,
                                    controller: _descriptionController,
                                    hintTextLabel: 'أكتب سبب الإجازة إن وجد...',
                                    maxLines: 4,
                                    onChanged: (value) {
                                      context.read<HolidayRequestCubit>().updateDescription(value);
                                    },
                                  ),
                                  BlocBuilder<FileUploadCubit, FileUploadState>(
                                    bloc: _fileUploadCubit,
                                    builder: (context, fileUploadState) {
                                      // Hide upload area when uploading or when files exist
                                      final shouldShowUploadArea =
                                          !fileUploadState.isAnyFileUploading && fileUploadState.files.isEmpty;

                                      return Column(
                                        spacing: AppSpacing.md.w,
                                        children: [
                                          // Upload area - only show when no files are uploading or uploaded
                                          if (shouldShowUploadArea)
                                            Material(
                                              color: Colors.transparent,
                                              child: UploadFilePlacholder(
                                                onTap: () {
                                                  _fileUploadCubit.pickFiles();
                                                },
                                                isMaxFilesReached: fileUploadState.isMaxFilesReached,
                                              ),
                                            ),

                                          // Show uploaded files
                                          ...fileUploadState.files.map((file) => _buildFileItem(context, file)),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
                      builder: (context, state) {
                        final isLoading = state.status == HolidayRequestStatus.submitting;
                        final canSubmit = state.selectedLeaveTypeId != null && state.startDate != null && state.endDate != null;

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
                                  onTap: !canSubmit
                                      ? null
                                      : () {
                                          // Get uploaded files from FileUploadCubit
                                          final files = _fileUploadCubit.state.files
                                              .where((file) => file.isUploadComplete)
                                              .toList();

                                          // Submit the request
                                          context.read<HolidayRequestCubit>().submitHolidayRequest(files);
                                        },
                                  label: 'إرسال',
                                  appButtonSize: AppButtonSize.xxLarge,
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

void _showVisaPeriodDialog(BuildContext context, HolidayRequestCubit cubit, String? currentPeriod) {
  final controller = TextEditingController(text: currentPeriod);

  BottomSheetWrapper(
    initialSize: 0.23.h,
    maxChildSize: 0.23.h,
    removeAutoScroll: true,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md.h,
        children: [
          Text(
            'مدة التأشيرة',
            style: context.typography.semiBold18,
          ),
          AppTextField(
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$')),
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            controller: controller,
            keyboardType: TextInputType.number,
            hintTextLabel: 'أدخل عدد الأيام',
          ),
          SizedBox(height: AppSpacing.md.h),
          PrimaryTextButton(
            onTap: () {
              if (controller.text.isNotEmpty) {
                cubit.selectVisaPeriod(controller.text);
              }
              Navigator.of(context).pop();
            },
            label: 'تأكيد',
            appButtonSize: AppButtonSize.xxLarge,
          ),
        ],
      ),
    ),
  ).callSheet(context);
}
