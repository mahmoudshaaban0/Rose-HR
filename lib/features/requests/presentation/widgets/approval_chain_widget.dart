import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_colors.dart';
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
  rejected;

  /// Maps the raw status string coming from the backend (English only:
  /// "Pending", "Approved", "Rejected") to an [ApprovalStatus].
  /// An empty/unknown value is treated as [ApprovalStatus.pending].
  static ApprovalStatus fromApi(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'approved':
        return ApprovalStatus.approved;
      case 'rejected':
        return ApprovalStatus.rejected;
      case 'pending':
      case '':
      case null:
      default:
        return ApprovalStatus.pending;
    }
  }
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

    // Only the first still-pending step is "active"; any pending step after it
    // hasn't been reached yet, so it is rendered as disabled.
    final firstPendingIndex = employees.indexWhere(
      (e) => e.status == ApprovalStatus.pending,
    );
    // Once a step is rejected, the chain stops, so every step after the first
    // rejection is rendered as disabled too.
    final firstRejectedIndex = employees.indexWhere(
      (e) => e.status == ApprovalStatus.rejected,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(employees.length, (index) {
        final employee = employees[index];
        final isLast = index == employees.length - 1;
        final isPendingNotReached =
            employee.status == ApprovalStatus.pending &&
            firstPendingIndex != -1 &&
            index != firstPendingIndex;
        final isAfterRejection =
            firstRejectedIndex != -1 && index > firstRejectedIndex;
        final isDisabled = isPendingNotReached || isAfterRejection;

        return _ApprovalEmployeeItem(
          employee: employee,
          showConnector: !isLast,
          isDisabled: isDisabled,
        );
      }),
    );
  }
}

/// Resolved colors for a status badge.
typedef _BadgeColors = ({Color background, Color border, Color text});

class _ApprovalEmployeeItem extends StatelessWidget {
  const _ApprovalEmployeeItem({
    required this.employee,
    required this.showConnector,
    required this.isDisabled,
  });

  final ApprovalEmployee employee;
  final bool showConnector;
  final bool isDisabled;

  _BadgeColors _badgeColors(BuildContext context) {
    final colors = context.colors;
    switch (employee.status) {
      case ApprovalStatus.approved:
        return (
          background: colors.successContainer,
          border: colors.success,
          text: colors.successDark,
        );
      case ApprovalStatus.rejected:
        return (
          background: colors.errorContainer,
          border: colors.error,
          text: colors.errorDark,
        );
      case ApprovalStatus.pending:
        return (
          background: colors.statusPendingBackground,
          border: colors.statusPendingBorder,
          text: colors.statusPendingText,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColors = _badgeColors(context);

    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Row(
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
            padding: EdgeInsets.only(top: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  employee.name,
                  style: context.typography.medium14.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: getColorsNameByStatus(
                      employee.status,
                      context.colors,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                    border: Border.all(color: badgeColors.border),
                  ),
                  child: Text(
                    _getStatusText(context, employee.status),
                    style: context.typography.medium12.copyWith(
                      color: badgeColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BuildContext context, ApprovalStatus status) {
    switch (status) {
      case ApprovalStatus.approved:
        return context.localizations.approvalStatusApproved;
      case ApprovalStatus.rejected:
        return context.localizations.approvalStatusRejected;
      case ApprovalStatus.pending:
        return context.localizations.approvalStatusPending;
    }
  }

  Color? getColorsNameByStatus(ApprovalStatus status, AppColors colors) {
    switch (status) {
      case ApprovalStatus.approved:
        return colors.successContainer;
      case ApprovalStatus.rejected:
        return colors.error;
      case ApprovalStatus.pending:
        return colors.statusPendingBackground;
    }
  }
}
