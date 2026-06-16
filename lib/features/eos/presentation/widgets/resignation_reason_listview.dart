import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/eos/presentation/cubit/eos_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class ResignationReasonListView extends StatelessWidget {
  const ResignationReasonListView({super.key});

  String _label(BuildContext context, ResignationReason reason) {
    return switch (reason) {
      ResignationReason.resignation => context.localizations.resignationReasonResignation,
      ResignationReason.termination => context.localizations.resignationReasonTermination,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EosCubit, EosState>(
      builder: (context, state) {
        // Saudi employees may only resign; everyone else may also be terminated.
        final reasons = state.isSaudi
            ? const [ResignationReason.resignation]
            : ResignationReason.values;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
          child: Column(
            spacing: AppSpacing.md.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.localizations.resignationReason, style: context.typography.semiBold16),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemCount: reasons.length,
                  itemBuilder: (context, index) {
                    final reason = reasons[index];
                    final isSelected = state.resignationReason == reason;

                    return InkWell(
                      onTap: () {
                        context.read<EosCubit>().selectResignationReason(reason);
                        context.pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSpacing.lg.h,
                          horizontal: AppSpacing.lg.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _label(context, reason),
                              style: isSelected ? context.typography.medium16 : context.typography.regular16,
                            ),
                            if (isSelected) const AppVectorGraphic(path: Assets.vectorsCheckline),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
