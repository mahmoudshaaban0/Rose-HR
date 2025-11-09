import 'dart:ui';
import 'package:flutter/material.dart';

class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromView(window);
  static double _width = _validateDimension(mediaQuery.size.width, 1920.0);
  static double _height = _validateDimension(mediaQuery.size.height, 1080.0);
  static double _topbarH = mediaQuery.padding.top;
  static double _botbarH = mediaQuery.padding.bottom;
  static double _pixelRatio = _validateDimension(mediaQuery.devicePixelRatio, 1.0);
  static num _ratio = 0;
  static final double _smallestWidth = _width > _height ? _height : _width;
  static final bool _isLargeScreen = _smallestWidth > 820;
  static final bool _isMediumScreen = _smallestWidth > 600 && _smallestWidth <= 820;
  static final bool _hasNotch = Device.get().hasNotch;
  static final bool _isLandscape = mediaQuery.orientation == Orientation.landscape;
  // Helper method to validate dimensions and provide fallback values
  static double _validateDimension(double value, double fallback) {
    return (value.isFinite && value > 0) ? value : fallback;
  }

  static initAll(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    _width = _validateDimension(mediaQueryData.size.width, 1920.0);
    _height = _validateDimension(mediaQueryData.size.height, 1080.0);
    _topbarH = mediaQueryData.padding.top;
    _botbarH = mediaQueryData.padding.bottom;
    _pixelRatio = _validateDimension(mediaQueryData.devicePixelRatio, 1.0);
    init(1920);
  }

  static init(int number) {
    if (number <= 0) number = 1920; // Prevent division by zero
    // Handle cases where _width might be NaN or Infinity
    if (!_width.isFinite || _width <= 0) {
      _width = 1920.0; // Set a default width
    }
    _ratio = _width / number;
  }

  static double px(num number) {
    if (!(_ratio > 0)) {
      Adapt.init(1920);
    }
    double result = (number * _ratio).toDouble();
    // Handle NaN or Infinity values to prevent runtime errors
    if (!result.isFinite) {
      return 0.0;
    }
    return result;
  }

  static double onepx() {
    if (_pixelRatio <= 0) return 1.0; // Prevent division by zero
    return 1 / _pixelRatio;
  }

  static double screenW() {
    return _width;
  }

  static double screenH() {
    return _height;
  }

  static double padTopH() {
    return _topbarH;
  }

  static double padBotH() {
    return _botbarH;
  }

  double wp(num percentage) {
    double result = (percentage * _validateDimension(_width, 1920.0)) / 100;
    return result.isFinite ? result : 0.0;
  }

  double hp(num percentage) {
    double result = (percentage * _validateDimension(_height, 1080.0)) / 100;
    return result.isFinite ? result : 0.0;
  }

  static bool isLargeScreen() => _isLargeScreen;
  static bool isMediumScreen() => _isMediumScreen;
  static bool isSmallScreen() => !_isLargeScreen && !_isMediumScreen;
  static double roundToNearestNumber(double number) {
    try {
      double result = double.parse(number.toString());
      result = result.roundToDouble();
      if (result == 0) {
        result = 1;
      }
      return result;
    } catch (e) {
      return 5;
    }
  }

  static bool hasNotch() => _hasNotch;
  static bool isLandscape() => _isLandscape;
}
