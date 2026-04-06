
import 'package:dio/dio.dart';
import 'api_service.dart';
import 'standalone_care_hub_service.dart';

class LaboratoryService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> getLabById(String labId) async {
    try {
      final response = await _apiService.get('/laboratories/$labId');
      return response.data['laboratory'];
    } catch (_) {
      return _hub.getLabById(labId);
    }
  }

  Future<List<dynamic>> getAllLaboratories() async {
    try {
      final response = await _apiService.get('/laboratories/get_all_laboratories');
      return response.data['laboratories'] ?? [];
    } catch (_) {
      return _hub.getAllLaboratories();
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get('/laboratories/profile');
      return response.data['laboratory'];
    } catch (_) {
      return _hub.getLabProfile();
    }
  }

  Future<Map<String, dynamic>> createBooking(String labId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/laboratories/$labId/bookings', data);
      return response.data['booking'];
    } catch (_) {
      return _hub.createLabBooking(labId, data);
    }
  }

  Future<List<dynamic>> getBookings(String labId, {String? status}) async {
    try {
      String url = '/laboratories/$labId/bookings';
      if (status != null) {
        url += '?status=$status';
      }
      final response = await _apiService.get(url);
      return response.data['bookings'] ?? [];
    } catch (_) {
      return _hub.getLabBookings(labId, status: status);
    }
  }

  Future<List<dynamic>> getMyBookings() async {
    try {
      final response = await _apiService.get('/laboratories/bookings/my');
      return response.data['bookings'] ?? [];
    } catch (_) {
      return _hub.getMyLabBookings();
    }
  }

  Future<Map<String, dynamic>> updateBooking(String bookingId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/laboratories/bookings/$bookingId', data);
      return response.data['booking'];
    } catch (_) {
      return _hub.updateLabBooking(bookingId, data);
    }
  }

  Future<Map<String, dynamic>> updateBookingStatus(String bookingId, String status) async {
    return updateBooking(bookingId, {'status': status});
  }

  Future<Map<String, dynamic>> getBookingById(String bookingId) async {
    try {
      final response = await _apiService.get('/laboratories/bookings/$bookingId');
      return response.data['booking'];
    } catch (_) {
      return _hub.getBookingById(bookingId);
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/laboratories/add_laboratory_details', data);
      return response.data['laboratory'] ?? response.data['existingProfile'];
    } catch (_) {
      return _hub.updateLabProfile(data);
    }
  }

  Future<Map<String, dynamic>> getDashboardStats(String labId) async {
    try {
      final bookings = await getBookings(labId);
      final totalBookings = bookings.length;
      final pendingBookings = bookings.where((b) => b['status'] == 'pending').length;
      final inProgressBookings = bookings.where((b) => b['status'] == 'confirmed' || b['status'] == 'in_progress').length;
      final completedBookings = bookings.where((b) => b['status'] == 'completed').length;
      final todayBookings = bookings.where((b) {
        final bookingDate = DateTime.tryParse(b['date'] ?? '') ?? DateTime.now();
        final today = DateTime.now();
        return bookingDate.year == today.year && bookingDate.month == today.month && bookingDate.day == today.day;
      }).length;
      final sortedBookings = List<dynamic>.from(bookings);
      sortedBookings.sort((a, b) {
        final dateA = DateTime.tryParse(a['createdAt'] ?? a['date'] ?? '') ?? DateTime.now();
        final dateB = DateTime.tryParse(b['createdAt'] ?? b['date'] ?? '') ?? DateTime.now();
        return dateB.compareTo(dateA);
      });
      return {
        'totalBookings': totalBookings,
        'pendingBookings': pendingBookings,
        'inProgressBookings': inProgressBookings,
        'completedBookings': completedBookings,
        'todayBookings': todayBookings,
        'recentActivity': sortedBookings.take(10).toList(),
      };
    } catch (_) {
      return _hub.getLabDashboardStats(labId);
    }
  }

  Future<String> uploadReport(String bookingId, List<int> bytes, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'report': MultipartFile.fromBytes(bytes, filename: fileName),
      });
      final response = await _apiService.postMultipart('/laboratories/bookings/$bookingId/upload-report', formData);
      return response.data['reportUrl'];
    } catch (_) {
      return _hub.uploadLabReport(bookingId, fileName);
    }
  }
}
