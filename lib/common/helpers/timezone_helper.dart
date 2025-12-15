import 'package:intl/intl.dart';
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
/// across Egypt and Saudi Arabia timezones.
///
/// This class provides utilities for:
/// - Getting current time in specific timezones
/// - Converting between timezones and UTC
/// - Formatting timezone-aware dates
/// - Creating timezone-aware timestamps
///
/// Usage:
/// ```dart
/// // Initialize once at app startup
/// await TimezoneHelper.initialize();
///
/// // Get current time in Egypt
/// final nowInEgypt = TimezoneHelper.now(AppTimezone.egypt);
///
/// // Convert to UTC for storage
/// final utc = TimezoneHelper.toUtc(nowInEgypt);
///
/// // Convert back to Saudi Arabia timezone
/// final inSaudi = TimezoneHelper.fromUtc(utc, AppTimezone.saudiArabia);
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

  /// Get the current date and time in the specified timezone
  ///
  /// Example:
  /// ```dart
  /// final nowInEgypt = TimezoneHelper.now(AppTimezone.egypt);
  /// final nowInSaudi = TimezoneHelper.now(AppTimezone.saudiArabia);
  /// ```
  static tz.TZDateTime now(AppTimezone timezone) {
    final location = _getLocation(timezone);
    return tz.TZDateTime.now(location);
  }

  /// Convert a timezone-aware datetime to UTC for storage
  ///
  /// Always store timestamps in UTC in your database/backend,
  /// then convert to local timezone for display.
  ///
  /// Example:
  /// ```dart
  /// final clockIn = TimezoneHelper.now(AppTimezone.egypt);
  /// final utcForStorage = TimezoneHelper.toUtc(clockIn);
  /// // Save utcForStorage to database
  /// ```
  static DateTime toUtc(tz.TZDateTime time) {
    return time.toUtc();
  }

  /// Convert a UTC datetime to a timezone-aware datetime
  ///
  /// Use this to convert stored UTC timestamps back to local timezone for display.
  ///
  /// Example:
  /// ```dart
  /// // Retrieved from database (UTC)
  /// final utcTimestamp = DateTime.parse('2025-11-10 07:00:00Z');
  /// final egyptTime = TimezoneHelper.fromUtc(utcTimestamp, AppTimezone.egypt);
  /// ```
  static tz.TZDateTime fromUtc(DateTime utc, AppTimezone timezone) {
    final location = _getLocation(timezone);
    return tz.TZDateTime.from(utc, location);
  }

  /// Create a timezone-aware datetime from a regular DateTime
  ///
  /// This is useful when you have a DateTime object and want to
  /// explicitly associate it with a timezone.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime(2025, 11, 10, 9, 0); // 9:00 AM
  /// final egyptTime = TimezoneHelper.createTimestamp(AppTimezone.egypt, date);
  /// ```
  static tz.TZDateTime createTimestamp(AppTimezone timezone, DateTime dateTime) {
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

  /// Convert a regular DateTime to timezone-aware DateTime in the specified timezone
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

  /// Convert between two timezones
  ///
  /// Example:
  /// ```dart
  /// final egyptTime = TimezoneHelper.now(AppTimezone.egypt);
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

  /// Get timezone offset in hours for a specific timezone
  ///
  /// Example:
  /// ```dart
  /// final offset = TimezoneHelper.getTimezoneOffset(AppTimezone.egypt);
  /// // Returns 2 (UTC+2) or 3 (UTC+3) depending on DST
  /// ```
  static int getTimezoneOffset(AppTimezone timezone) {
    final time = now(timezone);
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

  /// Get timezone abbreviation (e.g., "EET", "AST")
  static String getTimezoneAbbreviation(AppTimezone timezone) {
    final time = now(timezone);
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
}
