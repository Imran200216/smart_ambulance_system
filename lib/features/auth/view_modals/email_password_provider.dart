import 'package:flutter/material.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';

class EmailPasswordProvider extends ChangeNotifier {
  final EmailPasswordAuthService _authService =
  locator<EmailPasswordAuthService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Create a new user with email & password
  Future<bool> registerUser({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String empId,
  }) async {
    setLoading(true);
    try {
      final result = await _authService.createPassword(
        context: context,
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        empId: empId,
      );

      if (result != null) {
        SnackBarHelper.showSnackBar(
          context: context,
          leadingIcon: Icons.check_circle,
          message: 'Registration successful',
          backgroundColor: SnackBarHelper.successColor,
        );
        return true;
      }
      return false;
    } catch (e) {
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.error,
        message: e.toString(),
        backgroundColor: SnackBarHelper.errorColor,
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Sign in user
  Future<bool> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      final result = await _authService.signInWithPassword(
        context: context,
        email: email,
        password: password,
      );

      if (result != null) {
        SnackBarHelper.showSnackBar(
          context: context,
          leadingIcon: Icons.login,
          message: 'Login successful',
          backgroundColor: SnackBarHelper.successColor,
        );
        return true;
      }
      return false;
    } catch (e) {
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.error,
        message: e.toString(),
        backgroundColor: SnackBarHelper.errorColor,
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Send password reset email
  Future<bool> resetPassword({
    required BuildContext context,
    required String email,
  }) async {
    setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(context: context, email: email);
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.email,
        message: 'Password reset email sent',
        backgroundColor: SnackBarHelper.successColor,
      );
      return true;
    } catch (e) {
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.error,
        message: e.toString(),
        backgroundColor: SnackBarHelper.errorColor,
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Sign out user
  Future<bool> signOutUser(BuildContext context) async {
    try {
      await _authService.signOut();
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.logout,
        message: 'Signed out',
        backgroundColor: SnackBarHelper.successColor,
      );
      return true;
    } catch (e) {
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.error,
        message: e.toString(),
        backgroundColor: SnackBarHelper.errorColor,
      );
      return false;
    }
  }
}
