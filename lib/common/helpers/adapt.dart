// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// /// Legacy helper functions - now using ScreenUtil under the hood
// double getScaleFactor(BuildContext context) {
//   return ScreenUtil().scaleWidth;
// }

// double getResponsiveFontSize(BuildContext context, {required double fontSize}) {
//   return SizeExtension(fontSize).sp;
// }

// /// Design system constants
// class DesignSystem {
//   static const referenceWidth = 375.0;
//   static const referenceHeight = 812.0;
//   static const minScaleFactor = 0.85;
//   static const maxScaleFactor = 1.25;
// }

// /// Context extensions for responsive design
// extension ResponsiveContext on BuildContext {
//   /// Get screen size
//   Size get screenSize => MediaQuery.sizeOf(this);

//   /// Get scale factors
//   double get scaleWidth => ScreenUtil().scaleWidth;
//   double get scaleHeight => ScreenUtil().scaleHeight;
//   double get scale => ScreenUtil().scaleText;
//   double get safeScale => scale.clamp(DesignSystem.minScaleFactor, DesignSystem.maxScaleFactor);

//   /// Device type checks
//   bool get isMobile => ScreenUtil().screenWidth < 600;
//   bool get isTablet => ScreenUtil().screenWidth >= 600 && ScreenUtil().screenWidth < 900;
//   bool get isDesktop => ScreenUtil().screenWidth >= 900;
// }

// /// Wrapper extensions for backward compatibility with existing code
// /// These allow calling .w(context), .h(context), etc. while using flutter_screenutil under the hood
// extension ResponsiveNum on num {
//   /// Responsive width - context parameter kept for backward compatibility but not used
//   double w(BuildContext context) => SizeExtension(toDouble()).w;

//   /// Responsive height - context parameter kept for backward compatibility but not used
//   double h(BuildContext context) => SizeExtension(toDouble()).h;

//   /// Perfect responsive font size - context parameter kept for backward compatibility but not used
//   double sp(BuildContext context) => SizeExtension(toDouble()).sp;

//   /// Responsive radius/padding - context parameter kept for backward compatibility but not used
//   double r(BuildContext context) => SizeExtension(toDouble()).r;
// }
