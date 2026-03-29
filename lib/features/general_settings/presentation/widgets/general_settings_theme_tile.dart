import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/features/account/presentation/widgets/account_menu_item.dart';
import 'package:rose_hr/features/general_settings/presentation/widgets/theme_selection_bottom_sheet.dart';
import 'package:rose_hr/theme/app_theme_scope.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Settings row that opens the theme (appearance) picker bottom sheet.
class GeneralSettingsThemeTile extends StatelessWidget {
  const GeneralSettingsThemeTile({super.key});

  static String _subtitleForTheme(BuildContext context, ThemeMode mode) {
    final loc = context.localizations;
    return switch (mode) {
      ThemeMode.light => loc.themeLight,
      ThemeMode.dark => loc.themeDark,
      ThemeMode.system => loc.themeSystem,
    };
  }

  @override
  Widget build(BuildContext context) {
    final mode = AppThemeScope.of(context)!.themeMode;

    return AccountMenuItem(
      leading: Icon(
        Icons.brightness_6_outlined,
        size: 18.r,
        color: context.colors.iconOnSurface,
      ),
      title: context.localizations.themeAppearance,
      subtitle: _subtitleForTheme(context, mode),
      onTap: () => ThemeSelectionBottomSheet.show(context),
    );
  }
}
