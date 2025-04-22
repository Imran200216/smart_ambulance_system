import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider with ChangeNotifier {
  String _version = 'Version 1.0.0';

  String get version => _version;

  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _version = 'Version ${packageInfo.version}';
    notifyListeners();
  }
}
