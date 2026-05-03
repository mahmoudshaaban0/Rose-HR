import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rose_hr/common/constants/app_strings.dart';

class NotificationHelpers {
  NotificationHelpers._();
  static int generateId(RemoteMessage message) {
    if (message.messageId != null) {
      return message.messageId.hashCode.abs();
    }
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static String? encodePayload(Map<String, dynamic> data) {
    if (data.isEmpty) return null;
    try {
      return jsonEncode(data);
    } on Exception catch (_) {
      return null;
    }
  }

  static NotificationDetails buildDetails() {
    const android = AndroidNotificationDetails(
      AppStrings.channelId,
      AppStrings.channelName,
      channelDescription: AppStrings.channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: AppStrings.androidIcon,
    );
    const iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return const NotificationDetails(android: android, iOS: iOS);
  }

  static String? _stringFromData(Object? value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static String getTitle(RemoteMessage message) {
    final title = message.notification?.title ?? _stringFromData(message.data['title']);
    if (title == null || title.isEmpty) return AppStrings.defaultTitle;
    return title.trim();
  }

  static String getBody(RemoteMessage message) {
    final body = message.notification?.body ?? _stringFromData(message.data['body']);
    if (body == null || body.isEmpty) return AppStrings.defaultBody;
    return body.trim();
  }

  static Future<void> showNotification(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    await plugin.show(
      id: generateId(message),
      title: getTitle(message),
      body: getBody(message),
      notificationDetails: buildDetails(),
      payload: encodePayload(message.data),
    );
  }

  static AndroidNotificationChannel createChannel() {
    return const AndroidNotificationChannel(
      AppStrings.channelId,
      AppStrings.channelName,
      description: AppStrings.channelDescription,
      importance: Importance.max,
    );
  }
}
