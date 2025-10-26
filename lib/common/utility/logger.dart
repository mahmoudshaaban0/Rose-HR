import 'package:logger/logger.dart';

class LoggerUtils {
  LoggerUtils._();
  static LoggerUtils get instance {
    return _instance;
  }

  static final LoggerUtils _instance = LoggerUtils._();

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      stackTraceBeginIndex: 2,
    ),
  );

  void logInfo(String message) {
    _logger.i(message);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logError(String message) {
    _logger.e(message);
  }

  void logFatalError(String message, StackTrace? stackTrace) {
    _logger.f(message, stackTrace: stackTrace);
  }
}
