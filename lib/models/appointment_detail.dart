import 'package:icare/models/user.dart';

class AppointmentDetail {
  final String id;
  final User? doctor;
  final User? patient;
  final DateTime date;
  final String timeSlot;
  final String? reason;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentDetail({
    required this.id,
    this.doctor,
    this.patient,
    required this.date,
    required this.timeSlot,
    this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    User? doctor;
    User? patient;

    // Backend returns flat SQL columns: doctor_id, doctor_name, doctor_email
    // Standalone returns nested: doctor: { _id, name, ... }
    try {
      if (json['doctor'] != null && json['doctor'] is Map) {
        doctor = User.fromJson(json['doctor'] as Map<String, dynamic>);
      } else if (json['doctor_id'] != null) {
        doctor = User.fromJson({
          'id': json['doctor_id'],
          'name': json['doctor_name'] ?? 'Doctor',
          'email': json['doctor_email'] ?? '',
          'phone': json['doctor_phone'] ?? '',
          'role': 'doctor',
        });
      }
    } catch (e) {
      print('⚠️ Error parsing doctor: $e');
    }

    try {
      if (json['patient'] != null && json['patient'] is Map) {
        patient = User.fromJson(json['patient'] as Map<String, dynamic>);
      } else if (json['patient_id'] != null) {
        patient = User.fromJson({
          'id': json['patient_id'],
          'name': json['patient_name'] ?? 'Patient',
          'email': json['patient_email'] ?? '',
          'phone': json['patient_phone'] ?? '',
          'role': 'patient',
        });
      }
    } catch (e) {
      print('⚠️ Error parsing patient: $e');
    }

    // Backend uses appointment_date + appointment_time, standalone uses date + timeSlot
    final rawDate = json['appointment_date'] ?? json['date'];
    final rawTime = json['appointment_time'] ?? json['timeSlot'] ?? '';
    final now = DateTime.now().toIso8601String();

    return AppointmentDetail(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      doctor: doctor,
      patient: patient,
      date: DateTime.parse(rawDate is String ? rawDate : rawDate.toString()),
      timeSlot: rawTime,
      reason: json['reason'] ?? json['notes'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt'] ?? now),
      updatedAt: DateTime.parse(json['updated_at'] ?? json['updatedAt'] ?? now),
    );
  }

  String get doctorName => doctor?.name ?? 'Doctor';
  String get doctorEmail => doctor?.email ?? 'N/A';
}

