import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_ambulance_system/features/home/home_exports.dart';

class AmbulanceStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveAmbulanceStatus(AmbulanceStatusModel status) async {
    await _firestore.collection('ambulance_status').add(status.toMap());
  }
}
