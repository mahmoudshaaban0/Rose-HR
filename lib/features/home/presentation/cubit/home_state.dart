part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

enum HomeDataStatus { initial, loading, success, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.homeStatus = HomeDataStatus.initial,
    this.createAttendancePunchResponse,
    this.leaveBalances = const [],
    this.projectedCheckout,
    this.error,
  });
  final HomeStatus status;
  final HomeDataStatus homeStatus;
  final CreateAttendancePunchResponse? createAttendancePunchResponse;
  final List<LeaveBalance> leaveBalances;

  /// The projected checkout time, already converted from the backend's UTC
  /// value to the app's GPS-detected local timezone. `null` when there is no
  /// active punch / the backend did not return a value.
  final DateTime? projectedCheckout;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    HomeDataStatus? homeStatus,
    CreateAttendancePunchResponse? createAttendancePunchResponse,
    List<LeaveBalance>? leaveBalances,
    DateTime? projectedCheckout,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeStatus: homeStatus ?? this.homeStatus,
      createAttendancePunchResponse: createAttendancePunchResponse ?? this.createAttendancePunchResponse,
      leaveBalances: leaveBalances ?? this.leaveBalances,
      projectedCheckout: projectedCheckout ?? this.projectedCheckout,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, homeStatus, createAttendancePunchResponse, leaveBalances, projectedCheckout, error];
}
