import 'package:intl/intl.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/timezone_manager.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Enum representing supported timezones in the application
enum AppTimezone {
  /// Egypt timezone (Africa/Cairo)
  /// UTC+2 (may observe DST)
  egypt('Africa/Cairo'),

  /// Saudi Arabia timezone (Asia/Riyadh)
  /// UTC+3 (no DST)
  saudiArabia('Asia/Riyadh');

  const AppTimezone(this.locationName);

  /// IANA timezone location name
  final String locationName;
}

/// A centralized helper class for handling timezone-aware date and time operations
/// with dynamic GPS-based timezone detection.
///
/// This class provides utilities for:
/// - Getting current time using GPS-detected timezone
/// - Getting current time in specific timezones
/// - Converting between timezones and UTC
/// - Formatting timezone-aware dates
/// - Creating timezone-aware timestamps
/// - Detecting timezone from lat/lng coordinates
///
/// Usage:
/// ```dart
/// // Initialize once at app startup (done in main.dart)
/// await TimezoneHelper.initialize();
///
/// // Get current time using GPS-detected timezone (RECOMMENDED)
/// final now = TimezoneHelper.now();
///
/// // Or get current time in a specific timezone
/// final nowInEgypt = TimezoneHelper.nowIn(AppTimezone.egypt);
///
/// // Convert to UTC for storage
/// final utc = TimezoneHelper.toUtc(now);
///
/// // Detect timezone from coordinates
/// final timezone = TimezoneHelper.detectTimezoneFromCoordinates(
///   latitude: 30.0444,
///   longitude: 31.2357,
/// );
/// ```
class TimezoneHelper {
  TimezoneHelper._();

  static bool _isInitialized = false;

  /// Initialize the timezone database.
  /// This must be called once before using any timezone operations,
  /// typically in main() before runApp().
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await TimezoneHelper.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    if (!_isInitialized) {
      tz_data.initializeTimeZones();
      _isInitialized = true;
    }
  }

  /// Get the timezone location for a given [AppTimezone]
  static tz.Location _getLocation(AppTimezone timezone) {
    _ensureInitialized();
    return tz.getLocation(timezone.locationName);
  }

  /// Get the current date and time using the app's GPS-detected timezone
  ///
  /// This is the RECOMMENDED way to get current time in the app.
  /// It uses [TimezoneManager] which automatically detects the timezone
  /// based on the user's GPS location.
  ///
  /// Example:
  /// ```dart
  /// // Uses GPS-detected timezone (Egypt or Saudi Arabia)
  /// final now = TimezoneHelper.now();
  /// ```
  static tz.TZDateTime now() {
    return TimezoneManager.now();
  }

  /// Get the current date and time in a specific timezone
  ///
  /// Use this when you need to explicitly get time in a specific timezone
  /// regardless of the user's location.
  ///
  /// Example:
  /// ```dart
  /// final nowInEgypt = TimezoneHelper.nowIn(AppTimezone.egypt);
  /// final nowInSaudi = TimezoneHelper.nowIn(AppTimezone.saudiArabia);
  /// ```
  static tz.TZDateTime nowIn(AppTimezone timezone) {
    final location = _getLocation(timezone);
    return tz.TZDateTime.now(location);
  }

  /// Get the current date and time using the app's detected timezone
  ///
  /// This uses [TimezoneManager] to get the automatically detected timezone
  /// based on the user's GPS location.
  ///
  /// Example:
  /// ```dart
  /// // Uses the app's current timezone (auto-detected from GPS)
  /// final now = TimezoneHelper.nowLocal();
  /// ```
  @Deprecated('Use now() instead - it uses GPS-detected timezone by default')
  static tz.TZDateTime nowLocal() {
    return TimezoneManager.now();
  }

  /// Convert a timezone-aware datetime to UTC for storage
  ///
  /// Always store timestamps in UTC in your database/backend,
  /// then convert to local timezone for display.
  ///
  /// Example:
  /// ```dart
  /// final clockIn = TimezoneHelper.now();
  /// final utcForStorage = TimezoneHelper.toUtc(clockIn);
  /// // Save utcForStorage to database
  /// ```
  static DateTime toUtc(tz.TZDateTime time) {
    return time.toUtc();
  }

  /// Convert a UTC datetime to the app's GPS-detected timezone
  ///
  /// Use this to convert stored UTC timestamps back to the user's local timezone for display.
  ///
  /// Example:
  /// ```dart
  /// // Retrieved from database (UTC)
  /// final utcTimestamp = DateTime.parse('2025-11-10 07:00:00Z');
  /// final localTime = TimezoneHelper.fromUtc(utcTimestamp);
  /// ```
  static tz.TZDateTime fromUtc(DateTime utc) {
    return TimezoneManager.fromDateTime(utc);
  }

  /// Convert a UTC datetime to a specific timezone
  ///
  /// Use this when you need to convert to a specific timezone
  /// regardless of the user's GPS location.
  ///
  /// Example:
  /// ```dart
  /// // Retrieved from database (UTC)
  /// final utcTimestamp = DateTime.parse('2025-11-10 07:00:00Z');
  /// final egyptTime = TimezoneHelper.fromUtcTo(utcTimestamp, AppTimezone.egypt);
  /// ```
  static tz.TZDateTime fromUtcTo(DateTime utc, AppTimezone timezone) {
    final location = _getLocation(timezone);
    return tz.TZDateTime.from(utc, location);
  }

  /// Create a timezone-aware datetime from a regular DateTime using GPS-detected timezone
  ///
  /// This is useful when you have a DateTime object and want to
  /// associate it with the user's GPS-detected timezone.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 11, 10, 9, 0); // 9:00 AM
  /// final localTime = TimezoneHelper.createTimestamp(date);
  /// ```
  static tz.TZDateTime createTimestamp(DateTime dateTime) {
    return TimezoneManager.fromDateTime(dateTime);
  }

  /// Create a timezone-aware datetime from a regular DateTime in a specific timezone
  ///
  /// Use this when you need to explicitly associate a DateTime with a specific timezone.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 11, 10, 9, 0); // 9:00 AM
  /// final egyptTime = TimezoneHelper.createTimestampIn(date, AppTimezone.egypt);
  /// ```
  static tz.TZDateTime createTimestampIn(DateTime dateTime, AppTimezone timezone) {
    final location = _getLocation(timezone);
    return tz.TZDateTime.from(dateTime, location);
  }

  /// Format a timezone-aware datetime using a pattern
  ///
  /// Common patterns:
  /// - 'yyyy-MM-dd HH:mm:ss' -> "2025-11-10 09:00:00"
  /// - 'dd/MM/yyyy' -> "10/11/2025"
  /// - 'HH:mm' -> "09:00"
  /// - 'MMMM dd, yyyy' -> "November 10, 2025"
  ///
  /// Example:
  /// ```dart
  /// final time = TimezoneHelper.now(AppTimezone.egypt);
  /// final formatted = TimezoneHelper.format(time, pattern: 'HH:mm');
  /// print(formatted); // "09:00"
  /// ```
  static String format(
    tz.TZDateTime time, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(time);
  }

  /// Get a formatted string with timezone name
  ///
  /// Example:
  /// ```dart
  /// final time = TimezoneHelper.now(AppTimezone.egypt);
  /// final formatted = TimezoneHelper.formatWithTimezone(time);
  /// // "2025-11-10 09:00:00 EET" (Egypt Eastern European Time)
  /// ```
  static String formatWithTimezone(
    tz.TZDateTime time, {
    String pattern = 'yyyy-MM-dd HH:mm:ss',
    String? locale,
  }) {
    final formatter = DateFormat(pattern, locale);
    return '${formatter.format(time)} ${time.timeZoneName}';
  }

  /// Compare two timezone-aware datetimes
  ///
  /// Returns:
  /// - negative if [a] is before [b]
  /// - 0 if [a] equals [b]
  /// - positive if [a] is after [b]
  ///
  /// Works correctly even if [a] and [b] are in different timezones.
  static int compare(tz.TZDateTime a, tz.TZDateTime b) {
    return a.compareTo(b);
  }

  /// Check if two dates are on the same day (ignoring time)
  ///
  /// Works correctly even if dates are in different timezones.
  ///
  /// Example:
  /// ```dart
  /// final egyptTime = TimezoneHelper.now(AppTimezone.egypt);
  /// final saudiTime = TimezoneHelper.now(AppTimezone.saudiArabia);
  /// final sameDay = TimezoneHelper.isSameDay(egyptTime, saudiTime);
  /// ```
  static bool isSameDay(tz.TZDateTime a, tz.TZDateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Get the start of day (00:00:00) for a given date in the specified timezone
  ///
  /// Example:
  /// ```dart
  /// final now = TimezoneHelper.now(AppTimezone.egypt);
  /// final startOfDay = TimezoneHelper.startOfDay(now);
  /// // Returns today at 00:00:00 in Egypt timezone
  /// ```
  static tz.TZDateTime startOfDay(tz.TZDateTime date) {
    return tz.TZDateTime(
      date.location,
      date.year,
      date.month,
      date.day,
    );
  }

  /// Get the end of day (23:59:59.999) for a given date in the specified timezone
  static tz.TZDateTime endOfDay(tz.TZDateTime date) {
    return tz.TZDateTime(
      date.location,
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
    );
  }

  /// Convert a regular DateTime to timezone-aware DateTime using GPS-detected timezone
  ///
  /// This interprets the DateTime as if it were in the user's GPS-detected timezone.
  ///
  /// Example:
  /// ```dart
  /// final regular = DateTime(2025, 11, 10, 9, 0);
  /// final localTime = TimezoneHelper.toLocalTimezone(regular);
  /// // Treats 9:00 AM as user's local time (Egypt or Saudi Arabia)
  /// ```
  static tz.TZDateTime toLocalTimezone(DateTime dateTime) {
    final location = TimezoneManager.location;
    return tz.TZDateTime(
      location,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  /// Convert a regular DateTime to timezone-aware DateTime in a specific timezone
  ///
  /// This interprets the DateTime as if it were in the specified timezone.
  ///
  /// Example:
  /// ```dart
  /// final regular = DateTime(2025, 11, 10, 9, 0);
  /// final egypt = TimezoneHelper.toTimezone(regular, AppTimezone.egypt);
  /// // Treats 9:00 AM as Egypt time
  /// ```
  static tz.TZDateTime toTimezone(DateTime dateTime, AppTimezone timezone) {
    final location = _getLocation(timezone);
    return tz.TZDateTime(
      location,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  /// Convert a timezone-aware datetime to another timezone
  ///
  /// Example:
  /// ```dart
  /// final egyptTime = TimezoneHelper.nowIn(AppTimezone.egypt);
  /// final saudiTime = TimezoneHelper.convertTimezone(
  ///   egyptTime,
  ///   AppTimezone.saudiArabia,
  /// );
  /// // Shows the same moment in time but in Saudi Arabia timezone
  /// ```
  static tz.TZDateTime convertTimezone(
    tz.TZDateTime time,
    AppTimezone toTimezone,
  ) {
    final location = _getLocation(toTimezone);
    return tz.TZDateTime.from(time, location);
  }

  /// Convert a timezone-aware datetime to the app's GPS-detected timezone
  ///
  /// Example:
  /// ```dart
  /// final egyptTime = TimezoneHelper.nowIn(AppTimezone.egypt);
  /// final localTime = TimezoneHelper.convertToLocal(egyptTime);
  /// // Shows the same moment in time but in user's GPS-detected timezone
  /// ```
  static tz.TZDateTime convertToLocal(tz.TZDateTime time) {
    final location = TimezoneManager.location;
    return tz.TZDateTime.from(time, location);
  }

  /// Get timezone offset in hours for the GPS-detected timezone
  ///
  /// Example:
  /// ```dart
  /// final offset = TimezoneHelper.getTimezoneOffset();
  /// // Returns 2 (UTC+2) or 3 (UTC+3) depending on location and DST
  /// ```
  static int getTimezoneOffset() {
    return TimezoneManager.utcOffsetHours;
  }

  /// Get timezone offset in hours for a specific timezone
  ///
  /// Example:
  /// ```dart
  /// final offset = TimezoneHelper.getTimezoneOffsetFor(AppTimezone.egypt);
  /// // Returns 2 (UTC+2) or 3 (UTC+3) depending on DST
  /// ```
  static int getTimezoneOffsetFor(AppTimezone timezone) {
    final time = nowIn(timezone);
    return time.timeZoneOffset.inHours;
  }

  /// Helper method to ensure the timezone database is initialized
  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'TimezoneHelper not initialized. Call TimezoneHelper.initialize() '
        'before using timezone operations.',
      );
    }
  }

  /// Get timezone abbreviation for GPS-detected timezone (e.g., "EET", "AST")
  static String getTimezoneAbbreviation() {
    return TimezoneManager.timezoneAbbreviation;
  }

  /// Get timezone abbreviation for a specific timezone (e.g., "EET", "AST")
  static String getTimezoneAbbreviationFor(AppTimezone timezone) {
    final time = nowIn(timezone);
    return time.timeZoneName;
  }

  /// Check if a timezone observes Daylight Saving Time
  /// Note: Saudi Arabia does not observe DST, Egypt may observe it
  static bool observesDST(AppTimezone timezone) {
    // Check if offset changes throughout the year
    final location = _getLocation(timezone);
    final jan = tz.TZDateTime(location, 2025);
    final jul = tz.TZDateTime(location, 2025, 7);
    return jan.timeZoneOffset != jul.timeZoneOffset;
  }

  // ============== GPS-Based Timezone Detection ==============

  /// Detect timezone from latitude and longitude coordinates
  ///
  /// This determines whether the coordinates are closer to Egypt or Saudi Arabia
  /// and returns the appropriate timezone.
  ///
  /// Example:
  /// ```dart
  /// final timezone = TimezoneHelper.detectTimezoneFromCoordinates(
  ///   latitude: 30.0444,   // Cairo
  ///   longitude: 31.2357,
  /// );
  /// print(timezone); // AppTimezone.egypt
  /// ```
  static AppTimezone detectTimezoneFromCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return LocationProvider.getTimezoneFromCoordinates(latitude, longitude);
  }

  /// Get the GPS-detected timezone for the current user
  ///
  /// Returns the timezone detected by [TimezoneManager] based on GPS location.
  ///
  /// Example:
  /// ```dart
  /// final currentTimezone = TimezoneHelper.getCurrentTimezone();
  /// print(currentTimezone); // AppTimezone.egypt or AppTimezone.saudiArabia
  /// ```
  static AppTimezone getCurrentTimezone() {
    return TimezoneManager.appTimezone;
  }

  /// Get the IANA timezone name for the GPS-detected timezone
  ///
  /// Example:
  /// ```dart
  /// final name = TimezoneHelper.getCurrentTimezoneName();
  /// print(name); // "Africa/Cairo" or "Asia/Riyadh"
  /// ```
  static String getCurrentTimezoneName() {
    return TimezoneManager.timezoneName;
  }

  /// Get the city name from GPS detection (if available)
  ///
  /// Example:
  /// ```dart
  /// final city = TimezoneHelper.getCurrentCityName();
  /// print(city); // "Cairo" or "Riyadh" or null
  /// ```
  static String? getCurrentCityName() {
    return TimezoneManager.cityName;
  }

  /// Check if timezone is currently being detected from GPS
  static bool get isDetectingTimezone => TimezoneManager.isDetecting;

  /// Refresh timezone detection from current GPS location
  ///
  /// Call this to update the timezone based on the user's current location.
  /// Useful after location permission is granted or when the user travels.
  ///
  /// Example:
  /// ```dart
  /// await TimezoneHelper.refreshTimezoneFromGps();
  /// ```
  static Future<void> refreshTimezoneFromGps() async {
    await TimezoneManager.refreshFromGps();
  }

  /// Manually set the timezone (overrides GPS detection)
  ///
  /// Use this when you want to manually override the GPS-detected timezone.
  ///
  /// Example:
  /// ```dart
  /// TimezoneHelper.setTimezone(AppTimezone.egypt, cityName: 'Cairo');
  /// ```
  static void setTimezone(AppTimezone timezone, {String? cityName}) {
    TimezoneManager.setTimezone(timezone, cityName: cityName);
  }
}
