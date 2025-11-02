import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/constants/app_strings.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.goNamed(AppRoutes.home.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            Text(AppStrings.appName, style: context.typography.bold22),
          ],
        ),
      ),
    );
  }
}
