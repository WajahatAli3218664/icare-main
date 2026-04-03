enum UserRole {
  // Public roles (self-signup allowed)
  patient,
  doctor,

  // Admin-controlled roles (created by admin only)
  labTechnician,
  pharmacist,
  student,
  instructor,
  admin,
  superAdmin,
  security,

  unknown
}

// Role segregation helper
extension UserRoleExtension on UserRole {
  /// Returns true if this role can self-signup (Patient, Doctor)
  bool get isPublicRole {
    return this == UserRole.patient || this == UserRole.doctor;
  }

  /// Returns true if this role must be created by admin
  bool get isAdminControlledRole {
    return this == UserRole.labTechnician ||
           this == UserRole.pharmacist ||
           this == UserRole.student ||
           this == UserRole.instructor ||
           this == UserRole.admin ||
           this == UserRole.superAdmin ||
           this == UserRole.security;
  }

  /// Returns true if this role has admin privileges
  bool get hasAdminPrivileges {
    return this == UserRole.admin ||
           this == UserRole.superAdmin ||
           this == UserRole.security;
  }

  /// Returns user-friendly display name
  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.labTechnician:
        return 'Lab Technician';
      case UserRole.pharmacist:
        return 'Pharmacist';
      case UserRole.student:
        return 'Student';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.security:
        return 'Security';
      case UserRole.unknown:
        return 'Unknown';
    }
  }
}


enum BookingStatus {
  upcoming,
  cancelled,
  completed,
}

enum OrderType {
  recent,
  delivered,
  cancelled,
  inTransit,
}
