import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches the employee email, name, and empId from Firestore.
  Future<Map<String, String>?> fetchEmployeeDetails() async {
    try {
      final User? currentUser = _auth.currentUser;
      final String email = currentUser?.email ?? "";

      if (email.isEmpty) {
        return null;
      }

      final querySnapshot = await _firestore
          .collection('users')
          .where('Employee email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final name = doc['Employee Name'] as String;
        final empId = doc['Employee ID'] as String;

        return {
          'email': email,
          'name': name,
          'empId': empId,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
