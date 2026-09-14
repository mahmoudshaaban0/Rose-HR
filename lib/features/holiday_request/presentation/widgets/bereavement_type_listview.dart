import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/holiday_request/data/models/bereavement_type_model.dart';
import 'package:rose_hr/features/holiday_request/presentation/bloc/holiday_request_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class BereavementTypeListView extends StatefulWidget {
  const BereavementTypeListView({super.key});

  @override
  State<BereavementTypeListView> createState() => _BereavementTypeListViewState();
}

class _BereavementTypeListViewState extends State<BereavementTypeListView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HolidayRequestCubit, HolidayRequestState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
          child: Column(
            spacing: AppSpacing.md.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.localizations.bereavementType, style: context.typography.semiBold16),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemCount: bereavementTypes.length,
                  itemBuilder: (context, index) {
                    final bereavementType = bereavementTypes[index];
                    final isSelected = state.bereavementTypeId == bereavementType.id;

                    return InkWell(
                      onTap: () {
                        context.read<HolidayRequestCubit>().selectBereavementType(
                          bereavementType.label(context.localizations),
                          bereavementType.id,
                        );
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
                              bereavementType.label(context.localizations),
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
