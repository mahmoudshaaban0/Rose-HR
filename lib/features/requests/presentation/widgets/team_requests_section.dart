import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/requests/data/models/team_requests_response_model.dart';
import 'package:rose_hr/features/requests/presentation/cubit/team_requests_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class TeamRequestsSection extends StatelessWidget {
  const TeamRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TeamRequestsCubit>()..getTeamRequests(),
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.localizations.teamRequests,
                  style: context.typography.semiBold16,
                ),
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: context.colors.onSurfaceVariant,
                  size: 22.r,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),
            const AppDivider(),
            SizedBox(height: AppSpacing.sm.h),
            BlocConsumer<TeamRequestsCubit, TeamRequestsState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status &&
                  (current.status == TeamRequestsStatus.actionSuccess || current.status == TeamRequestsStatus.actionError),
              listener: (context, state) {
                if (state.status == TeamRequestsStatus.actionSuccess) {
                  SnackbarService.showSuccess(
                    context,
                    state.actionMessage ?? context.localizations.done,
                  );
                } else if (state.status == TeamRequestsStatus.actionError) {
                  SnackbarService.showError(
                    context,
                    state.errorMessage ?? context.localizations.somethingWentWrong,
                  );
                }
              },
              builder: (context, state) {
                if (state.status == TeamRequestsStatus.loading && state.teamRequestsResponseModel == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }

                if (state.status == TeamRequestsStatus.error && state.teamRequestsResponseModel == null) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          state.errorMessage ?? context.localizations.somethingWentWrong,
                          style: context.typography.medium14,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () => context.read<TeamRequestsCubit>().getTeamRequests(),
                          child: Text(context.localizations.tryAgainAfter),
                        ),
                      ],
                    ),
                  );
                }

                final requests = state.teamRequestsResponseModel?.result?.data ?? [];
                if (requests.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
                    child: Text(
                      context.localizations.noTeamRequestsYet,
                      style: context.typography.regular14.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final displayRequests = requests.take(3).toList();
                return Column(
                  children: [
                    ...displayRequests.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Column(
                        children: [
                          _TeamRequestListItem(
                            item: item,
                            isActionLoading: state.status == TeamRequestsStatus.actionLoading && state.activeRequestId == item.id,
                            onApprove: () => context.read<TeamRequestsCubit>().approveRequest(item.id),
                            onReject: () => context.read<TeamRequestsCubit>().rejectRequest(item.id),
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
                    GestureDetector(
                      onTap: () => context.read<TeamRequestsCubit>().getTeamRequests(),
                      child: Text(
                        context.localizations.viewAllRequests,
                        style: context.typography.medium16.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamRequestListItem extends StatelessWidget {
  const _TeamRequestListItem({
    required this.item,
    required this.isActionLoading,
    required this.onApprove,
    required this.onReject,
  });

  final TeamRequestItem item;
  final bool isActionLoading;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final requestTitle = item.requestTypeDisplay ?? item.requestType ?? context.localizations.requestType;
    final employeeName = item.employeeName ?? item.name ?? '--';
    final roleText = _buildRoleText(item);
    final date = _formatDate(item.date ?? item.createDate);

    return Row(
      children: [
        if (isActionLoading)
          SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
              strokeWidth: 2.r,
              color: context.colors.onSurfaceVariant,
            ),
          )
        else
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              size: 20.r,
              color: context.colors.onSurfaceVariant,
            ),
            onSelected: (value) {
              if (value == 'approve') {
                onApprove();
              } else if (value == 'reject') {
                onReject();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'approve',
                child: Text(context.localizations.approveRequest),
              ),
              PopupMenuItem(
                value: 'reject',
                child: Text(context.localizations.rejectRequest),
              ),
            ],
          ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requestTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.semiBold16,
              ),
              SizedBox(height: AppSpacing.xxs.h),
              Text(
                date,
                style: context.typography.regular14.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.md.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                employeeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.semiBold18,
              ),
              SizedBox(height: AppSpacing.xxs.h),
              Text(
                roleText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.regular14.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    try {
      return DateFormat('dd/MM/yyyy', 'en').format(date);
    } on Exception catch (_) {
      return date.toString();
    }
  }

  String _buildRoleText(TeamRequestItem item) {
    final role = item.employeeJobTitle ?? item.jobTitle ?? '';
    if (role.isEmpty) return '${item.employeeNumber ?? ''}'.trim();

    final number = item.employeeNumber?.toString();
    if (number == null || number.isEmpty) return role;
    return '$role - $number';
  }
}
