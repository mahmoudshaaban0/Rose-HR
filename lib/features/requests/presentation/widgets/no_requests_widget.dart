import 'package:flutter/material.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class NoRequestsWidget extends StatelessWidget {
  const NoRequestsWidget({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
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
                const AppVectorGraphic(path: Assets.vectorsNoRequests),
                Text(
                  title,
                  style: context.typography.semiBold18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
