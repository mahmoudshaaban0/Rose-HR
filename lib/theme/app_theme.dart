import 'package:rose_hr/theme/app_button.dart';
import 'package:rose_hr/theme/app_colors.dart';
import 'package:rose_hr/theme/app_input.dart';
import 'package:rose_hr/theme/app_typography.dart';

final class AppTheme {
  const AppTheme({required this.colors, required this.typography, required this.inputTheme, required this.buttonTheme});

  factory AppTheme.dark() {
    final colors = AppColors.dark();
    return AppTheme(
      colors: colors,
      typography: AppTypography.dark(colors),
      inputTheme: AppInputTheme.dark(colors),
      buttonTheme: AppButtonTheme.dark(colors),
    );
  }

  factory AppTheme.light() {
    final colors = AppColors.light();
    return AppTheme(
      colors: colors,
      typography: AppTypography.light(colors),
      inputTheme: AppInputTheme.light(colors),
      buttonTheme: AppButtonTheme.light(colors),
    );
  }
  final AppColors colors;
  final AppTypography typography;
  final AppInputTheme inputTheme;
  final AppButtonTheme buttonTheme;
}
