part of 'eos_cubit.dart';

enum EosStatus { initial, loading, success, error, submitting, submitted, submitError }

class EosState extends Equatable {
  const EosState({
    this.status = EosStatus.initial,
    this.errorMessage,
    this.eosResponseModel,
    this.isSaudi = false,
    this.lastWorkingDay,
    this.resignationReason = ResignationReason.resignation,
    this.resignationReasonDetail,
  });

  final EosStatus status;
  final String? errorMessage;
  final EosResponseModel? eosResponseModel;

  /// Whether the employee nationality is Saudi. When true only `resignation`
  /// is allowed; otherwise both `resignation` and `termination` are offered.
  final bool isSaudi;
  final String? lastWorkingDay;
  final ResignationReason resignationReason;
  final String? resignationReasonDetail;

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    eosResponseModel,
    isSaudi,
    lastWorkingDay,
    resignationReason,
    resignationReasonDetail,
  ];

  EosState copyWith({
    EosStatus? status,
    String? errorMessage,
    EosResponseModel? eosResponseModel,
    bool? isSaudi,
    String? lastWorkingDay,
    ResignationReason? resignationReason,
    Object? resignationReasonDetail = _undefined,
  }) {
    return EosState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      eosResponseModel: eosResponseModel ?? this.eosResponseModel,
      isSaudi: isSaudi ?? this.isSaudi,
      lastWorkingDay: lastWorkingDay ?? this.lastWorkingDay,
      resignationReason: resignationReason ?? this.resignationReason,
      resignationReasonDetail:
          resignationReasonDetail == _undefined ? this.resignationReasonDetail : resignationReasonDetail as String?,
    );
  }
}

// Sentinel value for copyWith to distinguish between "not provided" and "set to null"
const _undefined = Object();
