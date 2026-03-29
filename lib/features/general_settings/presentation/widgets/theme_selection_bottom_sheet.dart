import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/app_theme_scope.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

/// Bottom sheet: choose light, dark, or system theme.
class ThemeSelectionBottomSheet extends StatelessWidget {
  const ThemeSelectionBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return BottomSheetWrapper(
      initialSize: 0.25.h,
      maxChildSize: 0.42.h,
      removeAutoScroll: true,
      disableDrag: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
        child: const ThemeSelectionBottomSheet(),
      ),
    ).callSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final current = AppThemeScope.of(context)!.themeMode;
    final themeScope = ThemeScopeWidget.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.localizations.selectTheme,
          style: context.typography.semiBold18,
        ),
        _ThemeOptionRow(
          label: context.localizations.themeLight,
          isSelected: current == ThemeMode.light,
          onTap: () async {
            await themeScope?.changeTo(ThemeMode.light);
            if (context.mounted) context.pop();
          },
        ),
        const AppDivider(),
        _ThemeOptionRow(
          label: context.localizations.themeDark,
          isSelected: current == ThemeMode.dark,
          onTap: () async {
            await themeScope?.changeTo(ThemeMode.dark);
            if (context.mounted) context.pop();
          },
        ),
        const AppDivider(),
        _ThemeOptionRow(
          label: context.localizations.themeSystem,
          isSelected: current == ThemeMode.system,
          onTap: () async {
            await themeScope?.changeTo(ThemeMode.system);
            if (context.mounted) context.pop();
          },
        ),
      ],
    );
  }
}

class _ThemeOptionRow extends StatelessWidget {
  const _ThemeOptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.lg.h,
          horizontal: AppSpacing.lg.r,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: context.typography.medium16.copyWith(
                color: isSelected ? context.colors.success : null,
              ),
            ),
            if (isSelected) const AppVectorGraphic(path: Assets.vectorsCheckline),
          ],
        ),
      ),
    );
  }
}
