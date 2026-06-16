import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/utility/extensions.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/attachment_viewer_widget.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/requests/data/models/employee_list_response_model.dart';
import 'package:rose_hr/features/requests/data/models/single_request_response_by_id.dart';
import 'package:rose_hr/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:rose_hr/features/requests/presentation/cubit/single_request_cubit.dart';
import 'package:rose_hr/features/requests/presentation/widgets/approval_chain_widget.dart';
import 'package:rose_hr/features/requests/presentation/widgets/request_detail_row.dart';
import 'package:rose_hr/features/requests/presentation/widgets/request_item_shimmer.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class SingleRequestScreen extends StatelessWidget {
  const SingleRequestScreen({required this.request, required this.parentRequestsCubit, super.key});
  final Datum? request;
  final RequestsCubit? parentRequestsCubit;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<SingleRequestCubit>()..getSingleRequest(request?.recordType ?? '', request?.id ?? 0),
        ),
        BlocProvider.value(
          value: parentRequestsCubit!,
        ),
      ],
      child: BlocListener<SingleRequestCubit, SingleRequestState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == SingleRequestStatus.cancelSuccess) {
            SnackbarService.showSuccess(
              context,
              context.localizations.requestCancelledSuccessfully,
            );
            parentRequestsCubit?.getEmployeeList();
          } else if (state.status == SingleRequestStatus.cancelError) {
            SnackbarService.showError(
              context,
              state.errorMessage ?? context.localizations.failedToCancelRequest,
            );
          } else if (state.status == SingleRequestStatus.cancelling) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              // Use a local navigator so pop() only closes this dialog,
              // never the underlying screen.
              useRootNavigator: false,
              builder: (_) => const Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          // Dismiss the loading dialog — use the same non-root navigator
          if (state.status == SingleRequestStatus.cancelSuccess || state.status == SingleRequestStatus.cancelError) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: PrimaryAppBar(
            title: switch (request?.recordType) {
              'hr.request' => request?.reqRequestTypeDisplay ?? '',
              'hr.end.of.service' => context.localizations.endOfServiceRequest,
              _ => request?.leaveTypeName ?? '',
            },
          ),
          body: SafeArea(
            child: BlocBuilder<SingleRequestCubit, SingleRequestState>(
              // Only rebuild the UI for fetch-related status changes.
              // Cancel sub-states (cancelling / cancelSuccess / cancelError)
              // are handled exclusively by the BlocListener above — they must
              // NOT trigger a rebuild so the displayed data never disappears.
              buildWhen: (previous, current) =>
                  current.status == SingleRequestStatus.loading ||
                  current.status == SingleRequestStatus.success ||
                  current.status == SingleRequestStatus.error,
              builder: (context, state) {
                if (state.status == SingleRequestStatus.loading) {
                  return _buildLoadingState();
                }

                if (state.status == SingleRequestStatus.error) {
                  return _buildErrorState(context, state.errorMessage);
                }

                final data = state.singleRequestResponse?.result?.data;
                if (data == null) {
                  return _buildLoadingState();
                }
                return _buildSuccessState(context, data);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.md.h,
      ),
      child: const RequestItemShimmer(),
    );
  }

  Widget _buildErrorState(BuildContext context, String? errorMessage) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await context.read<SingleRequestCubit>().getSingleRequest(request?.recordType ?? '', request?.id ?? 0);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.r,
                  color: context.colors.error,
                ),
                SizedBox(height: AppSpacing.md.h),
                Text(
                  errorMessage ?? context.localizations.somethingWentWrong,
                  style: context.typography.medium16,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.lg.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<SingleRequestCubit>().getSingleRequest(request?.recordType ?? '', request?.id ?? 0);
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(context.localizations.tryAgainAfter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.onSurface,
                    foregroundColor: context.colors.surface,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl.w,
                      vertical: AppSpacing.md.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, Data data) {
    final canCancel = _canCancelRequest(data.state);
    final isLeaveRequest = data.recordType == 'hr.leave';
    final isHrRequest = data.recordType == 'hr.request';
    final isEosRequest = data.recordType == 'hr.end.of.service';

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await context.read<SingleRequestCubit>().getSingleRequest(request?.recordType ?? '', request?.id ?? 0);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.md.h,
              ),
              child: Column(
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
                                    data.employeeName ?? '',
                                    style: context.typography.semiBold18,
                                  ),
                                  if (!data.reqManagerName.isNullOrEmpty) ...[
                                    SizedBox(height: AppSpacing.xs.h),
                                    Text(
                                      '${context.localizations.managerName} - ${data.reqManagerName}',
                                      style: context.typography.regular14.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (!data.reqDate.isNullOrEmpty)
                              Text(
                                _formatDate(data.reqDate),
                                style: context.typography.regular14,
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        const AppDivider(),
                        SizedBox(height: AppSpacing.md.h),

                        // Request number
                        if (data.name != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsHashtag,
                            title: context.localizations.requestNumber,
                            trailingText: data.name,
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // ══════════════════════════════════════════════════
                        // HR.REQUEST FIELDS
                        // ══════════════════════════════════════════════════
                        if (isHrRequest) ...[
                          // Request type badge
                          if (!data.reqRequestTypeDisplay.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.requestType,
                              trailingWidget: _buildBadge(
                                context,
                                text: data.reqRequestTypeDisplay!,
                                bg: context.colors.surfaceDim,
                                border: context.colors.info,
                                textColor: context.colors.info,
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Shift name
                          if (!data.reqShiftName.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.shift,
                              trailingText: data.reqShiftName,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Time from (hide if 0.0)
                          if (!data.reqTimeFrom.isNullOrEmpty && _hasValidTime(double.tryParse(data.reqTimeFrom ?? '0.0'))) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.timeFrom,
                              trailingText: _decimalHoursToTime(double.parse(data.reqTimeFrom!)),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Time to (hide if 0.0)
                          if (!data.reqTimeTo.isNullOrEmpty && _hasValidTime(double.tryParse(data.reqTimeTo ?? '0.0'))) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.timeTo,
                              trailingText: _decimalHoursToTime(double.parse(data.reqTimeTo!)),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Requested duration
                          if (!data.reqRequestedDuration.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.requestedDuration,
                              trailingText: _formatDuration(context, double.parse(data.reqRequestedDuration!)),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Work mission type
                          if (!data.reqWorkMissionType.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.workMissionTypeLabel,
                              trailingText: data.reqWorkMissionType == 'hours'
                                  ? context.localizations.workMissionTypeHours
                                  : context.localizations.workMissionTypeDays,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Mission start date (for days-type work missions)
                          if (!data.reqMissionStartDate.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.missionStartDate,
                              trailingText: _formatDate(data.reqMissionStartDate),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Mission end date
                          if (!data.reqMissionEndDate.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.missionEndDate,
                              trailingText: _formatDate(data.reqMissionEndDate),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Correction type
                          if (!data.reqCorrectionType.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.correctionType,
                              trailingText: data.reqCorrectionType,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Fix attendance method
                          if (!data.reqFixAttendanceMethod.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.fixAttendanceMethod,
                              trailingText: data.reqFixAttendanceMethod,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Correction time
                          if (!data.reqCorrectionTime.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.correctionTime,
                              trailingText: data.reqCorrectionTime,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Requested days (for work missions)
                          if (!data.reqRequestedDays.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.numberOfDays,
                              trailingText: data.reqRequestedDays,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],
                        ],

                        // ══════════════════════════════════════════════════
                        // HR.LEAVE FIELDS
                        // ══════════════════════════════════════════════════
                        if (isLeaveRequest) ...[
                          // Leave type name
                          if (!data.leaveTypeName.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.leaveType,
                              trailingWidget: _buildBadge(
                                context,
                                text: data.leaveTypeName!,
                                bg: context.colors.surfaceDim,
                                border: context.colors.info,
                                textColor: context.colors.info,
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Leave date from
                          if (!data.leaveDateFrom.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.from,
                              trailingText: data.leaveDateFrom ?? '',
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Leave date to
                          if (!data.leaveDateTo.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.to,
                              trailingText: data.leaveDateTo ?? '',
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Number of days
                          if (!data.leaveNumberOfDays.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.numberOfDays,
                              trailingText: data.leaveNumberOfDays ?? '',
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Visa type (only if visa is required)
                          if ((data.leaveRequireExitEntryVisa ?? false) && !data.leaveVisaType.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.visaType,
                              trailingText: data.leaveVisaType ?? '',
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Visa period (only if visa is required)
                          if ((data.leaveRequireExitEntryVisa ?? false) && !data.leaveVisaPeriod.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.visaPeriod,
                              trailingText: '${data.leaveVisaPeriod ?? ''} ${context.localizations.months}',
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],
                        ],

                        // ══════════════════════════════════════════════════
                        // HR.END.OF.SERVICE FIELDS
                        // ══════════════════════════════════════════════════
                        if (isEosRequest) ...[
                          // Resignation reason badge
                          if (!data.clrResignationReason.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.resignationReason,
                              trailingWidget: _buildBadge(
                                context,
                                text: _resignationReasonLabel(
                                  context,
                                  data.clrResignationReason,
                                ),
                                bg: context.colors.surfaceDim,
                                border: context.colors.info,
                                textColor: context.colors.info,
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Last working day
                          if (!data.clrLastWorkingDay.isNullOrEmpty) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.lastWorkingDay,
                              trailingText: _formatDate(data.clrLastWorkingDay),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Service period
                          if (data.clrServiceYears != null ||
                              data.clrServiceMonths != null ||
                              data.clrServiceDays != null) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsTime,
                              title: context.localizations.servicePeriod,
                              trailingText: _formatServicePeriod(context, data),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],

                          // Physical custody cleared
                          if (data.clrPhysicalCustodyCleared != null) ...[
                            RequestDetailRow(
                              icon: Assets.vectorsPulseLine,
                              title: context.localizations.physicalCustodyCleared,
                              trailingWidget: _buildBadge(
                                context,
                                text: (data.clrPhysicalCustodyCleared ?? false)
                                    ? context.localizations.cleared
                                    : context.localizations.notCleared,
                                bg: context.colors.surfaceDim,
                                border: (data.clrPhysicalCustodyCleared ?? false)
                                    ? context.colors.success
                                    : context.colors.error,
                                textColor: (data.clrPhysicalCustodyCleared ?? false)
                                    ? context.colors.success
                                    : context.colors.error,
                              ),
                            ),
                            SizedBox(height: AppSpacing.md.h),
                          ],
                        ],

                        // ══════════════════════════════════════════════════
                        // COMMON FIELDS (both hr.request and hr.leave)
                        // ══════════════════════════════════════════════════

                        // Status badge
                        if (data.stateDisplay != null) ...[
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
                                data.stateDisplay!,
                                style: context.typography.medium12.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Reason (for hr.request) or Description (for hr.leave)
                        if (isHrRequest && !data.reqReason.isNullOrEmpty) ...[
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
                              data.reqReason!,
                              style: context.typography.medium16,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        if (isLeaveRequest && !data.leaveDescription.isNullOrEmpty) ...[
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
                              data.leaveDescription!,
                              style: context.typography.medium16,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        if (isEosRequest && !data.clrResignationReasonDetail.isNullOrEmpty) ...[
                          const AppDivider(),
                          SizedBox(height: AppSpacing.md.h),
                          Text(
                            context.localizations.resignationReasonDetail,
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
                              data.clrResignationReasonDetail!,
                              style: context.typography.medium16,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Attachments
                        if (data.attachments != null && data.attachments!.isNotEmpty) ...[
                          const AppDivider(),
                          SizedBox(height: AppSpacing.md.h),
                          Text(
                            context.localizations.attachments,
                            style: context.typography.semiBold16,
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          AttachmentViewerWidget(attachments: data.attachments!),
                          SizedBox(height: AppSpacing.md.h),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.md.h),

                  // ── Settlement card (hr.end.of.service) ───────────────
                  if (isEosRequest) ...[
                    _buildSettlementCard(context, data),
                    SizedBox(height: AppSpacing.md.h),
                  ],

                  // ── Approval chain card ───────────────────────────────
                  if (data.approvalChain != null && data.approvalChain!.isNotEmpty)
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
                              for (final step in data.approvalChain!)
                                for (final name in step.approvalNames ?? <String>[])
                                  ApprovalEmployee(
                                    name: name,
                                    status: ApprovalStatus.fromApi(step.approvalStatus),
                                  ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (canCancel)
          Container(
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
              child: SizedBox(
                width: double.infinity,
                child: PrimaryTextButton(
                  appButtonSize: AppButtonSize.xxLarge,
                  label: context.localizations.cancelRequest,
                  overriddenBackgroundColor: context.colors.error,
                  onTap: () {
                    _showCancelConfirmationDialog(context, data.recordType ?? '', data.id ?? 0);
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Financial breakdown card shown for end-of-service requests.
  Widget _buildSettlementCard(BuildContext context, Data data) {
    final rows = <Widget>[];

    void addRow(String title, num? value, {bool isDeduction = false}) {
      if (value == null) return;
      rows
        ..add(
          RequestDetailRow(
            icon: Assets.vectorsPulseLine,
            title: title,
            trailingText: '${isDeduction && value > 0 ? '-' : ''}${_formatAmount(value)}',
          ),
        )
        ..add(SizedBox(height: AppSpacing.md.h));
    }

    addRow(context.localizations.totalSalary, data.clrTotalSalary);
    addRow(context.localizations.leaveBalanceDays, data.clrLeaveBalanceDays);
    addRow(context.localizations.leaveBalanceAmount, data.clrLeaveBalanceAmount);
    addRow(context.localizations.eosGratuity, data.clrEosGratuity);
    addRow(context.localizations.totalAdditions, data.clrTotalAdditions);
    addRow(context.localizations.loanSettlement, data.clrLoanSettlement, isDeduction: true);
    addRow(context.localizations.totalDeductions, data.clrTotalDeductions, isDeduction: true);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localizations.settlementDetails,
            style: context.typography.semiBold16,
          ),
          SizedBox(height: AppSpacing.md.h),
          const AppDivider(),
          SizedBox(height: AppSpacing.md.h),
          ...rows,
          if (data.clrNetAmount != null) ...[
            const AppDivider(),
            SizedBox(height: AppSpacing.md.h),
            Row(
              children: [
                Text(
                  context.localizations.netAmount,
                  style: context.typography.semiBold16,
                ),
                const Spacer(),
                Text(
                  _formatAmount(data.clrNetAmount!),
                  style: context.typography.semiBold18.copyWith(
                    color: context.colors.success,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Maps the raw resignation reason key to a localized label.
  String _resignationReasonLabel(BuildContext context, String? reason) {
    return switch (reason) {
      'resignation' => context.localizations.resignationReasonResignation,
      'termination' => context.localizations.resignationReasonTermination,
      _ => reason ?? '',
    };
  }

  /// Builds a "1 years 11 months 7 days" style service period string,
  /// skipping any zero components.
  String _formatServicePeriod(BuildContext context, Data data) {
    final parts = <String>[];
    if ((data.clrServiceYears ?? 0) > 0) {
      parts.add('${data.clrServiceYears} ${context.localizations.years}');
    }
    if ((data.clrServiceMonths ?? 0) > 0) {
      parts.add('${data.clrServiceMonths} ${context.localizations.months}');
    }
    if ((data.clrServiceDays ?? 0) > 0) {
      parts.add('${data.clrServiceDays} ${context.localizations.days}');
    }
    return parts.isEmpty ? '0 ${context.localizations.days}' : parts.join(' ');
  }

  /// Formats a numeric amount with thousands separators and 2 decimals.
  String _formatAmount(num value) {
    return NumberFormat('#,##0.00').format(value);
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

  /// Returns true when a decimal time value should be shown (non-null and > 0).
  bool _hasValidTime(double? decimal) => decimal != null && decimal > 0;

  /// Converts a decimal hours value (e.g. 16.65) to 12-hour time (e.g. "04:39 PM").
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

  /// Formats a decimal hours duration to a human-readable string (e.g. "3h 9m").
  String _formatDuration(BuildContext context, double decimal) {
    final hours = decimal.floor();
    final minutes = ((decimal - hours) * 60).round();
    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  String _formatDate(String? date) {
    return date ?? '';
  }

  bool _canCancelRequest(String? state) {
    // Can cancel if the request is not done, cancelled, or refused
    return state != 'done' &&
        state != 'cancel' &&
        state != 'cancelled' &&
        state != 'refuse' &&
        state != 'approved' &&
        state != 'rejected' &&
        state != 'validate';
  }

  void _showCancelConfirmationDialog(BuildContext context, String recordType, int recordId) {
    if (recordType.isNullOrEmpty || recordId == 0) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          context.localizations.cancelRequest,
          style: context.typography.semiBold18,
        ),
        content: Text(
          context.localizations.cancelRequestConfirmation,
          style: context.typography.regular14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              context.localizations.cancel,
              style: context.typography.medium14.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<SingleRequestCubit>().cancelRequest(recordType, recordId);
            },
            child: Text(
              context.localizations.cancelRequest,
              style: context.typography.medium14.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
