import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/cubits/file_upload/file_upload_cubit.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/widgets/app_datepicker.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/file_upload_widget.dart';
import 'package:rose_hr/common/widgets/info_card.dart';
import 'package:rose_hr/common/widgets/success_request_bottomsheet.dart';
import 'package:rose_hr/features/eos/presentation/cubit/eos_cubit.dart';
import 'package:rose_hr/features/eos/presentation/widgets/resignation_reason_listview.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_textfield.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class EosScreen extends StatefulWidget {
  const EosScreen({super.key});

  @override
  State<EosScreen> createState() => _EosScreenState();
}

class _EosScreenState extends State<EosScreen> {
  late final FileUploadCubit _fileUploadCubit;
  late final TextEditingController _detailController;

  @override
  void initState() {
    super.initState();
    _fileUploadCubit = sl<FileUploadCubit>();
    _detailController = TextEditingController();
  }

  @override
  void dispose() {
    _fileUploadCubit.close();
    _detailController.dispose();
    super.dispose();
  }

  String _reasonLabel(BuildContext context, ResignationReason reason) {
    return switch (reason) {
      ResignationReason.resignation => context.localizations.resignationReasonResignation,
      ResignationReason.termination => context.localizations.resignationReasonTermination,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EosCubit>()..loadNationality(),
      child: BlocListener<EosCubit, EosState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == EosStatus.submitting) {
            showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
            );
          } else if (state.status == EosStatus.submitted) {
            Navigator.of(context, rootNavigator: true).pop();

            final result = state.eosResponseModel?.result;
            if (result?.success ?? false) {
              BottomSheetWrapper(
                closeBottomSheetOnDrag: false,
                initialSize: .42.h,
                maxChildSize: .42.h,
                removeAutoScroll: true,
                disableDrag: true,
                useRootNavigator: true,
                child: const SuccessRequestBottomsheet(),
              ).callSheet(context);
              _detailController.clear();
              _fileUploadCubit.reset();
            } else {
              SnackbarService.showError(
                context,
                result?.message ?? context.localizations.failedToSendResignationRequest,
              );
            }
          } else if (state.status == EosStatus.submitError) {
            Navigator.of(context, rootNavigator: true).pop();
            SnackbarService.showError(
              context,
              state.errorMessage ?? context.localizations.failedToSendResignationRequest,
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: PrimaryAppBar(
                title: context.localizations.resignationRequestTitle,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md.w,
                                vertical: AppSpacing.md.w,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.containerBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                              ),
                              child: Column(
                                spacing: AppSpacing.md.w,
                                children: [
                                  BlocBuilder<EosCubit, EosState>(
                                    builder: (context, state) {
                                      final cubit = context.read<EosCubit>();
                                      return InfoCard(
                                        title: context.localizations.lastWorkingDay,
                                        subtitle: state.lastWorkingDay != null
                                            ? TimezoneHelper.format(
                                                TimezoneHelper.createTimestamp(
                                                  DateTime.parse(state.lastWorkingDay!),
                                                ),
                                                locale: 'en',
                                                pattern: 'yyyy-MM-dd',
                                              )
                                            : context.localizations.selectLastWorkingDay,
                                        value: state.lastWorkingDay ?? context.localizations.selectLastWorkingDay,
                                        prefixIcon: Assets.vectorsCalendarFill,
                                        showArrow: false,
                                        subTitlestyle: state.lastWorkingDay != null
                                            ? context.typography.regular16.copyWith(
                                                color: context.colors.onSurface,
                                              )
                                            : null,
                                        onTap: () {
                                          AppDatePicker.show(
                                            context,
                                            mode: CupertinoDatePickerMode.date,
                                            initialDate: state.lastWorkingDay != null
                                                ? DateTime.parse(state.lastWorkingDay!)
                                                : TimezoneHelper.now(),
                                            onDateChanged: cubit.selectLastWorkingDay,
                                            onDateConfirmed: cubit.selectLastWorkingDay,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  BlocBuilder<EosCubit, EosState>(
                                    builder: (context, state) {
                                      final cubit = context.read<EosCubit>();
                                      // Saudi employees can only resign, so there
                                      // is nothing to pick — hide the chevron and
                                      // skip the bottom sheet.
                                      return InfoCard(
                                        title: context.localizations.resignationReason,
                                        subtitle: _reasonLabel(context, state.resignationReason),
                                        value: state.resignationReason.value,
                                        showArrow: !state.isSaudi,
                                        subTitlestyle: context.typography.regular16.copyWith(
                                          color: context.colors.onSurface,
                                        ),
                                        onTap: state.isSaudi
                                            ? null
                                            : () {
                                                BottomSheetWrapper(
                                                  disableDrag: true,
                                                  initialSize: .3.h,
                                                  maxChildSize: .3.h,
                                                  child: BlocProvider.value(
                                                    value: cubit,
                                                    child: const ResignationReasonListView(),
                                                  ),
                                                ).callSheet(context);
                                              },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg.w,
                                vertical: AppSpacing.md.w,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.containerBackground,
                                borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                              ),
                              child: Column(
                                spacing: AppSpacing.md.w,
                                children: [
                                  AppTextField(
                                    title: context.localizations.resignationReasonDetail,
                                    controller: _detailController,
                                    hintTextLabel: context.localizations.enterResignationReasonHere,
                                    maxLines: 4,
                                    onChanged: (value) {
                                      context.read<EosCubit>().updateReasonDetail(value);
                                    },
                                  ),
                                  Align(
                                    alignment: context.localizations.localeName == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      context.localizations.attachments,
                                      style: context.typography.medium16,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  FileUploadWidget(cubit: _fileUploadCubit),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocBuilder<EosCubit, EosState>(
                      builder: (context, state) {
                        final isLoading = state.status == EosStatus.submitting;
                        final canSubmit = state.lastWorkingDay != null;

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
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md.w,
                                ),
                                child: PrimaryTextButton(
                                  onTap: !canSubmit
                                      ? null
                                      : () {
                                          final files = _fileUploadCubit.state.files
                                              .where((file) => file.isUploadComplete)
                                              .toList();
                                          context.read<EosCubit>().submitEos(files);
                                        },
                                  label: context.localizations.send,
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
