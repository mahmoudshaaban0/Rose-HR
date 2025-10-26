import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  const ServerException(this.message);
  final String? message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([
    super.message = "No internet connection. Please check your network.",
  ]);
}

class ConflictException extends ServerException {
  const ConflictException([
    super.message = "A conflict occurred with the current state.",
  ]);
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([
    super.message = "Server error. Please try again later.",
  ]);
}

class NotFoundException extends ServerException {
  const NotFoundException([
    super.message = "The requested resource was not found.",
  ]);
}

class FetchDataException extends ServerException {
  const FetchDataException([
    super.message = "Request timeout. Please try again.",
  ]);
}

class BadRequestException extends ServerException {
  const BadRequestException([
    super.message = "Invalid request. Please check your input.",
  ]);
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([
    super.message = "Authentication required. Please login.",
  ]);
}

class SessionExpiredException extends ServerException {
  const SessionExpiredException([
    super.message = "Your session has expired. Please login again.",
  ]);
}

class BadCertificateException extends ServerException {
  const BadCertificateException([
    super.message = "SSL certificate error. Connection is not secure.",
  ]);
}
