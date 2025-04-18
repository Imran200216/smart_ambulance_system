import 'package:flutter/material.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';

class EmployeeDetailsProvider with ChangeNotifier {
  String _fullName = '';
  String _email = '';
  String _empId = '';

  String get fullName => _fullName;
  String get email => _email;
  String get empId => _empId;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployeeDetails() async {
    final data = await EmployeeService().fetchEmployeeDetails();
    if (data != null) {
      _fullName = data['name'] ?? 'No Name';
      _email = data['email'] ?? 'No Email';
      _empId = data['empId'] ?? '';
    } else {
      _fullName = 'Unknown User';
      _email = 'Unknown Email';
      _empId = '';
    }
    _isLoading = false;
    notifyListeners();
  }
}
