part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

enum HomeDataStatus { initial, loading, success, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.homeStatus = HomeDataStatus.initial,
    this.createAttendancePunchResponse,
    this.leaveBalances = const [],
    this.error,
  });
  final HomeStatus status;
  final HomeDataStatus homeStatus;
  final CreateAttendancePunchResponse? createAttendancePunchResponse;
  final List<LeaveBalance> leaveBalances;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    HomeDataStatus? homeStatus,
    CreateAttendancePunchResponse? createAttendancePunchResponse,
    List<LeaveBalance>? leaveBalances,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeStatus: homeStatus ?? this.homeStatus,
      createAttendancePunchResponse: createAttendancePunchResponse ?? this.createAttendancePunchResponse,
      leaveBalances: leaveBalances ?? this.leaveBalances,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, homeStatus, createAttendancePunchResponse, leaveBalances, error];
}
