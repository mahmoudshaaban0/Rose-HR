import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/widgets/bottom_sheet_wrapper.dart';
import 'package:rose_hr/common/widgets/divider.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/general_settings/presentation/widgets/language_change_transition.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

/// Bottom sheet content: pick العربية or English and apply app locale.
class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return BottomSheetWrapper(
      initialSize: 0.25.h,
      maxChildSize: 0.32.h,
      removeAutoScroll: true,
      disableDrag: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.r),
        child: const LanguageSelectionBottomSheet(),
      ),
    ).callSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentCode = Localizations.localeOf(context).languageCode;
    final themeScope = ThemeScopeWidget.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.localizations.selectLanguage,
          style: context.typography.semiBold18,
        ),
        _LanguageOptionRow(
          label: context.localizations.arabicLanguageName,
          isSelected: currentCode == AppStrings.arabic,
          onTap: () async => _onLanguageSelected(
            context,
            themeScope,
            targetCode: AppStrings.arabic,
            currentCode: currentCode,
          ),
        ),
        const AppDivider(),
        _LanguageOptionRow(
          label: context.localizations.englishLanguageName,
          isSelected: currentCode == AppStrings.english,
          onTap: () async => _onLanguageSelected(
            context,
            themeScope,
            targetCode: AppStrings.english,
            currentCode: currentCode,
          ),
        ),
      ],
    );
  }

  /// Closes the sheet; if the language actually changes, restarts the app flow via splash.
  static Future<void> _onLanguageSelected(
    BuildContext context,
    ThemeScopeWidgetState? themeScope, {
    required String targetCode,
    required String currentCode,
  }) async {
    if (targetCode == currentCode) {
      if (context.mounted) {
        context.pop();
      }
      return;
    }

    final router = GoRouter.of(context);
    await themeScope?.changeLocale(Locale(targetCode));

    if (context.mounted) {
      context.pop();
    }

    // Let the bottom sheet dismiss before showing the overlay.
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await LanguageChangeTransition.showThenNavigateToSplash(router);
  }
}

class _LanguageOptionRow extends StatelessWidget {
  const _LanguageOptionRow({
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
