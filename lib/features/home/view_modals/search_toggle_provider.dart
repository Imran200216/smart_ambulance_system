import 'package:flutter/material.dart';

class SearchToggleProvider extends ChangeNotifier {
  bool _isSearching = false;

  bool get isSearching => _isSearching;

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    notifyListeners();
  }
}
