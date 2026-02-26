import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';

class LogService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 100,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
      
    ),
  );

   void d(String message) => _logger.d(message);
   void i(String message) => _logger.i(message);
   void w(String message) => _logger.w(message);
   void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
final logServiceProvider = Provider<LogService>((ref) => LogService());