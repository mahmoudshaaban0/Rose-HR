import 'package:flutter/material.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: context.colors.dividerColor,
    );
  }
}
