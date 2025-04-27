import 'package:cloud_firestore/cloud_firestore.dart';

class AmbulanceStatusModel {
  final String employeeEmail;
  final String employeeId;
  final String hospitalName;
  final String hospitalAddress;
  final bool isAmbulanceDriverSelectedHospital;

  AmbulanceStatusModel({
    required this.employeeEmail,
    required this.employeeId,
    required this.hospitalName,
    required this.hospitalAddress,
    this.isAmbulanceDriverSelectedHospital = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeEmail': employeeEmail,
      'employeeId': employeeId,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'isAmbulanceDriverSelectedHospital': isAmbulanceDriverSelectedHospital,
      'timestamp': FieldValue.serverTimestamp(), // optional: save when they started
    };
  }
}
