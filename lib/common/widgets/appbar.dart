import 'package:flutter/material.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    required this.title,
    this.actions,
    super.key,
  });

  final String title;

  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: context.typography.semiBold16),
      centerTitle: true,
      backgroundColor: context.colors.surface,
      titleSpacing: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
