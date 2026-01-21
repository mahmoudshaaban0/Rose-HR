part of 'work_mission_cubit.dart';

enum WorkMissionStatus { initial, loading, success, error }

class WorkMissionState extends Equatable {
  const WorkMissionState({
    this.status = WorkMissionStatus.initial,
    this.errorMessage,
    this.workMissionTypeId,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.shiftId,
    this.date,
    this.workMissionResponseModel,
  });

  final WorkMissionStatus status;
  final String? errorMessage;
  final String? workMissionTypeId;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final int? shiftId;
  final String? date;
  final dynamic workMissionResponseModel;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    workMissionTypeId,
    startDate,
    endDate,
    startTime,
    endTime,
    shiftId,
    date,
    workMissionResponseModel,
  ];

  WorkMissionState copyWith({
    WorkMissionStatus? status,
    String? errorMessage,
    String? workMissionTypeId,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    int? shiftId,
    String? date,
    dynamic workMissionResponseModel,
  }) {
    return WorkMissionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      workMissionTypeId: workMissionTypeId ?? this.workMissionTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      shiftId: shiftId ?? this.shiftId,
      date: date ?? this.date,
      workMissionResponseModel: workMissionResponseModel ?? this.workMissionResponseModel,
    );
  }
}
