import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class RequestDetailRow extends StatelessWidget {
  const RequestDetailRow({
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingWidget,
    this.trailingTextColor,
    super.key,
  });

  final String icon;
  final String title;
  final String? trailingText;
  final Widget? trailingWidget;
  final Color? trailingTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.md.w,
      children: [
        AppVectorGraphic(path: icon),
        Text(title, style: context.typography.medium14),
        const Spacer(),
        if (trailingText != null)
          Text(
            trailingText!,
            style: context.typography.medium14.copyWith(
              color: trailingTextColor ?? context.colors.onSurface,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        if (trailingWidget != null) trailingWidget!,
      ],
    );
  }
}
