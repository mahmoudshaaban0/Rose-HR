import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        emit(
          state.copyWith(
            homeStatus: HomeDataStatus.success,
            leaveBalances: data.result?.data?.leaveBalances ?? const [],
          ),
        );
      case Error(:final failure):
        if (isClosed) return;
        emit(state.copyWith(homeStatus: HomeDataStatus.error, error: failure.message));
    }
  }
}
