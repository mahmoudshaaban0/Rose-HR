import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/features/permission_request/data/repositories/permission_request_repository.dart';

part 'permission_request_event.dart';
part 'permission_request_state.dart';

class PermissionRequestBloc extends Bloc<PermissionRequestEvent, PermissionRequestState> {
  PermissionRequestBloc(this.permissionRequestRepository) : super(const PermissionRequestState()) {
    // TODO: Register your event handlers here
    // Example:
    // on<YourPermissionRequestEvent>(_onYourEvent);
  }

  final PermissionRequestRepository permissionRequestRepository;

  // TODO: Add your event handler methods here
  // Example:
  // Future<void> _onYourEvent(
  //   YourPermissionRequestEvent event,
  //   Emitter<PermissionRequestState> emit,
  // ) async {
  //   emit(state.copyWith(status: PermissionRequestStatus.loading));
  //   final result = await permissionRequestRepository.yourMethod(event.request);
  //   switch (result) {
  //     case Success(:final data):
  //       emit(state.copyWith(status: PermissionRequestStatus.success, data: data));
  //     case Error(:final failure):
  //       emit(state.copyWith(status: PermissionRequestStatus.error, errorMessage: failure.message));
  //   }
  // }
}

