class AppStrings {
  AppStrings._();
  static const String appName = 'Rose HR';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String serverFailure = 'Server Failure';
  static const String cacheFailure = 'Cache Failure';
  static const String unexpectedError = 'Unexpected Error';
  static const String authorization = 'Authorization';
  static const String arabic = 'ar';
  static const String english = 'en';
  static const String sa = 'SA';
  static const String accept = 'Accept';
  // Header key for API language
  static const String langHeader = 'lang';
  // Stored/local language code (e.g. 'en_US' or 'ar_001')
  static const String lang = 'lang';
  static const String version = 'v1.0.0';
  static const String uid = 'uid';
  static const String email = 'email';
  static const String name = 'name';
  static const String apiKey = 'apiKey';

  /// User preference: general in-app / system-style notifications
  static const String notificationsAppEnabled = 'notifications_app_enabled';

  /// User preference: requests & replies notifications
  static const String notificationsRequestsEnabled = 'notifications_requests_enabled';

  static const String channelId = 'app_channel';
  static const String channelName = 'Notifications';
  static const String channelDescription = 'App notifications';

  static const String defaultTitle = 'New Notification';
  static const String defaultBody = 'You have a notification';

  static const String androidIcon = '@mipmap/ic_launcher';
  static const String androidSound = 'notification_sound';
  static const String iosSound = 'notification_sound.aiff';
}
