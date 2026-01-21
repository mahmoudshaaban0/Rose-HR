import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rose_hr/common/routing/app_routes.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/features/requests/presentation/screens/completed_requests_screen.dart';
import 'package:rose_hr/features/requests/presentation/screens/current_requests_screen.dart';
import 'package:rose_hr/theme/app_spacing.dart';
import 'package:rose_hr/theme/theme_ext.dart';

// need to create tab bar
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: context.localizations.requests),
      body: SafeArea(
        child: Column(
          spacing: AppSpacing.md.h,
          children: [
            Material(
              color: context.colors.containerBackground,
              child: TabBar(
                controller: tabController,
                indicator: BoxDecoration(
                  color: context.colors.onSurface,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0,
                labelColor: context.colors.surface,
                unselectedLabelColor: context.colors.onSurfaceVariant,
                labelStyle: context.typography.semiBold16,
                unselectedLabelStyle: context.typography.regular16,
                padding: const EdgeInsets.all(AppSpacing.xs),
                tabs: [
                  Tab(text: context.localizations.currentRequests),
                  Tab(text: context.localizations.completedRequests),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  CurrentRequests(),
                  CompletedRequests(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
