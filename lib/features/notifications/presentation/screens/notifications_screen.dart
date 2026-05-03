import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rose_hr/common/constants/app_assets.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/widgets/appbar.dart';
import 'package:rose_hr/common/widgets/vector.dart';
import 'package:rose_hr/features/notifications/data/models/notifications_response_model.dart';
import 'package:rose_hr/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsCubit>()..getNotifications(),
      child: Scaffold(
        appBar: PrimaryAppBar(title: context.localizations.notifications),
        body: SafeArea(
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              return RefreshIndicator.adaptive(
                color: context.colors.onSurface,
                onRefresh: () => context.read<NotificationsCubit>().getNotifications(),
                child: _buildBody(context, state),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state.status == NotificationsStatus.loading && state.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (state.notifications.isEmpty) {
      return _buildEmpty(context);
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: state.notifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _NotificationCard(item: state.notifications[index]);
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Align(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppVectorGraphic(path: Assets.vectorsNoNotifications),
              const SizedBox(height: 12),
              Text(
                'No notifications yet',
                style: context.typography.semiBold18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final hasBody = (item.body ?? '').isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.containerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(Icons.notifications, size: 20.r, color: context.colors.onSurface),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title ?? '',
                        style: context.typography.semiBold16,
                      ),
                    ),
                    if (item.sentDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        _relativeTime(item.sentDate!),
                        style: context.typography.regular12.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                if (hasBody) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.body!,
                    style: context.typography.regular14.copyWith(
                      color: context.colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
                if (item.sentDate != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          _absoluteDate(item.sentDate!),
                          style: context.typography.regular12.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _absoluteDate(DateTime utc) {
    final local = TimezoneHelper.fromUtc(utc);
    return TimezoneHelper.format(local, pattern: 'dd MMM yyyy • hh:mm a');
  }

  String _relativeTime(DateTime utc) {
    final local = TimezoneHelper.fromUtc(utc);
    final now = TimezoneHelper.now();
    final diff = now.difference(local);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo';
    return '${(diff.inDays / 365).floor()}y';
  }
}
