import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/helpers/timezone_helper.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_request.dart';
import 'package:rose_hr/features/home/data/models/create_attendance_punch_response.dart';
import 'package:rose_hr/features/home/data/models/home_response.dart';
import 'package:rose_hr/features/home/data/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepository) : super(const HomeState());
  final HomeRepository homeRepository;

  Future<void> createAttendancePunchIn(CreateAttendancePunchRequest request) async {
    if (isClosed) return;
    emit(state.copyWith(status: HomeStatus.loading));
    final result = await homeRepository.createAttendancePunchIn(request);
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: HomeStatus.success, createAttendancePunchResponse: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: HomeStatus.error, error: failure.message));
    }
  }

  Future<void> getHome() async {
    if (isClosed) return;
    emit(state.copyWith(homeStatus: HomeDataStatus.loading));
    final result = await homeRepository.getHome();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        // Build the state directly (instead of copyWith) so a null/expired
        // checkout clears any previously stored value rather than keeping it.
        emit(
          HomeState(
            status: state.status,
            homeStatus: HomeDataStatus.success,
            createAttendancePunchResponse: state.createAttendancePunchResponse,
            leaveBalances: data.result?.data?.leaveBalances ?? const [],
            projectedCheckout: _parseProjectedCheckout(
              data.result?.data?.projectedCheckout,
            ),
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(homeStatus: HomeDataStatus.error, error: failure.message));
    }
  }

  /// Parses the backend `projected_checkout` value (a naive UTC timestamp such
  /// as `"2026-06-22 20:45:00"`) and converts it to the app's GPS-detected
  /// local timezone. Returns `null` for missing/blank/invalid values.
  DateTime? _parseProjectedCheckout(dynamic raw) {
    if (raw is! String || raw.trim().isEmpty) return null;
    try {
      final parsed = DateTime.parse(raw.trim());
      // The backend value is UTC but carries no timezone marker, so reinterpret
      // the parsed components as UTC before converting to local time.
      final utc = DateTime.utc(
        parsed.year,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
      );
      return TimezoneHelper.fromUtc(utc);
    } on FormatException {
      return null;
    }
  }
}
