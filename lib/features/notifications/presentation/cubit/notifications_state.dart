part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const <NotificationItem>[],
    this.error,
  });

  final NotificationsStatus status;
  final List<NotificationItem> notifications;
  final String? error;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? notifications,
    String? error,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, notifications, error];
}
