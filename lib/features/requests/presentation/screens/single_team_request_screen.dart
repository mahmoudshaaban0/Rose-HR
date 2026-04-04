import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/utility/extensions.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/requests/data/models/pending_manager_requests_response_model.dart';
import 'package:rose_hr/features/requests/presentation/cubit/pending_manager_requests_cubit.dart';
import 'package:rose_hr/features/requests/presentation/widgets/approval_chain_widget.dart';
import 'package:rose_hr/features/requests/presentation/widgets/request_detail_row.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/outline_button_theme.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class SingleTeamRequestScreen extends StatelessWidget {
  const SingleTeamRequestScreen({
    required this.item,
    required this.pendingRequestsCubit,
    super.key,
  });

  final PendingRequestItem item;
  final PendingRequestsCubit pendingRequestsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: pendingRequestsCubit,
      child: BlocConsumer<PendingRequestsCubit, PendingRequestsState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.activeRequestId == item.id &&
            (current.status == PendingRequestsStatus.actionSuccess || current.status == PendingRequestsStatus.actionError),
        listener: (context, state) {
          if (state.status == PendingRequestsStatus.actionSuccess) {
            SnackbarService.showSuccess(
              context,
              state.actionMessage ?? context.localizations.done,
            );
            Navigator.of(context).pop();
          } else if (state.status == PendingRequestsStatus.actionError) {
            SnackbarService.showError(
              context,
              state.errorMessage ?? context.localizations.somethingWentWrong,
            );
          }
        },
        builder: (context, state) {
          final isActionLoading = state.status == PendingRequestsStatus.actionLoading && state.activeRequestId == item.id;

          return Scaffold(
            appBar: PrimaryAppBar(
              title: item.recordType == 'hr.request'
                  ? item.reqRequestTypeDisplay?.toString() ?? ''
                  : item.leaveTypeName?.toString() ?? '',
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.md.h,
                      ),
                      child: _buildBody(context),
                    ),
                  ),
                  _buildActionBar(context, isActionLoading),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final isLeaveRequest = item.recordType == 'hr.leave';
    final isHrRequest = item.recordType == 'hr.request';

    return Column(
      children: [
        // ── Main details card ─────────────────────────────────
        Container(
          padding: EdgeInsets.all(AppSpacing.md.r),
          decoration: BoxDecoration(
            color: context.colors.containerBackground,
            borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: employee name + date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.employeeName ?? '',
                          style: context.typography.semiBold18,
                        ),
                        if (!(item.reqManagerName?.toString()).isNullOrEmpty) ...[
                          SizedBox(height: AppSpacing.xs.h),
                          Text(
                            '${context.localizations.managerName} - ${item.reqManagerName}',
                            style: context.typography.regular14.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!(item.reqDate?.toString()).isNullOrEmpty)
                    Text(
                      item.reqDate?.toString() ?? '',
                      style: context.typography.regular14,
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.md.h),
              const AppDivider(),
              SizedBox(height: AppSpacing.md.h),

              // Request number
              if (item.name != null) ...[
                RequestDetailRow(
                  icon: Assets.vectorsHashtag,
                  title: context.localizations.requestNumber,
                  trailingText: item.name,
                ),
                SizedBox(height: AppSpacing.md.h),
              ],

              // ══════════════════════════════════════════════════
              // HR.REQUEST FIELDS
              // ══════════════════════════════════════════════════
              if (isHrRequest) ...[
                if (!(item.reqRequestTypeDisplay?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsPulseLine,
                    title: context.localizations.requestType,
                    trailingWidget: _buildBadge(
                      context,
                      text: item.reqRequestTypeDisplay.toString(),
                      bg: context.colors.surfaceDim,
                      border: context.colors.info,
                      textColor: context.colors.info,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqShiftName?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsTime,
                    title: context.localizations.shift,
                    trailingText: item.reqShiftName?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqTimeFrom?.toString()).isNullOrEmpty &&
                    _hasValidTime(double.tryParse(item.reqTimeFrom?.toString() ?? '0.0'))) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsTime,
                    title: context.localizations.timeFrom,
                    trailingText: _decimalHoursToTime(double.parse(item.reqTimeFrom.toString())),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqTimeTo?.toString()).isNullOrEmpty &&
                    _hasValidTime(double.tryParse(item.reqTimeTo?.toString() ?? '0.0'))) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsTime,
                    title: context.localizations.timeTo,
                    trailingText: _decimalHoursToTime(double.parse(item.reqTimeTo.toString())),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqRequestedDuration?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsTime,
                    title: context.localizations.requestedDuration,
                    trailingText: _formatDuration(
                      context,
                      double.tryParse(item.reqRequestedDuration?.toString() ?? '0') ?? 0,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqWorkMissionType?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsPulseLine,
                    title: context.localizations.workMissionTypeLabel,
                    trailingText: item.reqWorkMissionType?.toString() == 'hours'
                        ? context.localizations.workMissionTypeHours
                        : context.localizations.workMissionTypeDays,
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqMissionStartDate?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsCalendarFill,
                    title: context.localizations.missionStartDate,
                    trailingText: item.reqMissionStartDate?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqMissionEndDate?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsCalendarFill,
                    title: context.localizations.missionEndDate,
                    trailingText: item.reqMissionEndDate?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqCorrectionType?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsPulseLine,
                    title: context.localizations.correctionType,
                    trailingText: item.reqCorrectionType?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqFixAttendanceMethod?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsPulseLine,
                    title: context.localizations.fixAttendanceMethod,
                    trailingText: item.reqFixAttendanceMethod?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqCorrectionTime?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsTime,
                    title: context.localizations.correctionTime,
                    trailingText: item.reqCorrectionTime?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.reqRequestedDays?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsCalendarFill,
                    title: context.localizations.numberOfDays,
                    trailingText: item.reqRequestedDays?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],
              ],

              // ══════════════════════════════════════════════════
              // HR.LEAVE FIELDS
              // ══════════════════════════════════════════════════
              if (isLeaveRequest) ...[
                if (!(item.leaveTypeName?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsPulseLine,
                    title: context.localizations.leaveType,
                    trailingWidget: _buildBadge(
                      context,
                      text: item.leaveTypeName.toString(),
                      bg: context.colors.surfaceDim,
                      border: context.colors.info,
                      textColor: context.colors.info,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.leaveDateFrom?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsCalendarFill,
                    title: context.localizations.from,
                    trailingText: item.leaveDateFrom?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.leaveDateTo?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsCalendarFill,
                    title: context.localizations.to,
                    trailingText: item.leaveDateTo?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if (!(item.leaveNumberOfDays?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsCalendarFill,
                    title: context.localizations.numberOfDays,
                    trailingText: item.leaveNumberOfDays?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if ((item.leaveRequireExitEntryVisa == true) && !(item.leaveVisaType?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsPulseLine,
                    title: context.localizations.visaType,
                    trailingText: item.leaveVisaType?.toString(),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],

                if ((item.leaveRequireExitEntryVisa == true) && !(item.leaveVisaPeriod?.toString()).isNullOrEmpty) ...[
                  RequestDetailRow(
                    icon: Assets.vectorsTime,
                    title: context.localizations.visaPeriod,
                    trailingText: '${item.leaveVisaPeriod} ${context.localizations.months}',
                  ),
                  SizedBox(height: AppSpacing.md.h),
                ],
              ],

              // ══════════════════════════════════════════════════
              // COMMON FIELDS
              // ══════════════════════════════════════════════════
              if (item.stateDisplay != null) ...[
                RequestDetailRow(
                  icon: Assets.vectorsPulseLine,
                  title: context.localizations.requestStatus,
                  trailingWidget: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm.w,
                      vertical: AppSpacing.xs.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.statusPendingBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                      border: Border.all(color: context.colors.error),
                    ),
                    child: Text(
                      item.stateDisplay!,
                      style: context.typography.medium12.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
              ],

              if (isHrRequest && !(item.reqReason?.toString()).isNullOrEmpty) ...[
                const AppDivider(),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  context.localizations.reason,
                  style: context.typography.semiBold16,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.md.r),
                  ),
                  child: Text(
                    item.reqReason.toString(),
                    style: context.typography.medium16,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
              ],

              if (isLeaveRequest && !(item.leaveDescription?.toString()).isNullOrEmpty) ...[
                const AppDivider(),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  context.localizations.notes,
                  style: context.typography.semiBold16,
                ),
                SizedBox(height: AppSpacing.sm.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.md.r),
                  ),
                  child: Text(
                    item.leaveDescription.toString(),
                    style: context.typography.medium16,
                  ),
                ),
                SizedBox(height: AppSpacing.md.h),
              ],
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md.h),

        // ── Approval chain card ───────────────────────────────
        if (!(item.reqManagerName?.toString()).isNullOrEmpty)
          Container(
            padding: EdgeInsets.all(AppSpacing.md.r),
            decoration: BoxDecoration(
              color: context.colors.containerBackground,
              borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localizations.approvalChain,
                  style: context.typography.semiBold16,
                ),
                SizedBox(height: AppSpacing.md.h),
                ApprovalChainWidget(
                  employees: [
                    ApprovalEmployee(
                      name: item.reqManagerName.toString(),
                      status: item.state == 'approve' || item.state == 'done'
                          ? ApprovalStatus.approved
                          : item.state == 'refuse'
                          ? ApprovalStatus.rejected
                          : ApprovalStatus.pending,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md.h),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, bool isActionLoading) {
    final canApprove = item.canApprove ?? false;
    final canReject = item.canReject ?? false;

    if (!canApprove && !canReject) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (canApprove)
              PrimaryTextButton(
                appButtonSize: AppButtonSize.xxLarge,
                label: context.localizations.approveRequest,
                onTap: isActionLoading
                    ? null
                    : () => context.read<PendingRequestsCubit>().approveRequest(
                        recordType: item.recordType ?? 'hr.request',
                        requestId: item.id ?? 0,
                        approvalType: item.pendingOn ?? 'manager',
                      ),
              ),
            if (canApprove && canReject) SizedBox(height: AppSpacing.sm.h),
            if (canReject)
              OutlineTextButton(
                size: AppButtonSize.xxLarge,
                overriddenBorderColor: context.colors.onSurface,
                overriddenBackgroundColor: context.colors.surface,
                appButtonSize: AppButtonSize.xxLarge,
                label: context.localizations.rejectRequest,
                onTap: isActionLoading ? null : () => _showActionBottomSheet(context),
              ),
          ],
        ),
      ),
    );
  }

  void _showActionBottomSheet(BuildContext context) {
    BottomSheetWrapper(
      useSolidBackground: true,
      initialSize: 0.2.h,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.md.h),
            Text(
              context.localizations.rejectRequest,
              style: context.typography.semiBold16,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md.h),
            OutlineTextButton(
              size: AppButtonSize.xxLarge,
              overriddenBorderColor: context.colors.error,
              overriddenBackgroundColor: context.colors.surface,
              appButtonSize: AppButtonSize.xxLarge,
              label: context.localizations.rejectRequest,
              onTap: () {
                Navigator.pop(context);
                context.read<PendingRequestsCubit>().rejectRequest(
                  recordType: item.recordType ?? 'hr.request',
                  requestId: item.id ?? 0,
                );
              },
            ),
            SizedBox(height: AppSpacing.md.h),
          ],
        ),
      ),
    ).callSheet(context);
  }

  Widget _buildBadge(
    BuildContext context, {
    required String text,
    required Color bg,
    required Color border,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.sm.r),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: context.typography.medium12.copyWith(color: textColor),
      ),
    );
  }

  bool _hasValidTime(double? decimal) => decimal != null && decimal > 0;

  String _decimalHoursToTime(double decimal) {
    final hours = decimal.floor();
    final minutes = ((decimal - hours) * 60).round();
    final dateTime = DateTime(0, 1, 1, hours, minutes);
    try {
      return DateFormat('hh:mm a').format(dateTime);
    } on Exception catch (_) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }
  }

  String _formatDuration(BuildContext context, double decimal) {
    final hours = decimal.floor();
    final minutes = ((decimal - hours) * 60).round();
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
