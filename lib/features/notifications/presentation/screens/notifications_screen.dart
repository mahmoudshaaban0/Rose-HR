import 'package:flutter/material.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: context.localizations.notifications),
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          color: context.colors.onSurface,
          onRefresh: () async {
            return Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Align(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppVectorGraphic(path: Assets.vectorsNoNotifications),
                    Text(
                      'No notifications yet',
                      style: context.typography.semiBold18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
