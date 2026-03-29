import 'package:flutter/material.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/features/general_settings/presentation/widgets/general_settings_language_tile.dart';
import 'package:rose_hr/features/general_settings/presentation/widgets/general_settings_notifications_tile.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.containerBackground,
      appBar: PrimaryAppBar(title: context.localizations.generalSettings),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GeneralSettingsLanguageTile(),
            // GeneralSettingsThemeTile(),
            GeneralSettingsNotificationsTile(),
          ],
        ),
      ),
    );
  }
}
