part of 'timezone_cubit.dart';

/// Base state for timezone management
abstract class TimezoneState extends Equatable {
  const TimezoneState();

  @override
  List<Object?> get props => [];
}

/// Initial state before timezone detection
class TimezoneInitial extends TimezoneState {
  const TimezoneInitial();
}

/// Loading state while detecting timezone
class TimezoneLoading extends TimezoneState {
  const TimezoneLoading();
}

/// State when timezone is successfully loaded
class TimezoneLoaded extends TimezoneState {
  const TimezoneLoaded({
    required this.timezone,
    required this.locationName,
    required this.currentTime,
    this.cityName,
  });

  /// The detected timezone (Egypt or Saudi Arabia)
  final AppTimezone timezone;

  /// Arabic location name (القاهرة or الرياض)
  final String locationName;

  /// Current time in the detected timezone
  final tz.TZDateTime currentTime;

  /// City name from geocoding (e.g., "Cairo", "Riyadh")
  final String? cityName;

  @override
  List<Object?> get props => [timezone, locationName, currentTime, cityName];

  /// Create a copy with updated fields
  TimezoneLoaded copyWith({
    AppTimezone? timezone,
    String? locationName,
    tz.TZDateTime? currentTime,
    String? cityName,
  }) {
    return TimezoneLoaded(
      timezone: timezone ?? this.timezone,
      locationName: locationName ?? this.locationName,
      currentTime: currentTime ?? this.currentTime,
      cityName: cityName ?? this.cityName,
    );
  }

  /// Get formatted date and time in Arabic
  String getFormattedDateTime() {
    final dateFormatted = TimezoneHelper.format(
      currentTime,
      pattern: 'd MMMM yyyy',
      locale: 'ar',
    );
    final hour = currentTime.hour;
    final minute = currentTime.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'صباحًا' : 'مساءً';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$dateFormatted | $hour12:$minute $period';
  }

  /// Get formatted time only
  String getFormattedTime() {
    final hour = currentTime.hour;
    final minute = currentTime.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'صباحًا' : 'مساءً';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$hour12:$minute $period';
  }

  /// Get formatted date only
  String getFormattedDate() {
    return TimezoneHelper.format(
      currentTime,
      pattern: 'd MMMM yyyy',
      locale: 'ar',
    );
  }
}
