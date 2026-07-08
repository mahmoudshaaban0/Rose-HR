import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/features/home/presentation/cubit/home_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class HolidaysSection extends StatelessWidget {
  const HolidaysSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        spacing: AppSpacing.md.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.localizations.accuredLeaveBalance,
            style: context.typography.semiBold16,
          ),
          const AppDivider(),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final balances = state.leaveBalances;
              if (state.homeStatus == HomeDataStatus.loading &&
                  balances.isEmpty) {
                return SizedBox(
                  height: 100.h,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (balances.isEmpty) {
                return _LeaveBalanceCard(
                  balance: ' 0 ',
                  label: context.localizations.accuredLeaveBalance,
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final balance in balances)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                      child: _LeaveBalanceCard(
                        balance: ' ${_formatBalance(balance.balance)} ',
                        label:
                            balance.label ??
                            context.localizations.accuredLeaveBalance,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatBalance(double? value) {
    final balance = value ?? 0;
    if (balance == balance.roundToDouble()) {
      return balance.toInt().toString();
    }
    return balance.toString();
  }
}

class _LeaveBalanceCard extends StatelessWidget {
  const _LeaveBalanceCard({
    required this.balance,
    required this.label,
  });

  final String balance;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.r,
        vertical: AppSpacing.xl.r,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.typography.regular14,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Text(
            balance,
            style: context.typography.semiBold16,
          ),
        ],
      ),
    );
  }
}
