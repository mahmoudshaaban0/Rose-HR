part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.createAttendancePunchResponse,
    this.error,
  });
  final HomeStatus status;
  final CreateAttendancePunchResponse? createAttendancePunchResponse;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    CreateAttendancePunchResponse? createAttendancePunchResponse,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      createAttendancePunchResponse: createAttendancePunchResponse ?? this.createAttendancePunchResponse,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, createAttendancePunchResponse, error];
}
