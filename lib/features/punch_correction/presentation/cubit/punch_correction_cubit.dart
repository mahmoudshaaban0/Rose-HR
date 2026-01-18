import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'punch_correction_state.dart';

class AttendanceCorrectionCubit extends Cubit<AttendanceCorrectionState> {
  AttendanceCorrectionCubit() : super(AttendanceCorrectionInitial());
}
