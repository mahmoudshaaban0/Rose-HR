import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:rose_hr/features/requests/presentation/widgets/current_request_item.dart';
import 'package:rose_hr/features/requests/presentation/widgets/no_requests_widget.dart';
import 'package:rose_hr/features/requests/presentation/widgets/request_item_shimmer.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class CompletedRequests extends StatelessWidget {
  const CompletedRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
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
              title: context.localizations.noCompletedRequestsUntilNow,
              onRefresh: () => context.read<RequestsCubit>().getEmployeeList(),
            );
          }

          // Filter for completed requests (done, refused, or cancelled)
          final completedRequests = data.where((request) {
            return request.state == 'done' ||
                request.state == 'refuse' ||
                request.state == 'cancelled' ||
                request.state == 'rejected' ||
                request.state == 'cancel' ||
                request.state == 'refuse' ||
                request.state == 'validate' ||
                request.state == 'approved';
          }).toList();

          if (completedRequests.isEmpty) {
            return NoRequestsWidget(
              title: context.localizations.noCompletedRequestsUntilNow,
              onRefresh: () => context.read<RequestsCubit>().getEmployeeList(),
            );
          }

          return RefreshIndicator.adaptive(
            color: context.colors.onSurface,
            onRefresh: () async {
              await context.read<RequestsCubit>().getEmployeeList();
            },
            child: ListView.builder(
              itemCount: completedRequests.length,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              itemBuilder: (context, index) {
                final request = completedRequests[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                  child: CurrentRequestItem(
                    onViewRequest: () {
                      context.pushNamed(
                        AppRoutes.singleRequest.name,
                        extra: {
                          'request': request,
                          'cubit': context.read<RequestsCubit>(),
                        },
                      );
                    },
                    requestType: switch (request.recordType) {
                      'hr.request' => request.reqRequestTypeDisplay ?? '',
                      'hr.end.of.service' => context.localizations.endOfServiceRequest,
                      _ => request.leaveTypeName ?? '',
                    },
                    requestDate: switch (request.recordType) {
                      'hr.request' => _formatDate(request.reqDate),
                      'hr.end.of.service' => _formatDate(request.clrLastWorkingDay),
                      _ => '${request.leaveDateFrom} - ${request.leaveDateTo}',
                    },
                    requestNumber: request.name?.toString() ?? '',
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


  String _formatDate(String? date) {
    return date ?? '';
  }

  Color _getStatusColor(BuildContext context, String? state) {
    switch (state) {
      case 'approve':
      case 'done':
        return context.colors.success;
      case 'refuse':
        return context.colors.error;
      case 'cancel':
        return context.colors.onSurfaceVariant; // Grey color for cancelled
      case 'draft':
      case 'confirm':
      default:
        return context.colors.warning;
    }
  }
}
