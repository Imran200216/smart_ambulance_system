class EmployeeModal {
  final String empId;
  final String empName;
  final String email;
  final String phoneNumber;

  EmployeeModal({
    required this.empId,
    required this.empName,
    required this.email,
    required this.phoneNumber,
  });

  /// Convert EmployeeModal to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'Employee Id': empId,
      'Employee Name': empName,
      'Employee email': email,
      'Employee Phone No': phoneNumber,
    };
  }

  /// Convert Firestore document to EmployeeModal
  factory EmployeeModal.fromJson(Map<String, dynamic> json) {
    return EmployeeModal(
      empId: json['Employee Id'] ?? '',
      empName: json['Employee Name'] ?? '',
      email: json['Employee email'] ?? '',
      phoneNumber: json['Employee Phone No'] ?? '',
    );
  }
}
