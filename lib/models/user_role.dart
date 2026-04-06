import 'package:icare/models/app_enums.dart';

extension UserRoleMapper on String {
  UserRole toUserRole() {
    switch (toLowerCase()) {
      case 'patient':
        return UserRole.patient;
      case 'doctor':
        return UserRole.doctor;
      case 'lab_technician':
      case 'laboratory':
        return UserRole.labTechnician;
      case 'student':
        return UserRole.student;
      case 'pharmacist':
      case 'pharmacy':
        return UserRole.pharmacist;
      case 'instructor':
        return UserRole.instructor;
      case 'admin':
        return UserRole.admin;
      case 'superadmin':
      case 'super_admin':
        return UserRole.superAdmin;
      case 'security':
        return UserRole.security;
      default:
        return UserRole.unknown;
    }
  }

  /// Convert UserRole enum to backend string format
  String toBackendRole() {
    final role = toUserRole();
    switch (role) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.labTechnician:
        return 'Laboratory';
      case UserRole.pharmacist:
        return 'Pharmacy';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.student:
        return 'Student';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'SuperAdmin';
      case UserRole.security:
        return 'Security';
      default:
        return 'Patient';
    }
  }
}
