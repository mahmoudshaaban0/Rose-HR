import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AppRadioButton<T> extends StatelessWidget {
  const AppRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.labelStyle,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String label;
  final TextStyle? labelStyle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(value),
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 1.4,
            child: RadioGroup<T>(
              onChanged: (value) => onChanged?.call(value),
              groupValue: groupValue,
              child: CupertinoRadio<T>(
                value: value,
                inactiveColor: context.colors.outlineVariant,
                activeColor: context.colors.info,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.xxl.w),
          Text(
            label,
            style:
                labelStyle ??
                context.typography.semiBold16.copyWith(
                  color: context.colors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
