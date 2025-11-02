import 'dart:math' as math;

import 'package:flutter/material.dart';

double getScaleFactor(BuildContext context) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  if (screenWidth < 600) {
    return screenWidth / 400;
  } else if (screenWidth < 900) {
    return screenWidth / 700;
  } else {
    return screenWidth / 1000;
  }
}

double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
  final scaleFactor = getScaleFactor(context);
  final responsiveFontSize = fontSize * scaleFactor;
  final lowerLimit = fontSize * 0.8;
  final upperLimit = fontSize * 1.2;
  return responsiveFontSize.clamp(lowerLimit, upperLimit);
}

class DesignSystem {
  static const referenceWidth = 375.0;
  static const referenceHeight = 812.0;
  static const minScaleFactor = 0.85;
  static const maxScaleFactor = 1.25;
}

extension ResponsiveContext on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get scale factors
  double get scaleWidth => screenSize.width / DesignSystem.referenceWidth;
  double get scaleHeight => screenSize.height / DesignSystem.referenceHeight;
  double get scale => math.min(scaleWidth, scaleHeight);
  double get safeScale => scale.clamp(DesignSystem.minScaleFactor, DesignSystem.maxScaleFactor);

  /// Device type checks
  bool get isMobile => screenSize.width < 600;
  bool get isTablet => screenSize.width >= 600 && screenSize.width < 900;
  bool get isDesktop => screenSize.width >= 900;
}

/// Clean responsive extensions for numbers
extension ResponsiveNum on num {
  /// Responsive width - requires context
  double w(BuildContext context) => this * context.scaleWidth;

  /// Responsive height - requires context
  double h(BuildContext context) => this * context.scaleHeight;

  /// Perfect responsive font size - requires context
  double sp(BuildContext context) => this * context.safeScale;

  /// Responsive radius/padding - requires context
  double r(BuildContext context) => this * context.scale;
}
