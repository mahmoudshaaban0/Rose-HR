import 'package:equatable/equatable.dart';
import 'package:rose_hr/features/permission_request/data/models/shift_id_response_model.dart';

enum ShiftIdStatus { initial, loading, success, error }

class ShiftIdState extends Equatable {
  const ShiftIdState({
    this.status = ShiftIdStatus.initial,
    this.shiftIdResponseModel,
    this.errorMessage,
  });
  final ShiftIdStatus status;
  final ShiftIdResponseModel? shiftIdResponseModel;
  final String? errorMessage;
  @override
  List<Object?> get props => [status, shiftIdResponseModel, errorMessage];

  ShiftIdState copyWith({
    ShiftIdStatus? status,
    ShiftIdResponseModel? shiftIdResponseModel,
    String? errorMessage,
  }) {
    return ShiftIdState(
      status: status ?? this.status,
      shiftIdResponseModel: shiftIdResponseModel ?? this.shiftIdResponseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
