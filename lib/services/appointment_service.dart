
import 'package:dio/dio.dart';
import 'package:icare/models/appointment.dart';
import 'package:icare/models/appointment_detail.dart';
import 'package:icare/services/api_service.dart';
import 'package:icare/services/standalone_care_hub_service.dart';

class AppointmentService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> bookAppointment({
    required String doctorId,
    required DateTime date,
    required String timeSlot,
    String? reason,
  }) async {
    try {
      final response = await _apiService.post(
        '/appointments/book_appointment',
        {
          'doctorId': doctorId,
          'date': date.toIso8601String(),
          'timeSlot': timeSlot,
          'reason': reason,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return {
        'success': true,
        'message': data['message'] ?? 'Appointment booked successfully',
        'appointment': data['appointment'] != null ? Appointment.fromJson(data['appointment']) : null,
      };
    } on DioException catch (_) {
      return _hub.bookAppointment(doctorId: doctorId, date: date, timeSlot: timeSlot, reason: reason);
    } catch (_) {
      return _hub.bookAppointment(doctorId: doctorId, date: date, timeSlot: timeSlot, reason: reason);
    }
  }

  Future<Map<String, dynamic>> getMyAppointmentsDetailed() async {
    try {
      final response = await _apiService.get('/appointments/getAppointments');
      final data = response.data as Map<String, dynamic>;
      final List<AppointmentDetail> appointments = [];
      if (data['appointments'] != null) {
        for (var appointmentJson in data['appointments']) {
          appointments.add(AppointmentDetail.fromJson(appointmentJson));
        }
      }
      return {
        'success': true,
        'appointments': appointments,
        'count': data['count'] ?? 0,
      };
    } on DioException catch (_) {
      return _hub.getMyAppointmentsDetailed();
    } catch (_) {
      return _hub.getMyAppointmentsDetailed();
    }
  }

  Future<Map<String, dynamic>> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      final response = await _apiService.put(
        '/appointments/update_status',
        {
          'appointmentId': appointmentId,
          'status': status,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return {
        'success': true,
        'message': data['message'] ?? 'Status updated successfully',
      };
    } on DioException catch (_) {
      return _hub.updateAppointmentStatus(appointmentId: appointmentId, status: status);
    } catch (_) {
      return _hub.updateAppointmentStatus(appointmentId: appointmentId, status: status);
    }
  }
}
