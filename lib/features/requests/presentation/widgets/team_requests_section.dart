import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/requests/data/models/pending_manager_requests_response_model.dart';
import 'package:rose_hr/features/requests/presentation/cubit/pending_manager_requests_cubit.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/outline_button_theme.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class TeamRequestsSection extends StatelessWidget {
  const TeamRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PendingRequestsCubit, PendingRequestsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == PendingRequestsStatus.actionSuccess || current.status == PendingRequestsStatus.actionError),
      listener: (context, state) {
        if (state.status == PendingRequestsStatus.actionSuccess) {
          SnackbarService.showSuccess(
            context,
            state.actionMessage ?? context.localizations.done,
          );
        } else if (state.status == PendingRequestsStatus.actionError) {
          SnackbarService.showError(
            context,
            state.errorMessage ?? context.localizations.somethingWentWrong,
          );
        }
      },
      builder: (context, state) {
        if (state.status == PendingRequestsStatus.loading && state.pendingRequestsResponseModel == null) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.r,
              vertical: AppSpacing.xl.r,
            ),
            decoration: BoxDecoration(
              color: context.colors.containerBackground,
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        }

        if (state.status == PendingRequestsStatus.error && state.pendingRequestsResponseModel == null) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.r,
              vertical: AppSpacing.xl.r,
            ),
            decoration: BoxDecoration(
              color: context.colors.containerBackground,
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    state.errorMessage ?? context.localizations.somethingWentWrong,
                    style: context.typography.medium14,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => context.read<PendingRequestsCubit>().getPendingManagerRequests(),
                    child: Text(context.localizations.tryAgainAfter),
                  ),
                ],
              ),
            ),
          );
        }

        final requests = state.pendingRequestsResponseModel?.result?.data?.requests ?? [];
        if (requests.isEmpty) {
          return const SizedBox.shrink();
        }

        final displayRequests = requests.take(3).toList();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.r,
            vertical: AppSpacing.xl.r,
          ),
          decoration: BoxDecoration(
            color: context.colors.containerBackground,
            borderRadius: BorderRadius.circular(AppSpacing.lg.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.localizations.teamRequests,
                style: context.typography.semiBold16,
              ),
              SizedBox(height: AppSpacing.md.h),
              const AppDivider(),
              SizedBox(height: AppSpacing.sm.h),
              ...displayRequests.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    _TeamRequestExpansionTile(
                      item: item,
                      isActionLoading: state.status == PendingRequestsStatus.actionLoading && state.activeRequestId == item.id,
                      onApprove: () => context.read<PendingRequestsCubit>().approveRequest(
                        recordType: item.recordType ?? 'hr.request',
                        requestId: item.id ?? 0,
                        approvalType: item.pendingOn ?? 'manager',
                      ),
                      onReject: () => context.read<PendingRequestsCubit>().rejectRequest(
                        recordType: item.recordType ?? 'hr.request',
                        requestId: item.id ?? 0,
                      ),
                    ),
                    if (index != displayRequests.length - 1) ...[
                      SizedBox(height: AppSpacing.sm.h),
                      const AppDivider(),
                      SizedBox(height: AppSpacing.sm.h),
                    ],
                  ],
                );
              }),
              SizedBox(height: AppSpacing.md.h),
              const AppDivider(),
              SizedBox(height: AppSpacing.md.h),
              GestureDetector(
                onTap: () => context.push(AppRoutes.allPendingManagerRequests.path),
                child: Text(
                  context.localizations.viewAllRequests,
                  style: context.typography.medium16.copyWith(
                    color: context.colors.success,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TeamRequestExpansionTile extends StatefulWidget {
  const _TeamRequestExpansionTile({
    required this.item,
    required this.isActionLoading,
    required this.onApprove,
    required this.onReject,
  });

  final PendingRequestItem item;
  final bool isActionLoading;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  State<_TeamRequestExpansionTile> createState() => _TeamRequestExpansionTileState();
}

class _TeamRequestExpansionTileState extends State<_TeamRequestExpansionTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final requestTitle = _getRequestTitle(context);
    final employeeName = widget.item.employeeName ?? '--';
    final roleText = widget.item.stateDisplay ?? '';
    final date = _formatDate(widget.item.createDate);

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md.r),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        style: context.typography.semiBold16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (roleText.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xxs.h),
                        Text(
                          roleText,
                          style: context.typography.regular14.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requestTitle,
                        style: context.typography.semiBold14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                      SizedBox(height: AppSpacing.xxs.h),
                      Text(
                        date,
                        style: context.typography.regular14.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                // three dots icon
                InkWell(
                  onTap: () => _showActionBottomSheet(context),
                  child: Icon(
                    Icons.more_vert,
                    color: context.colors.onSurfaceVariant,
                    size: 24.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            PrimaryTextButton(
              appButtonSize: AppButtonSize.xxLarge,
              label: context.localizations.approveRequest,
              onTap: widget.isActionLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                      widget.onApprove();
                    },
            ),
            SizedBox(height: AppSpacing.md.h),
            OutlineTextButton(
              size: AppButtonSize.xxLarge,
              overriddenBorderColor: context.colors.onSurface,
              overriddenBackgroundColor: context.colors.surface,
              appButtonSize: AppButtonSize.xxLarge,
              label: context.localizations.rejectRequest,
              onTap: widget.isActionLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                      widget.onReject();
                    },
            ),
            SizedBox(height: AppSpacing.md.h),
          ],
        ),
      ),
    ).callSheet(context);
  }

  String _getRequestTitle(BuildContext context) {
    if (widget.item.recordType == 'hr.leave') {
      return widget.item.leaveTypeName?.toString() ?? context.localizations.requestType;
    } else {
      return widget.item.reqRequestTypeDisplay?.toString() ??
          widget.item.reqRequestType?.toString() ??
          context.localizations.requestType;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '--';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy', 'en').format(date);
    } on Exception catch (_) {
      return dateStr;
    }
  }
}
