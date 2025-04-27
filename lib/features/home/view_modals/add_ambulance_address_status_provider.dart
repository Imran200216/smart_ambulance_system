import 'package:flutter/material.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';
import 'package:smart_ambulance_system/core/core_exports.dart';

class AddAmbulanceAddressStatusProvider extends ChangeNotifier {
  final AmbulanceStatusService _ambulanceService = AmbulanceStatusService();

  bool isSaving = false;

  Future<void> saveStatus({
    required String employeeEmail,
    required String employeeId,
    required String hospitalName,
    required String hospitalAddress,
    required BuildContext context,
  }) async {
    try {
      isSaving = true;
      notifyListeners();

      final AmbulanceStatusModel status = AmbulanceStatusModel(
        employeeEmail: employeeEmail,
        employeeId: employeeId,
        hospitalName: hospitalName,
        hospitalAddress: hospitalAddress,
      );

      await _ambulanceService.saveAmbulanceStatus(status);

      SnackBarHelper.showSnackBar(
        context: context,
        leadingIcon: Icons.local_hospital,
        message: "Ambulance status shared to Traffic police, you can proceed.",
      );
    } catch (e) {
      print('Error saving ambulance status: $e');
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
