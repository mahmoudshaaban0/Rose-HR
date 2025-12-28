import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:timezone/timezone.dart' as tz;

part 'timezone_state.dart';

/// Cubit that manages timezone and location detection based on GPS coordinates
class TimezoneCubit extends Cubit<TimezoneState> {
  TimezoneCubit() : super(const TimezoneInitial()) {
    _initialize();
  }

  Timer? _timer;

  /// Track the detected timezone for clock updates before detection completes
  AppTimezone _currentTimezone = AppTimezone.saudiArabia;

  /// Initialize timezone detection and start the clock immediately
  Future<void> _initialize() async {
    // Start the clock immediately with default timezone
    // This ensures time is always updating, even during detection
    _startClock();

    // Emit an initial loaded state with default timezone so clock shows immediately
    final now = TimezoneHelper.now(_currentTimezone);
    emit(
      TimezoneLoaded(
        timezone: _currentTimezone,
        locationName: '...',
        currentTime: now,
        cityName: null,
        isDetecting: true, // Flag to indicate we're still detecting
      ),
    );

    // Then detect actual timezone in background
    await _detectTimezone();
  }

  /// Detect timezone based on user's GPS location
  Future<void> _detectTimezone() async {
    if (isClosed) return;

    try {
      // Get timezone with city name from geocoding
      final result = await LocationProvider.getTimezoneWithLocationName();
      _currentTimezone = result.timezone;
      final now = TimezoneHelper.now(_currentTimezone);

      if (isClosed) return;
      emit(
        TimezoneLoaded(
          timezone: result.timezone,
          locationName: result.locationName,
          currentTime: now,
          cityName: result.locationName,
          isDetecting: false,
        ),
      );
    } on Exception catch (_) {
      // Fallback to default timezone if location detection fails
      _currentTimezone = AppTimezone.saudiArabia;
      final now = TimezoneHelper.now(_currentTimezone);
      if (isClosed) return;
      emit(
        TimezoneLoaded(
          timezone: AppTimezone.saudiArabia,
          locationName: 'الرياض',
          currentTime: now,
          cityName: 'الرياض',
          isDetecting: false,
        ),
      );
    }
  }

  /// Start the clock timer to update time every second
  void _startClock() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  /// Update the current time
  void _updateTime() {
    if (isClosed) return;

    final currentState = state;
    if (currentState is TimezoneLoaded) {
      final now = TimezoneHelper.now(currentState.timezone);
      emit(currentState.copyWith(currentTime: now));
    } else {
      // Even in loading/initial state, emit time updates with current timezone
      final now = TimezoneHelper.now(_currentTimezone);
      emit(
        TimezoneLoaded(
          timezone: _currentTimezone,
          locationName: '...',
          currentTime: now,
          cityName: null,
          isDetecting: true,
        ),
      );
    }
  }

  /// Manually refresh timezone detection (useful after permission changes)
  Future<void> refreshTimezone() async {
    await _detectTimezone();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    return super.close();
  }
}
