import 'package:flutter/material.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class NoRequestsWidget extends StatelessWidget {
  const NoRequestsWidget({
    required this.title,
    required this.onRefresh,
    super.key,
  });

  final String title;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      color: context.colors.onSurface,
      onRefresh: onRefresh,
      child: CustomScrollView(
        // Required so pull-to-refresh works when there is no overflow (empty state in TabBarView).
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppVectorGraphic(path: Assets.vectorsNoRequests),
                Text(
                  title,
                  style: context.typography.semiBold18,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
