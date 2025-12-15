import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class RowItem extends StatelessWidget {
  const RowItem({required this.title, required this.value, this.hasDivider = true, super.key});
  final String title;
  final String value;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.md.h,
      children: [
        Row(
          children: [
            Text(title, style: context.typography.regular16),
            const Spacer(),
            Text(value, style: context.typography.medium16),
          ],
        ),
        if (hasDivider) const AppDivider(),
      ],
    );
  }
}
