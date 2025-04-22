import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';

class EmailLauncherProvider with ChangeNotifier {
  Future<void> sendEmail({
    required BuildContext context,
    required String mailId,
    required String subject,
    required String message,
  }) async {
    final Uri emailUri = Uri.parse(
      "mailto:$mailId?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.error,
        message: "No email app found on this device",
        backgroundColor: SnackBarHelper.errorColor,
      );
    }
  }
}
