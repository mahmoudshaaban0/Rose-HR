import 'package:flutter/material.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/features/account/presentation/widgets/account_menu_item.dart';
import 'package:rose_hr/features/general_settings/presentation/widgets/language_selection_bottom_sheet.dart';
import 'package:rose_hr/theme/theme_ext.dart';

/// Settings row that opens the language picker bottom sheet.
class GeneralSettingsLanguageTile extends StatelessWidget {
  const GeneralSettingsLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCode = Localizations.localeOf(context).languageCode;
    final subtitle = currentCode == AppStrings.english
        ? context.localizations.englishLanguageName
        : context.localizations.arabicLanguageName;

    return AccountMenuItem(
      iconPath: Assets.vectorsLanguageIcon,
      title: context.localizations.language,
      subtitle: subtitle,
      onTap: () => LanguageSelectionBottomSheet.show(context),
    );
  }
}
