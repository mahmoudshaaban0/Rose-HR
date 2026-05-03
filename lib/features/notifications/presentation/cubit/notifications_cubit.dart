import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/notifications/data/models/notifications_response_model.dart';
import 'package:rose_hr/features/notifications/data/repositories/notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.notificationsRepository) : super(const NotificationsState());
  final NotificationsRepository notificationsRepository;

  Future<void> getNotifications() async {
    if (isClosed) return;
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await notificationsRepository.getNotifications();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: data.result?.data?.notifications ?? <NotificationItem>[],
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: NotificationsStatus.error, error: failure.message));
    }
  }
}
