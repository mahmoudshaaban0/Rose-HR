import 'dart:developer';
import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({required this.connectivityChecker});
  final InternetConnectionChecker connectivityChecker;

  @override
  Future<bool> get isConnected async {
    try {
      // Configure the checker with custom settings for better reliability
      final checker =
          InternetConnectionChecker.createInstance(
              checkInterval: const Duration(seconds: 1),
            )
            // Add your API server as a custom address to check
            ..addresses = [
              AddressCheckOptions(
                address: InternetAddress('8.8.8.8'),
                timeout: const Duration(
                  seconds: 5,
                ),
              ),
              AddressCheckOptions(
                address: InternetAddress('1.1.1.1'),
                timeout: const Duration(seconds: 5),
              ),
            ];

      return await checker.hasConnection;
    } on Exception catch (e) {
      log(e.toString());
      return connectivityChecker.hasConnection;
    }
  }
}
