import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/snackbar_service.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/requests/data/models/pending_manager_requests_response_model.dart';
import 'package:rose_hr/features/requests/presentation/cubit/pending_manager_requests_cubit.dart';
import 'package:rose_hr/theme/app_sizes.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/outline_button_theme.dart';
import 'package:rose_hr/theme/primary_text_button.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AllPendingManagerRequestsScreen extends StatelessWidget {
  const AllPendingManagerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PendingRequestsCubit>()..getPendingManagerRequests(),
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: context.localizations.teamRequests,
        ),
        body: BlocConsumer<PendingRequestsCubit, PendingRequestsState>(
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
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (state.status == PendingRequestsStatus.error && state.pendingRequestsResponseModel == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? context.localizations.somethingWentWrong,
                      style: context.typography.medium14,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    TextButton(
                      onPressed: () => context.read<PendingRequestsCubit>().getPendingManagerRequests(),
                      child: Text(context.localizations.tryAgainAfter),
                    ),
                  ],
                ),
              );
            }

            final requests = state.pendingRequestsResponseModel?.result?.data?.requests ?? [];
            if (requests.isEmpty) {
              return Center(
                child: Text(
                  context.localizations.noTeamRequestsYet,
                  style: context.typography.regular14.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              );
            }

            return RefreshIndicator.adaptive(
              onRefresh: () => context.read<PendingRequestsCubit>().getPendingManagerRequests(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md.w,
                  vertical: AppSpacing.sm.h,
                ),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final item = requests[index];
                  final isActionLoading = state.status == PendingRequestsStatus.actionLoading && state.activeRequestId == item.id;

                  final requestType = _getRequestType(context, item);
                  final requestDate = _getRequestDate(item);

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                    child: InkWell(
                      onTap: () => context.pushNamed(
                        AppRoutes.singleTeamRequest.name,
                        extra: {
                          'item': item,
                          'cubit': context.read<PendingRequestsCubit>(),
                        },
                      ),
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        decoration: BoxDecoration(
                          color: context.colors.containerBackground,
                          borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Employee Name
                            Row(
                              children: [
                                const AppVectorGraphic(path: Assets.vectorsPersonalInformationIcon),
                                SizedBox(width: AppSpacing.md.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.employeeName ?? '--',
                                        style: context.typography.semiBold18,
                                      ),
                                      if (item.stateDisplay != null) ...[
                                        SizedBox(height: AppSpacing.xxs.h),
                                        Text(
                                          item.stateDisplay!,
                                          style: context.typography.regular14.copyWith(
                                            color: context.colors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            const AppDivider(),
                            SizedBox(height: AppSpacing.md.h),
                            // Request Number
                            _buildLineItem(
                              context: context,
                              icon: Assets.vectorsHashtag,
                              title: context.localizations.requestNumber,
                              trailingTitle: item.name ?? '--',
                              trailingTitleColor: context.colors.onSurface,
                            ),
                            SizedBox(height: AppSpacing.sm.h),

                            // Create Date
                            _buildLineItem(
                              context: context,
                              icon: Assets.vectorsTime,
                              title: context.localizations.dateCreated,
                              trailingTitle: _formatDateTime(item.createDate),
                              trailingTitleColor: context.colors.onSurfaceVariant,
                            ),
                            SizedBox(height: AppSpacing.md.h),
                            // Request Type
                            _buildLineItem(
                              context: context,
                              icon: Assets.vectorsRequestsActive,
                              title: context.localizations.requestType,
                              trailingTitle: requestType,
                              trailingTitleColor: context.colors.onSurface,
                            ),

                            SizedBox(height: AppSpacing.sm.h),

                            // Request Date
                            _buildLineItem(
                              context: context,
                              icon: Assets.vectorsCalendarFill,
                              title: context.localizations.date,
                              trailingTitle: requestDate,
                              trailingTitleColor: context.colors.onSurface,
                            ),
                            SizedBox(height: AppSpacing.sm.h),

                            const AppDivider(),
                            SizedBox(height: AppSpacing.md.h),

                            // Action Buttons
                            GestureDetector(
                              onTap: () {},
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlineTextButton(
                                      label: isActionLoading ? '' : context.localizations.rejectRequest,
                                      size: AppButtonSize.xxLarge,
                                      overriddenBorderColor: context.colors.onSurface,
                                      overriddenBackgroundColor: context.isDarkMode
                                          ? context.colors.surface
                                          : context.colors.white,
                                      leading: isActionLoading
                                          ? (iconColor) => SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.r,
                                                color: iconColor,
                                              ),
                                            )
                                          : null,
                                      onTap: isActionLoading
                                          ? null
                                          : () {
                                              context.read<PendingRequestsCubit>().rejectRequest(
                                                recordType: item.recordType ?? 'hr.request',
                                                requestId: item.id ?? 0,
                                              );
                                            },
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.md.w),
                                  Expanded(
                                    child: PrimaryTextButton(
                                      overriddenBackgroundColor: context.colors.onSurface,
                                      label: isActionLoading ? '' : context.localizations.approveRequest,
                                      leading: isActionLoading
                                          ? (iconColor) => SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.r,
                                                color: iconColor,
                                              ),
                                            )
                                          : null,
                                      onTap: isActionLoading
                                          ? null
                                          : () {
                                              context.read<PendingRequestsCubit>().approveRequest(
                                                recordType: item.recordType ?? 'hr.request',
                                                requestId: item.id ?? 0,
                                                approvalType: item.pendingOn ?? 'manager',
                                              );
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLineItem({
    required BuildContext context,
    required String icon,
    required String title,
    required String trailingTitle,
    required Color trailingTitleColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppVectorGraphic(path: icon),
        SizedBox(width: AppSpacing.md.w),
        Text(
          title,
          style: context.typography.medium14,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Text(
          trailingTitle,
          style: context.typography.medium14.copyWith(
            color: trailingTitleColor,
          ),
          textAlign: TextAlign.end,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getRequestType(BuildContext context, PendingRequestItem item) {
    // Fields like req_* can be `false` (as per API) meaning "not applicable".
    final recordType = _stringOrEmpty(item.recordType);
    if (recordType == 'hr.leave') {
      final leaveType = _stringOrEmpty(item.leaveTypeName);
      return leaveType.isEmpty ? context.localizations.requestType : leaveType;
    }

    final display = _stringOrEmpty(item.reqRequestTypeDisplay);
    if (display.isNotEmpty) return display;

    final fallback = _stringOrEmpty(item.reqRequestType);
    return fallback.isNotEmpty ? fallback : context.localizations.requestType;
  }

  String _getRequestDate(PendingRequestItem item) {
    final recordType = _stringOrEmpty(item.recordType);
    if (recordType == 'hr.leave') {
      return _formatLeaveDateRange(item.leaveDateFrom, item.leaveDateTo);
    }
    return _formatDate(item.reqDate);
  }

  String _formatLeaveDateRange(dynamic from, dynamic to) {
    final fromStr = _formatDate(from);
    final toStr = _formatDate(to);

    final hasFrom = fromStr != '--';
    final hasTo = toStr != '--';

    if (hasFrom && hasTo) return '$fromStr - $toStr';
    if (hasFrom) return fromStr;
    if (hasTo) return toStr;
    return '--';
  }

  String _formatDate(dynamic date) {
    if (date == null) return '--';
    if (date is bool) return date ? '--' : '--';
    if (date is String) {
      if (date.isEmpty || date == 'false') return '--';
      try {
        final parsedDate = DateTime.parse(date);
        return DateFormat('dd/MM/yyyy', 'en').format(parsedDate);
      } on FormatException {
        return date;
      } on Exception {
        return date;
      }
    }

    return date.toString();
  }

  String _stringOrEmpty(dynamic value) {
    if (value == null) return '';
    if (value is bool) return value ? value.toString() : '';
    final str = value.toString();
    if (str.isEmpty || str == 'false') return '';
    return str;
  }

  String _formatDateTime(dynamic dateStr) {
    if (dateStr == null) return '--';
    if (dateStr is bool) return '--';
    final s = dateStr.toString();
    if (s.isEmpty || s == 'false') return '--';
    final parsed = _tryParseDateTime(s);
    if (parsed != null) {
      return DateFormat('dd/MM/yyyy', 'en').format(parsed);
    }

    // Fallback: try extracting YYYY-MM-DD or dd/MM/yyyy from the raw string.
    final isoDateMatch = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(s);
    if (isoDateMatch != null) {
      final iso = isoDateMatch.group(1);
      if (iso != null) {
        final normalized = iso.replaceFirst(' ', 'T');
        final parsedIso = DateTime.tryParse(normalized);
        if (parsedIso != null) return DateFormat('dd/MM/yyyy', 'en').format(parsedIso);
      }
    }

    final slashDateMatch = RegExp(r'(\d{2}/\d{2}/\d{4})').firstMatch(s);
    if (slashDateMatch != null) return slashDateMatch.group(1) ?? '--';

    return '--';
  }

  DateTime? _tryParseDateTime(String s) {
    // API often returns: "2026-03-14 19:28:38" (space instead of 'T').
    final normalized = s.contains(' ') ? s.replaceFirst(' ', 'T') : s;
    return DateTime.tryParse(normalized);
  }

  // NOTE: _formatDate/_formatDateTime handle API "false means not applicable".
}
