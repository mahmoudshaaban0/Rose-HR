import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'punch_correction_state.dart';

class AttendanceCorrectionCubit extends Cubit<AttendanceCorrectionState> {
  AttendanceCorrectionCubit() : super(AttendanceCorrectionInitial());
}
