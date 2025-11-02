import 'package:flutter/material.dart';
import 'package:rose_hr/theme/theme_ext.dart';

class AuthHelper {
  AuthHelper._();

  // static String? validateName(BuildContext context, String? value) {
  //   if (value == null || value.isEmpty) {
  //     return context.localizations.pleaseEnterYourName;
  //   }
  //   return null;
  // }

  // static String? validatePhoneNumber(BuildContext context, String? value) {
  //   if (value == null || value.isEmpty) {
  //     return context.localizations.pleaseEnterYourPhoneNumber;
  //   }
  //   return null;
  // }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.pleaseEnterYourEmail;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return context.localizations.pleaseEnterYourEmail;
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.pleaseEnterYourPassword;
    }

    if (value.length < 8) {
      return context.localizations.pleaseEnterYourPassword;
    }

    final hasUpperCase = RegExp('[A-Z]').hasMatch(value);
    final hasNumber = RegExp('[0-9]').hasMatch(value);

    if (!hasUpperCase || !hasNumber) {
      return context.localizations.pleaseEnterYourPassword;
    }

    return null;
  }

  static String? validateConfirmPassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return context.localizations.pleaseEnterYourPassword;
    }
    return null;
  }

  // static String? validateCompanyName(BuildContext context, String? value) {
  //   if (value == null || value.isEmpty) {
  //     return context.localizations.pleaseEnterYourCompanyName;
  //   }
  //   return null;
  // }
}
