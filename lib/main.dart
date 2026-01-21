import 'package:flutter/material.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/app_manager.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/helpers/timezone_manager.dart';
import 'package:rose_hr/rose_hr.dart';
import 'package:rose_hr/theme/theme_mode_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database (required for TimezoneHelper)
  await TimezoneHelper.initialize();

  // Request location permission if needed
  final permissionStatus = await LocationProvider.checkPermission();
  if (permissionStatus == LocationPermissionStatus.denied) {
    await LocationProvider.requestPermission();
  }

  // Initialize TimezoneManager with GPS-based timezone detection
  // This will auto-detect Egypt/Saudi Arabia based on user's location
  await TimezoneManager.instance.initialize();

  final themeScope = await ThemeScopeWidget.initialize(const RoseHr());
  await init();
  AppManager.init(sl());
  runApp(themeScope);
}
