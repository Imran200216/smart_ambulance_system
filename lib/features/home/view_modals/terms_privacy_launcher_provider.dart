import 'package:flutter/material.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsPrivacyLauncherProvider with ChangeNotifier {
  Future<void> launchTermsOrPrivacy({
    required BuildContext context,
    required String url,
  }) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.error,
        message: "Could not open the link.",
        backgroundColor: SnackBarHelper.errorColor,
      );
    }
  }
}
