import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();

  /// Extra small shadow.
  static const xs = [
    BoxShadow(
      blurRadius: 2,
      offset: Offset(0, 1),
      color: Color.fromRGBO(16, 24, 40, 0.05),
    ),
  ];

  /// Small shadow.
  static const sm = [
    BoxShadow(color: Color(0x0F101828), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x19101828), blurRadius: 3, offset: Offset(0, 1)),
  ];

  static const lg = [
    BoxShadow(
      color: Color(0x0D101828),
      offset: Offset(0, -6),
      blurRadius: 24,
    ),
  ];
}
