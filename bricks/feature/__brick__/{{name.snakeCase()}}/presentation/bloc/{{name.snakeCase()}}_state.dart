part of '{{name.snakeCase()}}_bloc.dart';

enum {{name.pascalCase()}}Status { initial, loading, success, error }

class {{name.pascalCase()}}State extends Equatable {
  const {{name.pascalCase()}}State({
    this.status = {{name.pascalCase()}}Status.initial,
    this.errorMessage,
  });

  final {{name.pascalCase()}}Status status;
  final String? errorMessage;

  // TODO: Add your state properties here (e.g., data models, lists, etc.)

  @override
  List<Object?> get props => [status, errorMessage];

  {{name.pascalCase()}}State copyWith({
    {{name.pascalCase()}}Status? status,
    String? errorMessage,
  }) {
    return {{name.pascalCase()}}State(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

