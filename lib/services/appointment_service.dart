
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
          'doctorId': int.tryParse(doctorId) ?? doctorId,
          'date': date.toIso8601String(),
          'timeSlot': timeSlot,
          'reason': reason ?? '',
        },
      );
      final data = response.data as Map<String, dynamic>;
      return {
        'success': true,
        'message': data['message'] ?? 'Appointment booked successfully',
        'appointment': data['appointment'],
      };
    } on DioException catch (e) {
      final isNetwork = e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.response == null;
      if (isNetwork) {
        return _hub.bookAppointment(doctorId: doctorId, date: date, timeSlot: timeSlot, reason: reason);
      }
      final msg = e.response?.data?['message'] ?? 'Failed to book appointment (${e.response?.statusCode})';
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again.'};
    }
  }

  Future<Map<String, dynamic>> getMyAppointmentsDetailed() async {
    try {
      final response = await _apiService.get('/appointments/getAppointments');
      final data = response.data as Map<String, dynamic>;
      final List<AppointmentDetail> appointments = [];
      if (data['appointments'] != null) {
        for (var appointmentJson in data['appointments']) {
          try {
            appointments.add(AppointmentDetail.fromJson(appointmentJson));
          } catch (e) {
            print('⚠️ Skipping appointment parse error: $e | data: $appointmentJson');
          }
        }
      }
      return {
        'success': true,
        'appointments': appointments,
        'count': data['count'] ?? appointments.length,
      };
    } on DioException catch (e) {
      final isNetwork = e.response == null ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout;
      if (isNetwork) return _hub.getMyAppointmentsDetailed();
      return {'success': false, 'appointments': <AppointmentDetail>[], 'message': e.response?.data?['message'] ?? 'Failed to load appointments'};
    } catch (e) {
      print('❌ getMyAppointmentsDetailed error: $e');
      return {'success': false, 'appointments': <AppointmentDetail>[], 'message': e.toString()};
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
          'appointmentId': int.tryParse(appointmentId) ?? appointmentId,
          'status': status,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return {'success': true, 'message': data['message'] ?? 'Status updated successfully'};
    } on DioException catch (e) {
      final isNetwork = e.response == null ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout;
      if (isNetwork) return _hub.updateAppointmentStatus(appointmentId: appointmentId, status: status);
      return {'success': false, 'message': e.response?.data?['message'] ?? 'Failed to update status'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again.'};
    }
  }
}
