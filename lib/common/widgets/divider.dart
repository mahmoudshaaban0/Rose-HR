import 'package:flutter/material.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: color ?? context.colors.dividerColor,
    );
  }
}
