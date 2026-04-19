import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class ApprovalEmployee {
  const ApprovalEmployee({
    required this.name,
    required this.status,
  });

  final String name;
  final ApprovalStatus status;
}

enum ApprovalStatus {
  approved,
  pending,
  rejected,
}

class ApprovalChainWidget extends StatelessWidget {
  const ApprovalChainWidget({
    required this.employees,
    super.key,
  });

  final List<ApprovalEmployee> employees;

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(employees.length, (index) {
        final employee = employees[index];
        final isLast = index == employees.length - 1;

        return _ApprovalEmployeeItem(
          employee: employee,
          showConnector: !isLast,
        );
      }),
    );
  }
}

class _ApprovalEmployeeItem extends StatelessWidget {
  const _ApprovalEmployeeItem({
    required this.employee,
    required this.showConnector,
  });

  final ApprovalEmployee employee;
  final bool showConnector;

  // Color _getStatusColor(BuildContext context, ApprovalStatus status) {
  //   switch (status) {
  //     case ApprovalStatus.approved:
  //       return context.colors.success;
  //     case ApprovalStatus.rejected:
  //       return context.colors.error;
  //     case ApprovalStatus.pending:
  //       return context.colors.statusPendingText;
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status icon column with connector
        Column(
          children: [
            const AppVectorGraphic(path: Assets.vectorsUserPlaceHolder),
            if (showConnector)
              Container(
                width: 2,
                height: 32.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: context.colors.containerBorder,
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
          ],
        ),
        SizedBox(width: AppSpacing.md.w),
        // Employee info
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                employee.name,
                style: context.typography.medium14.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              // SizedBox(height: 2.h),
              // Text(
              //   _getStatusText(context, employee.status),
              //   style: context.typography.regular12.copyWith(
              //     color: statusColor,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  // String _getStatusText(BuildContext context, ApprovalStatus status) {
  //   switch (status) {
  //     case ApprovalStatus.approved:
  //       return context.localizations.done;
  //     case ApprovalStatus.rejected:
  //       return context.localizations.cancel;
  //     case ApprovalStatus.pending:
  //       return context.localizations.requestStatus;
  //   }
  // }
}
