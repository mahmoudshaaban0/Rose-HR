import 'package:flutter/material.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/rose_hr.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TimezoneHelper.initialize();
  final permissionStatus = await LocationProvider.checkPermission();
  if (permissionStatus == LocationPermissionStatus.denied) {
    await LocationProvider.requestPermission();
  }
  final themeScope = await ThemeScopeWidget.initialize(const RoseHr());
  await init();
  AppManager.init(sl());
  runApp(themeScope);
}
