import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/helpers/location_provider.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/home/data/models/current_shift_response.dart';
import 'package:rose_hr/features/home/data/repositories/home_repository.dart';

part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  ShiftCubit(this.homeRepository) : super(const ShiftState());
  final HomeRepository homeRepository;

  Future<void> getCurrentShift() async {
    if (isClosed) return;
    emit(state.copyWith(status: ShiftStatus.loading));
    final result = await homeRepository.getCurrentShift();
    switch (result) {
      case Success(:final data):
        if (isClosed) return;
        emit(state.copyWith(status: ShiftStatus.success, currentShiftResponse: data));
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(status: ShiftStatus.error, error: failure.message));
    }
  }

  /// Check if user's current location is within the shift radius
  ///
  // / Updates state with [isWithinRadius] and [distanceFromShift]
  Future<void> checkIfWithinShiftRadius() async {
    await getCurrentShift();
    final shiftData = state.currentShiftResponse?.result?.data;

    if (shiftData == null || shiftData.latitude == null || shiftData.longitude == null || shiftData.radius == null) {
      return;
    }
    if (isClosed) return;
    emit(state.copyWith(locationCheckStatus: LocationCheckStatus.checkingBetweenRadiusLoading));

    try {
      final result = await LocationProvider.isCurrentLocationWithinRadius(
        targetLat: shiftData.latitude!,
        targetLng: shiftData.longitude!,
        radiusInMeters: shiftData.radius!.toDouble(),
      );

      if (isClosed) return;
      if (shiftData.latitude == 0.0 && shiftData.longitude == 0.0) {
        if (isClosed) return;
        emit(
          state.copyWith(
            locationCheckStatus: LocationCheckStatus.checkedBetweenRadiusSuccessfully,
            isWithinRadius: true,
            distanceFromShift: result.distance,
          ),
        );
      } else {
        if (isClosed) return;
        emit(
          state.copyWith(
            locationCheckStatus: LocationCheckStatus.checkedBetweenRadiusSuccessfully,
            isWithinRadius: result.isWithin,
            distanceFromShift: result.distance,
          ),
        );
      }
    } on Exception catch (_) {
      if (isClosed) return;
      emit(state.copyWith(locationCheckStatus: LocationCheckStatus.checkedBetweenRadiusError));
    }
  }
}
