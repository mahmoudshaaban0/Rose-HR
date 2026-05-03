import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rose_hr/common/notifications/notification_helpers.dart';
import 'package:rose_hr/common/utility/logger.dart';

class NotificationService {
  factory NotificationService() => _instance;
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? _plugin;
  bool _initialized = false;
  final _tapController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onTap => _tapController.stream;
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      _plugin = FlutterLocalNotificationsPlugin();
      await _plugin!.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: _onTap,
      );
      if (Platform.isAndroid) {
        await _createChannel();
      }
      await _setupListeners();
      _initialized = true;
    } catch (e) {
      AppLogger.instance.logError('Init error: $e');
      rethrow;
    }
  }

  Future<void> _createChannel() async {
    final channel = NotificationHelpers.createChannel();
    await _plugin!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      channel,
    );
  }

  Future<void> _setupListeners() async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleMessage(initial);
    FirebaseMessaging.onMessage.listen(_showForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      final token = await _getTokenSafely();
      if (token != null) {
        AppLogger.instance.logInfo('FCM Token: $token');
      }
    }
  }

  /// On iOS, waits for the APNs token before requesting the FCM token.
  /// On simulator (no APNs), skips FCM token generation entirely.
  Future<String?> _getTokenSafely() async {
    if (Platform.isIOS) {
      final apns = await _waitForApnsToken();
      if (apns == null) {
        AppLogger.instance.logInfo('Simulator detected – skipping FCM token');
        return null;
      }
    }
    return _messaging.getToken();
  }

  Future<String?> _waitForApnsToken() async {
    for (var i = 0; i < 10; i++) {
      final apns = await _messaging.getAPNSToken();
      if (apns != null) return apns;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return null;
  }

  Future<void> _showForeground(RemoteMessage message) async {
    if (_plugin != null) {
      await NotificationHelpers.showNotification(message, _plugin!);
    }
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      _tapController.add(message.data);
    }
  }

  void _onTap(NotificationResponse response) {
    if (response.payload != null && response.payload!.isNotEmpty) {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      _tapController.add(data);
    }
  }

  static Future<String?> getToken() async {
    if (Platform.isIOS) {
      // On simulator (no APNs), skip FCM token generation
      String? apns;
      for (var i = 0; i < 10; i++) {
        apns = await _messaging.getAPNSToken();
        if (apns != null) break;
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
      if (apns == null) return null;
    }
    return _messaging.getToken();
  }
  static Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);
  static Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
  void dispose() {
    _tapController.close();
  }
}
