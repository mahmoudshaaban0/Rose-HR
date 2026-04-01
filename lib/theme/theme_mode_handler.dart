import 'package:flutter/material.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/theme/app_theme.dart';
import 'package:rose_hr/theme/app_theme_scope.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeMode = 'themeMode';
const _kAppLocaleCode = 'app_locale_code';

/// {@template theme_scope_widget}
/// A class which handles all theme processes
///
/// initialize() method should be used as app starter in order to use
/// [AppTheme] in the app

/// {@endtemplate}
class ThemeScopeWidget extends StatefulWidget {
  /// {@macro theme_scope_widget}
  const ThemeScopeWidget({required this.child, required this.preferences, super.key});

  /// The child widget
  final Widget child;

  /// The shared preferences
  final SharedPreferences preferences;

  /// Initialize the [ThemeScopeWidget] with the given [child] widget
  static Future<ThemeScopeWidget> initialize(Widget child) async {
    final preferences = await SharedPreferences.getInstance();
    return ThemeScopeWidget(preferences: preferences, child: child);
  }

  /// In order to use methods of [ThemeScopeWidget] this function
  /// should be called first. Theme change process will handled by
  /// [ThemeScopeWidget] automatically.
  static ThemeScopeWidgetState? of(BuildContext context) {
    return context.findRootAncestorStateOfType<ThemeScopeWidgetState>();
  }

  @override
  State<ThemeScopeWidget> createState() => ThemeScopeWidgetState();
}

/// The state for [ThemeScopeWidget].
class ThemeScopeWidgetState extends State<ThemeScopeWidget> {
  ThemeMode? _themeMode;
  Locale _locale = const Locale(AppStrings.arabic);

  /// Currently selected app [Locale] (Arabic or English).
  Locale get locale => _locale;

  Locale _readLocaleFromPreferences() {
    final code = widget.preferences.getString(_kAppLocaleCode);
    if (code == AppStrings.english) {
      return const Locale(AppStrings.english);
    }
    if (code == AppStrings.arabic) {
      return const Locale(AppStrings.arabic);
    }
    // Migrate from API `lang` header storage if present
    final lang = widget.preferences.getString(AppStrings.lang);
    if (lang == 'en_US' || lang == AppStrings.english) {
      return const Locale(AppStrings.english);
    }
    return const Locale(AppStrings.arabic);
  }

  /// Persists and applies the app language (UI + API `lang` preference).
  Future<void> changeLocale(Locale locale) async {
    if (_locale == locale) return;

    final languageCode = locale.languageCode;
    if (languageCode != AppStrings.arabic && languageCode != AppStrings.english) {
      return;
    }

    try {
      final apiLang = languageCode == AppStrings.english ? 'en_US' : 'ar_001';
      await widget.preferences.setString(_kAppLocaleCode, languageCode);
      await widget.preferences.setString(AppStrings.lang, apiLang);

      setState(() {
        _locale = Locale(languageCode);
      });
    } on Exception catch (_) {}
  }

  /// Change the theme mode
  Future<void> changeTo(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    try {
      final index = ThemeMode.values.indexOf(themeMode);
      await widget.preferences.setInt(_kThemeMode, index);

      setState(() {
        _themeMode = themeMode;
      });
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    _locale = _readLocaleFromPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    try {
      final themeModeIndex = widget.preferences.getInt(_kThemeMode) ?? 1;
      final themeMode = ThemeMode.values[themeModeIndex];

      _themeMode = themeMode;
    } on Exception catch (_) {
      _themeMode = ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);

    final appTheme = switch (_themeMode!) {
      ThemeMode.light => AppTheme.light(),
      ThemeMode.dark => AppTheme.dark(),
      ThemeMode.system => brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light(),
    };

    return AppThemeScope(themeMode: _themeMode!, theme: appTheme, child: widget.child);
  }
}
