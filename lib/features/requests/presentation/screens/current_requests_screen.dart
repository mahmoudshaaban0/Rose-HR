import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:rose_hr/features/requests/presentation/widgets/current_request_item.dart';
import 'package:rose_hr/features/requests/presentation/widgets/no_requests_widget.dart';
import 'package:rose_hr/features/requests/presentation/widgets/request_item_shimmer.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CurrentRequests extends StatelessWidget {
  const CurrentRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      buildWhen: (previous, current) =>
          previous.status != current.status &&
          (current.status == RequestsStatus.success ||
              current.status == RequestsStatus.error ||
              current.status == RequestsStatus.loading),
      builder: (context, state) {
        if (state.status == RequestsStatus.loading) {
          return ListView.builder(
            itemCount: 5,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: AppSpacing.sm.h,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                child: const RequestItemShimmer(),
              );
            },
          );
        }

        if (state.status == RequestsStatus.error) {
          return Center(
            child: Text(
              state.errorMessage ?? context.localizations.somethingWentWrong,
              style: context.typography.medium16,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state.status == RequestsStatus.success) {
          final data = state.employeeListResponseModel?.result?.data;

          if (data == null || data.isEmpty) {
            return NoRequestsWidget(
              title: context.localizations.noCurrentRequestsUntilNow,
            );
          }

          // Filter for current requests (not completed/rejected/cancelled)
          final currentRequests = data.where((request) {
            return request.state != 'done' && request.state != 'refuse' && request.state != 'cancelled';
          }).toList();

          if (currentRequests.isEmpty) {
            return NoRequestsWidget(
              title: context.localizations.noCurrentRequestsUntilNow,
            );
          }

          return RefreshIndicator.adaptive(
            color: context.colors.onSurface,
            onRefresh: () async {
              await context.read<RequestsCubit>().getEmployeeList();
            },
            child: ListView.builder(
              itemCount: currentRequests.length,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              itemBuilder: (context, index) {
                final request = currentRequests[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                  child: CurrentRequestItem(
                    onViewRequest: () {
                      if (request.id != null) {
                        context.pushNamed(
                          AppRoutes.singleRequest.name,
                          extra: {
                            'request': request,
                            'cubit': context.read<RequestsCubit>(),
                          },
                        );
                      }
                    },
                    onCancelRequest: () {
                      context.read<RequestsCubit>().cancelRequest(request.id);
                    },
                    requestType: _getLocalizedRequestType(context, request.requestType),
                    requestDate: _formatDate(request.date),
                    requestNumber: request.name ?? '',
                    requestStatus: request.stateDisplay ?? request.state ?? '',
                    requestColor: _getStatusColor(context, request.state),
                    requestResponse: '', // Add this if you have response data
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
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

  Color _getStatusColor(BuildContext context, String? state) {
    switch (state) {
      case 'approve':
        return context.colors.success;
      case 'refuse':
        return context.colors.error;
      case 'draft':
      case 'confirm':
      default:
        return context.colors.warning;
    }
  }
}
