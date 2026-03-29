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
    this.isDetecting = false,
  });

  /// The detected timezone (Egypt or Saudi Arabia)
  final AppTimezone timezone;

  /// Arabic location name (القاهرة or الرياض)
  final String locationName;

  /// Current time in the detected timezone
  final tz.TZDateTime currentTime;

  /// City name from geocoding (e.g., "Cairo", "Riyadh")
  final String? cityName;

  /// Whether timezone detection is still in progress
  final bool isDetecting;

  @override
  // Note: We use millisecondsSinceEpoch to ensure time changes are always detected
  // even when TZDateTime objects might be considered equal by Equatable
  List<Object?> get props => [
    timezone,
    locationName,
    currentTime.millisecondsSinceEpoch,
    cityName,
    isDetecting,
  ];

  /// Create a copy with updated fields.
  /// Pass [clearCityName] as true to explicitly set cityName to null.
  TimezoneLoaded copyWith({
    AppTimezone? timezone,
    String? locationName,
    tz.TZDateTime? currentTime,
    String? cityName,
    bool clearCityName = false,
    bool? isDetecting,
  }) {
    return TimezoneLoaded(
      timezone: timezone ?? this.timezone,
      locationName: locationName ?? this.locationName,
      currentTime: currentTime ?? this.currentTime,
      cityName: clearCityName ? null : (cityName ?? this.cityName),
      isDetecting: isDetecting ?? this.isDetecting,
    );
  }

  /// Get formatted date and time in Arabic
  String getFormattedDateTime({required BuildContext context, String locale = 'ar'}) {
    final dateFormatted = TimezoneHelper.format(
      currentTime,
      pattern: 'd MMMM yyyy',
      locale: locale,
    );
    final hour = currentTime.hour;
    final minute = currentTime.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? context.localizations.timePeriodAm : context.localizations.timePeriodPm;
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$dateFormatted | $hour12:$minute $period';
  }

  /// Get formatted time only
  String getFormattedTime({required BuildContext context}) {
    final hour = currentTime.hour;
    final minute = currentTime.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? context.localizations.timePeriodAm : context.localizations.timePeriodPm;
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$hour12:$minute $period';
  }

  /// Get formatted date only
  String getFormattedDate({String locale = 'ar'}) {
    return TimezoneHelper.format(
      currentTime,
      pattern: 'd MMMM yyyy',
      locale: locale,
    );
  }
}
