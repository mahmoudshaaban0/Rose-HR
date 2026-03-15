import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
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
          create: (context) => sl<SingleRequestCubit>()..getSingleRequest(request?.id ?? 0),
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
          appBar: PrimaryAppBar(title: _getLocalizedRequestType(context, request?.requestType)),
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
        await context.read<SingleRequestCubit>().getSingleRequest(request?.id ?? 0);
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
                    context.read<SingleRequestCubit>().getSingleRequest(request?.id ?? 0);
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

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              await context.read<SingleRequestCubit>().getSingleRequest(request?.id ?? 0);
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
                                  if (data.managerName != null) ...[
                                    SizedBox(height: AppSpacing.xs.h),
                                    Text(
                                      '${context.localizations.managerName} - ${data.managerName}',
                                      style: context.typography.regular14.copyWith(
                                        color: context.colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (data.date != null)
                              Text(
                                _formatDate(data.date),
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

                        // Request type badge
                        if (data.requestTypeDisplay != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsPulseLine,
                            title: context.localizations.requestType,
                            trailingWidget: _buildBadge(
                              context,
                              text: data.requestTypeDisplay!,
                              bg: context.colors.surfaceDim,
                              border: context.colors.info,
                              textColor: context.colors.info,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Status badge (keep original fixed colors)
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

                        // Shift name
                        if (data.shiftName != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsTime,
                            title: context.localizations.shift,
                            trailingText: data.shiftName,
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Time from (hide if 0.0)
                        if (_hasValidTime(data.timeFrom)) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsTime,
                            title: context.localizations.timeFrom,
                            trailingText: _decimalHoursToTime(data.timeFrom!),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Time to (hide if 0.0)
                        if (_hasValidTime(data.timeTo)) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsTime,
                            title: context.localizations.timeTo,
                            trailingText: _decimalHoursToTime(data.timeTo!),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Requested duration
                        if (data.requestedDuration != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsTime,
                            title: context.localizations.requestedDuration,
                            trailingText: _formatDuration(context, data.requestedDuration!),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Work mission type
                        if (data.workMissionType != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsPulseLine,
                            title: context.localizations.workMissionTypeLabel,
                            trailingText: data.workMissionType == 'hours'
                                ? context.localizations.workMissionTypeHours
                                : context.localizations.workMissionTypeDays,
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Mission start date (for days-type work missions)
                        if (data.missionStartDate != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsCalendarFill,
                            title: context.localizations.missionStartDate,
                            trailingText: _formatDate(data.missionStartDate),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Mission end date
                        if (data.missionEndDate != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsCalendarFill,
                            title: context.localizations.missionEndDate,
                            trailingText: _formatDate(data.missionEndDate),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        // Reason
                        if (data.reason != null && data.reason!.isNotEmpty) ...[
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
                              data.reason!,
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

                  // ── Approval chain card ───────────────────────────────
                  if (data.managerName != null)
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
                                name: data.managerName!,
                                status: data.state == 'approve' || data.state == 'done'
                                    ? ApprovalStatus.approved
                                    : data.state == 'refuse'
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
                    _showCancelConfirmationDialog(context, data.id);
                  },
                ),
              ),
            ),
          ),
      ],
    );
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

  String _getLocalizedRequestType(BuildContext context, String? requestType) {
    if (requestType == null) return '';

    switch (requestType) {
      case 'fix_attendance':
        return context.localizations.attendanceCorrection;
      case 'work_mission':
        return context.localizations.workMission;
      case 'leave_request':
        return context.localizations.leaveRequest;
      case 'permission_request':
        return context.localizations.permissionRequest;
      case 'late_in':
        return context.localizations.lateArrival;
      case 'early_out':
        return context.localizations.earlyOut;
      case 'mid_day':
        return context.localizations.midDay;
      default:
        return requestType;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    try {
      return DateFormat('yyyy-MM-dd', 'en').format(date);
    } on Exception catch (_) {
      return date.toString();
    }
  }

  bool _canCancelRequest(String? state) {
    // Can cancel if the request is not done, cancelled, or refused
    return state != 'done' && state != 'cancel' && state != 'cancelled' && state != 'refuse' && state != 'approved';
  }

  void _showCancelConfirmationDialog(BuildContext context, int? requestId) {
    if (requestId == null) return;

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
              context.read<SingleRequestCubit>().cancelRequest(requestId);
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
