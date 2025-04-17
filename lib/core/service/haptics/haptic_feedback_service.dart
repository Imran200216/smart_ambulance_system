import 'package:flutter/services.dart';

class HapticFeedbackUtilityService {
  /// Provides general vibration feedback.
  static void generalVibration() {
    HapticFeedback.vibrate();
  }

  /// Provides light impact feedback (e.g., for button presses).
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  /// Provides medium impact feedback (e.g., for toggles).
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  /// Provides heavy impact feedback (e.g., for drag-and-drop actions).
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  /// Provides selection click feedback (e.g., for dropdowns or pickers).
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
}