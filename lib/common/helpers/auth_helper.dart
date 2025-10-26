import 'package:flutter/material.dart';

class AuthHelper {
  AuthHelper._();

  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email is required';
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password is required';
    }

    final hasUpperCase = RegExp('[A-Z]').hasMatch(value);
    final hasNumber = RegExp('[0-9]').hasMatch(value);

    if (!hasUpperCase || !hasNumber) {
      return 'Password is required';
    }

    return null;
  }

  static String? validateConfirmPassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  static String? validateCompanyName(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    return null;
  }
}
