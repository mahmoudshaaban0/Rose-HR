import 'package:flutter/material.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/helpers/location_helper.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/rose_hr.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TimezoneHelper.initialize();
  final permissionStatus = await LocationHelper.checkPermission();
  if (permissionStatus == LocationPermissionStatus.denied) {
    await LocationHelper.requestPermission();
  }
  final themeScope = await ThemeScopeWidget.initialize(const RoseHr());
  await init();
  await AppManager.initialize(sl());
  runApp(themeScope);
}
