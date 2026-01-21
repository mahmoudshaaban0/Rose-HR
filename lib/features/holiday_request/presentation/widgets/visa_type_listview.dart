import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/holiday_request/data/models/visa_type_model.dart';
import 'package:rose_hr/features/holiday_request/presentation/bloc/holiday_request_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class VisaTypeListView extends StatefulWidget {
  const VisaTypeListView({super.key});

  @override
  State<VisaTypeListView> createState() => _VisaTypeListViewState();
}

class _VisaTypeListViewState extends State<VisaTypeListView> {
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
              Text('نوع التأشيرة', style: context.typography.semiBold16),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const AppDivider(),
                  itemCount: visaTypes.length,
                  itemBuilder: (context, index) {
                    final visaType = visaTypes[index];
                    final isSelected = state.visaTypeId == visaType.id;

                    return InkWell(
                      onTap: () {
                        context.read<HolidayRequestCubit>().selectVisaType(
                          visaType.name,
                          visaType.id,
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
                              visaType.name,
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
