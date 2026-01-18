part of 'permission_request_cubit.dart';

enum PermissionRequestStatus { initial, loading, success, error, permissionTypeSuccess, permissionTypeError }

class PermissionRequestState extends Equatable {
  const PermissionRequestState({
    this.status = PermissionRequestStatus.initial,
    this.errorMessage,
    this.permissionTypeName,
    this.permissionTypeId,
    this.date,
    this.reasonTypeName,
    this.reasonTypeId,
    this.startTime,
    this.endTime,
    this.shiftId,
    this.permissionRequestResponseModel,
    this.partialExcuse = false,
    this.requestedDuration,
  });
  final PermissionRequestStatus status;
  final String? errorMessage;
  final String? permissionTypeName;
  final String? permissionTypeId;
  final String? date;
  final String? reasonTypeName;
  final String? reasonTypeId;
  final String? startTime;
  final String? endTime;
  final int? shiftId;
  final PermissionRequestResponseModel? permissionRequestResponseModel;
  final bool partialExcuse;
  final double? requestedDuration;
  @override
  List<Object?> get props => [
    status,
    errorMessage,
    permissionTypeName,
    permissionTypeId,
    date,
    reasonTypeName,
    reasonTypeId,
    startTime,
    endTime,
    shiftId,
    permissionRequestResponseModel,
    partialExcuse,
    requestedDuration,
  ];

  PermissionRequestState copyWith({
    PermissionRequestStatus? status,
    String? errorMessage,
    String? permissionTypeName,
    String? permissionTypeId,
    String? date,
    String? reasonTypeName,
    String? reasonTypeId,
    String? startTime,
    String? endTime,
    bool clearStartTime = false,
    bool clearEndTime = false,
    int? shiftId,
    PermissionRequestResponseModel? permissionRequestResponseModel,
    bool? partialExcuse,
    double? requestedDuration,
  }) {
    return PermissionRequestState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      permissionTypeName: permissionTypeName ?? this.permissionTypeName,
      permissionTypeId: permissionTypeId ?? this.permissionTypeId,
      date: date ?? this.date,
      reasonTypeName: reasonTypeName ?? this.reasonTypeName,
      reasonTypeId: reasonTypeId ?? this.reasonTypeId,
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      shiftId: shiftId ?? this.shiftId,
      permissionRequestResponseModel: permissionRequestResponseModel ?? this.permissionRequestResponseModel,
      partialExcuse: partialExcuse ?? this.partialExcuse,
      requestedDuration: requestedDuration ?? this.requestedDuration,
    );
  }
}
