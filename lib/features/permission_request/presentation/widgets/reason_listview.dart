import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/permission_request/data/models/reason_type_model.dart';
import 'package:rose_hr/features/permission_request/presentation/cubit/permission_request_cubit.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class ReasonListView extends StatefulWidget {
  const ReasonListView({required this.onSelected, super.key});
  final void Function(String) onSelected;
  @override
  State<ReasonListView> createState() => _ReasonListViewState();
}

class _ReasonListViewState extends State<ReasonListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PermissionRequestCubit, PermissionRequestState>(
        builder: (context, state) {
          return ListView.separated(
            separatorBuilder: (context, index) => const AppDivider(),
            itemCount: reasonTypes.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context.read<PermissionRequestCubit>().selecteReasonType(
                    reasonTypes[index].name,
                    reasonTypes[index].id,
                  );
                  context.pop();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg.h, horizontal: AppSpacing.lg.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reasonTypes[index].name,
                        style: state.reasonTypeId == reasonTypes[index].id
                            ? context.typography.medium16
                            : context.typography.regular16,
                      ),
                      if (state.reasonTypeId == reasonTypes[index].id) const AppVectorGraphic(path: Assets.vectorsCheckline),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
