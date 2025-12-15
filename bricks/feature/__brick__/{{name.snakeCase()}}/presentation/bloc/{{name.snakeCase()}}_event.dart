part of '{{name.snakeCase()}}_bloc.dart';

abstract class {{name.pascalCase()}}Event extends Equatable {
  const {{name.pascalCase()}}Event();

  @override
  List<Object> get props => [];
}

// TODO: Add your events here
// Example:
// class Fetch{{name.pascalCase()}}Event extends {{name.pascalCase()}}Event {
//   const Fetch{{name.pascalCase()}}Event(this.request);
//   final YourRequestModel request;
//
//   @override
//   List<Object> get props => [request];
// }

