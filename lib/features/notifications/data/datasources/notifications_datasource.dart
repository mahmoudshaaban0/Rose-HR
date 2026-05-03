import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/features/notifications/data/models/notifications_response_model.dart';

class NotificationsDataSource {
  NotificationsDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  static const String _notificationsPath = '/api/firebase/notifications';

  Future<NotificationsResponseModel> getNotifications() async {
    final response = await apiConsumer.post(
      _notificationsPath,
      body: {
        "params": {
          "limit": 50,
          "offset": 0,
        },
      },
    );
    return NotificationsResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
