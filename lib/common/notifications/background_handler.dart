import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rose_hr/common/notifications/notification_helpers.dart';
import 'package:rose_hr/common/utility/logger.dart';
import 'package:rose_hr/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // If the FCM payload contains a `notification` block, the system
    // already displays it. Only render a local notification for
    // data-only messages to avoid duplicates on Android.
    if (message.notification != null) return;
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await NotificationHelpers.showNotification(message, plugin);
  } on Exception catch (e) {
    AppLogger.instance.logError('Background error: $e');
  }
}
