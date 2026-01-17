import 'package:logger/logger.dart';

// we need to know the file name and line number of the log
class AppLogger {
  AppLogger._();
  static AppLogger get instance {
    return _instance;
  }

  static final AppLogger _instance = AppLogger._();

  /// we need to know the file name and line number of the log
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      stackTraceBeginIndex: 2,
    ),
  );

  void logDebug(String message) {
    _logger.d(message);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logInfo(String message) {
    _logger.i(message);
  }

  void logError(String message) {
    _logger.e(message);
  }

  void logFatalError(String message, StackTrace? stackTrace) {
    _logger.f(message, stackTrace: stackTrace);
  }
}
