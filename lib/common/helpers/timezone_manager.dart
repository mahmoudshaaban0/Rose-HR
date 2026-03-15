import 'package:logger/logger.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// A singleton manager for handling the app's current timezone.
///
/// This provides a centralized way to access the current timezone location
/// for use with `TZDateTime.now(TimezoneManager.location)` throughout the app.
///
/// ## Initialization
///
/// Initialize once at app startup in `main.dart`:
/// ```dart
/// await TimezoneManager.instance.initialize();
/// ```
///
/// ## Usage
///
/// Get current time in the detected timezone:
/// ```dart
/// final now = TZDateTime.now(TimezoneManager.location);
/// ```
///
/// Or use the convenience method:
/// ```dart
/// final now = TimezoneManager.now();
/// ```
///
/// ## Timezone Detection Priority
///
/// 1. GPS-based detection (determines Egypt vs Saudi Arabia based on location)
/// 2. Fallback to Saudi Arabia (default for the app)
/// 3. UTC as last resort if all else fails
class TimezoneManager {
  TimezoneManager._();

  static final TimezoneManager _instance = TimezoneManager._();
  static final Logger _log = Logger();

  /// Singleton instance
  static TimezoneManager get instance => _instance;

  /// Whether the manager has been initialized
  bool _isInitialized = false;

  /// The current timezone location
  tz.Location? _location;

  /// The current app timezone enum
  AppTimezone _appTimezone = AppTimezone.saudiArabia;

  /// The IANA timezone name (e.g., "Africa/Cairo", "Asia/Riyadh")
  String _timezoneName = AppTimezone.saudiArabia.locationName;

  /// City name from geocoding (e.g., "Cairo", "Riyadh")
  String? _cityName;

  /// Whether timezone detection is still in progress
  bool _isDetecting = false;

  // ============== Static Getters ==============

  /// Get the current timezone location for use with TZDateTime
  ///
  /// Usage:
  /// ```dart
  /// final now = TZDateTime.now(TimezoneManager.location);
  /// ```
  static tz.Location get location {
    _instance._ensureInitialized();
    return _instance._location!;
  }

  /// Get the current timezone as AppTimezone enum
  static AppTimezone get appTimezone => _instance._appTimezone;

  /// Get the IANA timezone name (e.g., "Africa/Cairo")
  static String get timezoneName => _instance._timezoneName;

  /// Get the city name from geocoding (may be null if not detected)
  static String? get cityName => _instance._cityName;

  /// Check if timezone detection is still in progress
  static bool get isDetecting => _instance._isDetecting;

  /// Check if the manager has been initialized
  static bool get isInitialized => _instance._isInitialized;

  // ============== Convenience Methods ==============

  /// Get current time in the app's timezone
  ///
  /// This is a convenience method equivalent to:
  /// ```dart
  /// TZDateTime.now(TimezoneManager.location)
  /// ```
  static tz.TZDateTime now() {
    _instance._ensureInitialized();
    return tz.TZDateTime.now(_instance._location!);
  }

  /// Get current time in a specific timezone
  static tz.TZDateTime nowIn(AppTimezone timezone) {
    _instance._ensureInitialized();
    final loc = tz.getLocation(timezone.locationName);
    return tz.TZDateTime.now(loc);
  }

  /// Convert a DateTime to the app's timezone
  static tz.TZDateTime fromDateTime(DateTime dateTime) {
    _instance._ensureInitialized();
    return tz.TZDateTime.from(dateTime, _instance._location!);
  }

  /// Create a TZDateTime in the app's timezone
  static tz.TZDateTime create({
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) {
    _instance._ensureInitialized();
    return tz.TZDateTime(
      _instance._location!,
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  // ============== Initialization ==============

  /// Initialize the timezone manager
  ///
  /// This should be called once at app startup, typically in `main.dart`:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await TimezoneManager.instance.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  ///
  /// [detectFromGps] - If true, attempts to detect timezone from GPS location.
  ///                   If false, uses the default timezone (Saudi Arabia).
  ///                   Default is true.
  Future<void> initialize({bool detectFromGps = true}) async {
    if (_isInitialized) return;

    // Initialize timezone database
    tz_data.initializeTimeZones();

    // Set default timezone immediately (Saudi Arabia)
    _setTimezone(AppTimezone.saudiArabia);
    _isInitialized = true;

    if (detectFromGps) {
      // Detect actual timezone in background
      _isDetecting = true;
      await _detectTimezoneFromGps();
      _isDetecting = false;
    }

  }

  /// Detect timezone from GPS location
  Future<void> _detectTimezoneFromGps() async {
    try {
      final permissionStatus = await LocationProvider.checkPermission();

      if (permissionStatus == LocationPermissionStatus.granted) {
        final result = await LocationProvider.getTimezoneWithLocationName();
        _setTimezone(result.timezone, cityName: result.locationName);
      }
    } on Exception catch (e) {
      _log.e('Failed to detect timezone from GPS: $e');
      // Keep the default timezone (Saudi Arabia)
    }
  }

  /// Set the current timezone
  void _setTimezone(AppTimezone timezone, {String? cityName}) {
    try {
      _appTimezone = timezone;
      _timezoneName = timezone.locationName;
      _location = tz.getLocation(timezone.locationName);
      _cityName = cityName;
      tz.setLocalLocation(_location!);
    } on Exception catch (e) {
      _log.e('Failed to set timezone: $e');
      // Fallback to UTC
      _location = tz.UTC;
      _timezoneName = 'UTC';
    }
  }

  /// Manually update the timezone
  ///
  /// Use this to change the timezone after initialization, for example
  /// when the user manually selects a different timezone.
  static void setTimezone(AppTimezone timezone, {String? cityName}) {
    _instance.._ensureInitialized()
    .._setTimezone(timezone, cityName: cityName);
  }

  /// Refresh timezone detection from GPS
  ///
  /// Call this after location permission is granted to re-detect the timezone.
  static Future<void> refreshFromGps() async {
    _instance.._ensureInitialized()
    .._isDetecting = true;
    await _instance._detectTimezoneFromGps();
    _instance._isDetecting = false;
  }

  /// Set timezone by IANA name (e.g., "Africa/Cairo", "Asia/Riyadh")
  ///
  /// Returns true if successful, false if the timezone name is invalid.
  static bool setTimezoneByName(String ianaName, {String? cityName}) {
    _instance._ensureInitialized();

    try {
      final loc = tz.getLocation(ianaName);
      _instance._location = loc;
      _instance._timezoneName = ianaName;
      _instance._cityName = cityName;
      tz.setLocalLocation(loc);

      // Update AppTimezone enum if it matches
      if (ianaName == AppTimezone.egypt.locationName) {
        _instance._appTimezone = AppTimezone.egypt;
      } else if (ianaName == AppTimezone.saudiArabia.locationName) {
        _instance._appTimezone = AppTimezone.saudiArabia;
      }

      return true;
    } on Exception catch (e) {
      _log.e('Invalid timezone name: $ianaName - $e');
      return false;
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'TimezoneManager not initialized. Call TimezoneManager.instance.initialize() '
        'before using timezone operations.',
      );
    }
  }

  // ============== Utility Methods ==============

  /// Get the current UTC offset in hours
  static int get utcOffsetHours {
    _instance._ensureInitialized();
    return tz.TZDateTime.now(_instance._location!).timeZoneOffset.inHours;
  }

  /// Get the timezone abbreviation (e.g., "EET", "AST")
  static String get timezoneAbbreviation {
    _instance._ensureInitialized();
    return tz.TZDateTime.now(_instance._location!).timeZoneName;
  }

  /// Format the current timezone offset as a string (e.g., "+03:00")
  static String get formattedOffset {
    final offset = utcOffsetHours;
    final sign = offset >= 0 ? '+' : '';
    return '$sign${offset.toString().padLeft(2, '0')}:00';
  }
}
