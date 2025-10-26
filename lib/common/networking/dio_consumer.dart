import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rose_hr/common/constants/env.dart';
import 'package:rose_hr/common/dependency_injection/injection_container.dart';
import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/networking/api_consumer.dart';
import 'package:rose_hr/common/networking/app_intercepters.dart';
import 'package:rose_hr/common/networking/status_code.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer({required this.client}) {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final httpClient = HttpClient();

      // Only bypass certificate validation in debug mode
      if (kDebugMode) {
        // In debug mode, bypass certificate validation
        httpClient.badCertificateCallback =
            (
              X509Certificate cert,
              String host,
              int port,
            ) => true;
      } else {
        // In release mode, verify certificates properly
        // This means use the system’s default certificate validation, so only
        // valid, trusted SSL certificates are accepted.
        httpClient.badCertificateCallback = null;
      }

      return httpClient;
    };

    client.options
      ..baseUrl = Env.baseUrl
      ..responseType = ResponseType.json
      ..followRedirects = false
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30)
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    client.interceptors.add(sl<AppIntercepters>());
    if (kDebugMode) {
      client.interceptors.add(sl<PrettyDioLogger>());
    }
  }
  final Dio client;

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.get<dynamic>(
        path,
        queryParameters: queryParameters,
        data: jsonEncode({}), // Send empty JSON body with GET request
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.post<dynamic>(
        // token
        path,
        queryParameters: queryParameters,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.put<dynamic>(
        path,
        queryParameters: queryParameters,
        data: body,
      );
      return _handleResponseAsJson(response);
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleResponseAsJson(Response<dynamic> response) {
    // Since responseType is now JSON, response.data should already be decoded
    final responseJson = response.data;

    // Handle cases where response might still be a string (fallback)
    try {
      final parsedData = responseJson is String ? jsonDecode(responseJson) : responseJson;

      // Session expiration is now handled exclusively in AppInterceptors
      // to avoid conflicts
      // This prevents duplicate session handling that could cause
      //false positives
      return parsedData;
    } catch (e) {
      // If JSON parsing fails and response is a string,
      // throw a more descriptive error
      if (responseJson is String) {
        throw FormatException('Server returned invalid JSON: $responseJson');
      }
      // Re-throw the original error for other cases
      rethrow;
    }
  }

  dynamic _handleDioError(DioException error) {
    // Try to extract backend error message
    final backendMessage = _extractBackendErrorMessage(error);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw FetchDataException(backendMessage);
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw BadRequestException(backendMessage);
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw UnauthorizedException(backendMessage);
          case StatusCode.notFound:
            throw NotFoundException(backendMessage);
          case StatusCode.confilct:
            throw ConflictException(backendMessage);
          case StatusCode.internalServerError:
            throw InternalServerErrorException(backendMessage);
          default:
            // For any other status codes
            throw ServerException(
              backendMessage ?? 'Server error (${error.response?.statusCode}).Please try again.',
            );
        }
      case DioExceptionType.cancel:
        throw ServerException(backendMessage ?? 'Request was cancelled.');
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(backendMessage);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(backendMessage);
      case DioExceptionType.connectionError:
        throw NoInternetConnectionException(backendMessage);
    }
  }

  /// Extract error message from backend response
  /// Tries common message fields and returns null if not found
  String? _extractBackendErrorMessage(DioException error) {
    try {
      final responseData = error.response?.data;

      if (responseData == null) return null;

      // If response is a string, return it directly
      if (responseData is String) {
        return responseData.isNotEmpty ? responseData : null;
      }

      // If response is not a Map, return null
      if (responseData is! Map<String, dynamic>) return null;

      final data = responseData;

      // Try common message fields
      const messageFields = [
        'message',
        'error',
        'detail',
        'description',
        'msg',
      ];

      // Check direct fields
      for (final field in messageFields) {
        if (data.containsKey(field) && data[field] is String) {
          final message = data[field] as String;
          if (message.isNotEmpty) return message;
        }
      }

      // Check for validation errors object (common in Laravel, Django, etc.)
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is String) return firstError;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
        }
      }

      // Check nested result/data object
      if (data['result'] is Map<String, dynamic>) {
        final result = data['result'] as Map<String, dynamic>;
        for (final field in messageFields) {
          if (result.containsKey(field) && result[field] is String) {
            final message = result[field] as String;
            if (message.isNotEmpty) return message;
          }
        }
      }

      if (data['data'] is Map<String, dynamic>) {
        final dataObj = data['data'] as Map<String, dynamic>;
        for (final field in messageFields) {
          if (dataObj.containsKey(field) && dataObj[field] is String) {
            final message = dataObj[field] as String;
            if (message.isNotEmpty) return message;
          }
        }
      }

      return null;
    } on Exception catch (_) {
      return null;
    }
  }
}
