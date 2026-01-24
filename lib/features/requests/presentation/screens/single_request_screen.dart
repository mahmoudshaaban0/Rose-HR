import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/toast_service.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
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
            ToastService.showSuccess(
              gravity: ToastGravity.CENTER,
              context.localizations.requestCancelledSuccessfully,
            );
            parentRequestsCubit?.getEmployeeList();
          } else if (state.status == SingleRequestStatus.cancelError) {
            ToastService.showError(
              gravity: ToastGravity.CENTER,
              state.errorMessage ?? context.localizations.failedToCancelRequest,
            );
          } else if (state.status == SingleRequestStatus.cancelling) {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          // Dismiss loading dialog when cancelling is done
          if (state.status == SingleRequestStatus.cancelSuccess || state.status == SingleRequestStatus.cancelError) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
        child: Scaffold(
          appBar: PrimaryAppBar(title: _getLocalizedRequestType(context, request?.requestType)),
          body: SafeArea(
            child: BlocBuilder<SingleRequestCubit, SingleRequestState>(
              builder: (context, state) {
                if (state.status == SingleRequestStatus.loading) {
                  return _buildLoadingState();
                }

                if (state.status == SingleRequestStatus.error) {
                  return _buildErrorState(context, state.errorMessage);
                }

                if (state.status == SingleRequestStatus.success) {
                  final data = state.singleRequestResponse?.result?.data;
                  if (data == null) {
                    return _buildErrorState(context, context.localizations.noData);
                  }
                  return _buildSuccessState(context, data);
                }

                return const SizedBox.shrink();
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
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    decoration: BoxDecoration(
                      color: context.colors.containerBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
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
                                  SizedBox(height: AppSpacing.xs.h),
                                  Text(
                                    '${context.localizations.managerName} - ${data.managerName}',
                                    style: context.typography.regular14.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  data.date != null ? _formatDate(data.date) : '',
                                  style: context.typography.regular14.copyWith(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        const AppDivider(),
                        SizedBox(height: AppSpacing.md.h),

                        // Request Details
                        RequestDetailRow(
                          icon: Assets.vectorsHashtag,
                          title: context.localizations.requestNumber,
                          trailingText: data.name ?? '',
                        ),
                        SizedBox(height: AppSpacing.md.h),

                        RequestDetailRow(
                          icon: Assets.vectorsRequestsActive,
                          title: context.localizations.requestType,
                          trailingText: data.requestTypeDisplay ?? _getLocalizedRequestType(context, data.requestType),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        RequestDetailRow(
                          icon: Assets.vectorsPulseLine,
                          title: context.localizations.requestStatus,
                          trailingWidget: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm.w,
                              vertical: AppSpacing.xs.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusBackgroundColor(context, data.state),
                              borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                              border: Border.all(color: _getStatusBorderColor(context, data.state)),
                            ),
                            child: Text(
                              data.stateDisplay ?? '',
                              style: context.typography.medium12.copyWith(
                                color: _getStatusTextColor(context, data.state),
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(height: AppSpacing.md.h),

                        // if (data.employeeName != null) ...[
                        //   _buildDetailItem(
                        //     context: context,
                        //     icon: Assets.vectorsUserPlaceHolder,
                        //     title: context.localizations.firstName,
                        //     value: data.employeeName!,
                        //   ),
                        // SizedBox(height: AppSpacing.md.h),
                        // ],
                        SizedBox(height: AppSpacing.md.h),
                        if (data.shiftName != null) ...[
                          RequestDetailRow(
                            icon: Assets.vectorsTime,
                            title: context.localizations.shift,
                            trailingText: data.shiftName,
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],
                        SizedBox(height: AppSpacing.md.h),
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
                              data.requestTypeDisplay!,
                              style: context.typography.medium16,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],

                        if (data.attachments != null && data.attachments!.isNotEmpty) ...[
                          const AppDivider(),
                          SizedBox(height: AppSpacing.md.h),
                          Text(
                            context.localizations.attachments,
                            style: context.typography.semiBold16,
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          Text(
                            '${data.attachments!.length} ${context.localizations.attachments}',
                            style: context.typography.regular14.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    decoration: BoxDecoration(
                      color: context.colors.containerBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Approval Chain Section (Example with mock data)
                        // Approval Chain Section (Example with mock data)
                        if (data.managerName != null) ...[
                          SizedBox(height: AppSpacing.md.h),
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
                              // Additional approvers can be added here when API provides them
                            ],
                          ),
                          SizedBox(height: AppSpacing.md.h),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (canCancel) ...[
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
      ],
    );
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

  Color _getStatusBackgroundColor(BuildContext context, String? state) {
    switch (state) {
      case 'approve':
      case 'done':
        return context.colors.success.withValues(alpha: 0.1);
      case 'refuse':
        return context.colors.error.withValues(alpha: 0.1);
      case 'cancelled':
      case 'cancel':
        return context.colors.surfaceVariant;
      case 'draft':
      case 'confirm':
      default:
        return context.colors.statusPendingBackground;
    }
  }

  Color _getStatusBorderColor(BuildContext context, String? state) {
    switch (state) {
      case 'approve':
      case 'done':
        return context.colors.success;
      case 'refuse':
        return context.colors.error;
      case 'cancelled':
      case 'cancel':
        return context.colors.onSurfaceVariant;
      case 'draft':
      case 'confirm':
      default:
        return context.colors.statusPendingBorder;
    }
  }

  Color _getStatusTextColor(BuildContext context, String? state) {
    switch (state) {
      case 'approve':
      case 'done':
        return context.colors.success;
      case 'refuse':
        return context.colors.error;
      case 'cancelled':
      case 'cancel':
        return context.colors.onSurfaceVariant;
      case 'draft':
      case 'confirm':
      default:
        return context.colors.statusPendingText;
    }
  }

  bool _canCancelRequest(String? state) {
    // Can cancel if the request is not done, cancelled, or refused
    return state != 'done' && state != 'cancel' && state != 'cancelled' && state != 'refuse';
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
