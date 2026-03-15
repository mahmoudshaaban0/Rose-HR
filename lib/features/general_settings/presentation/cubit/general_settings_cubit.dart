import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_settings_state.dart';

class GeneralSettingsCubit extends Cubit<GeneralSettingsState> {
  GeneralSettingsCubit() : super(GeneralSettingsInitial());
}
