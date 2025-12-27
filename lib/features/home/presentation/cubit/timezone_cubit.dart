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

  /// Initialize timezone detection and start the clock
  Future<void> _initialize() async {
    await _detectTimezone();
    _startClock();
  }

  /// Detect timezone based on user's GPS location
  Future<void> _detectTimezone() async {
    if (isClosed) return;
    emit(const TimezoneLoading());

    try {
      // Get timezone with city name from geocoding
      final result = await LocationProvider.getTimezoneWithLocationName();
      final now = TimezoneHelper.now(result.timezone);

      if (isClosed) return;
      emit(
        TimezoneLoaded(
          timezone: result.timezone,
          locationName: result.locationName,
          currentTime: now,
          cityName: result.locationName, // Use the geocoded city name
        ),
      );
    } on Exception catch (_) {
      // Fallback to default timezone if location detection fails
      final now = TimezoneHelper.now(AppTimezone.saudiArabia);
      if (isClosed) return;
      emit(
        TimezoneLoaded(
          timezone: AppTimezone.saudiArabia,
          locationName: 'الرياض',
          currentTime: now,
          cityName: 'الرياض',
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
    final currentState = state;
    if (currentState is TimezoneLoaded) {
      final now = TimezoneHelper.now(currentState.timezone);
      emit(currentState.copyWith(currentTime: now));
    }
  }

  /// Manually refresh timezone detection (useful after permission changes)
  Future<void> refreshTimezone() async {
    await _detectTimezone();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
