import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  ToastService._();

  static Future<bool?> showSuccess(
    String message, {
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return _show(
      message: message,
      backgroundColor: const Color(0xFF1FC16B), // Success color
      textColor: Colors.white,
      duration: duration,
      gravity: gravity,
    );
  }

  static Future<bool?> showError(
    String message, {
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return _show(
      message: message,
      backgroundColor: const Color(0xFFFB3748), // Error color
      textColor: Colors.white,
      duration: duration,
      gravity: gravity,
    );
  }

  static Future<bool?> showWarning(
    String message, {
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return _show(
      message: message,
      backgroundColor: const Color(0xFFF6B51E), // Warning color
      textColor: Colors.white,
      duration: duration,
      gravity: gravity,
    );
  }

  static Future<bool?> showInfo(
    String message, {
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return _show(
      message: message,
      backgroundColor: const Color(0xFF335CFF), // Info color
      textColor: Colors.white,
      duration: duration,
      gravity: gravity,
    );
  }

  static Future<bool?> showCustom({
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 16.0,
  }) {
    return _show(
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      duration: duration,
      gravity: gravity,
      fontSize: fontSize,
    );
  }

  static Future<bool?> show(
    String message, {
    Toast duration = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: duration,
      gravity: gravity,
      fontAsset: 'assets/fonts/itfMirsalC-Medium.otf',
    );
  }

  static Future<bool?> _show({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    Toast duration = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 16.0,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: duration,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      fontAsset: 'assets/fonts/itfMirsalC-Medium.otf',
    );
  }

  static Future<bool?> cancel() {
    return Fluttertoast.cancel();
  }
}
