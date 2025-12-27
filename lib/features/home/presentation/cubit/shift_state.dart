part of 'shift_cubit.dart';

enum ShiftStatus { initial, loading, success, error }

enum LocationCheckStatus {
  initial,
  loading,
  success,
  error,
  checkedBetweenRadiusSuccessfully,
  checkingBetweenRadiusLoading,
  checkedBetweenRadiusError,
}

class ShiftState extends Equatable {
  const ShiftState({
    this.status = ShiftStatus.initial,
    this.currentShiftResponse,
    this.error,
    this.locationCheckStatus = LocationCheckStatus.initial,
    this.isWithinRadius,
    this.distanceFromShift,
  });
  final ShiftStatus status;
  final CurrentShiftResponse? currentShiftResponse;
  final String? error;
  final LocationCheckStatus locationCheckStatus;
  final bool? isWithinRadius;
  final double? distanceFromShift;

  ShiftState copyWith({
    ShiftStatus? status,
    CurrentShiftResponse? currentShiftResponse,
    String? error,
    LocationCheckStatus? locationCheckStatus,
    bool? isWithinRadius,
    double? distanceFromShift,
  }) {
    return ShiftState(
      status: status ?? this.status,
      currentShiftResponse: currentShiftResponse ?? this.currentShiftResponse,
      error: error ?? this.error,
      locationCheckStatus: locationCheckStatus ?? this.locationCheckStatus,
      isWithinRadius: isWithinRadius ?? this.isWithinRadius,
      distanceFromShift: distanceFromShift ?? this.distanceFromShift,
    );
  }

  @override
  List<Object?> get props => [status, currentShiftResponse, error, locationCheckStatus, isWithinRadius, distanceFromShift];
}
