import 'package:flutter/material.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/rose_hr.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeScope = await ThemeScopeWidget.initialize(const RoseHr());
  await init();
  await AppManager.initialize(sl());
  runApp(themeScope);
}
