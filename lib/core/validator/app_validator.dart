import 'package:flutter/material.dart';

class AppValidator {
  // Validation of email
  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validation of password
  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Validation of phone number
  static String? validatePhoneNumber(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  // Validation of full name
  static String? validateFullName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    } else if (value.trim().length < 3) {
      return 'Full name must be at least 3 characters';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  // Validation for Employee ID
  static String? validateEmpId(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Employee ID is required';
    }
    return null;
  }
}
