import 'package:flutter/material.dart';

class ShowRouteToggleProvider extends ChangeNotifier {
  bool _showRouteInputFields = false;

  bool get showRouteInputFields => _showRouteInputFields;

  void toggleRouteFieldsVisibility() {
    _showRouteInputFields = !_showRouteInputFields;
    notifyListeners();
  }

  void setRouteFieldsVisibility(bool isVisible) {
    _showRouteInputFields = isVisible;
    notifyListeners();
  }
}
