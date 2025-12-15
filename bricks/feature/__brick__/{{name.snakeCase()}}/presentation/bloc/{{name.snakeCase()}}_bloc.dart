import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/features/{{name.snakeCase()}}/data/repositories/{{name.snakeCase()}}_repository.dart';

part '{{name.snakeCase()}}_event.dart';
part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc(this.{{name.camelCase()}}Repository) : super(const {{name.pascalCase()}}State()) {
    // TODO: Register your event handlers here
    // Example:
    // on<Your{{name.pascalCase()}}Event>(_onYourEvent);
  }

  final {{name.pascalCase()}}Repository {{name.camelCase()}}Repository;

  // TODO: Add your event handler methods here
  // Example:
  // Future<void> _onYourEvent(
  //   Your{{name.pascalCase()}}Event event,
  //   Emitter<{{name.pascalCase()}}State> emit,
  // ) async {
  //   emit(state.copyWith(status: {{name.pascalCase()}}Status.loading));
  //   final result = await {{name.camelCase()}}Repository.yourMethod(event.request);
  //   switch (result) {
  //     case Success(:final data):
  //       emit(state.copyWith(status: {{name.pascalCase()}}Status.success, data: data));
  //     case Error(:final failure):
  //       emit(state.copyWith(status: {{name.pascalCase()}}Status.error, errorMessage: failure.message));
  //   }
  // }
}

