
import 'package:dio/dio.dart';
import 'api_service.dart';
import 'standalone_care_hub_service.dart';

class DoctorService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> getAllDoctors() async {
    try {
      final response = await _apiService.get('/doctors/get_all_doctors');
      if (response.statusCode == 200) {
        return {'success': true, 'doctors': response.data['doctors']};
      }
      return {'success': false, 'message': 'Failed to fetch doctors'};
    } on DioException catch (_) {
      final doctors = await _hub.getAllDoctors();
      return {'success': true, 'doctors': doctors};
    } catch (_) {
      final doctors = await _hub.getAllDoctors();
      return {'success': true, 'doctors': doctors};
    }
  }

  Future<Map<String, dynamic>> updateDoctorProfile({
    required String specialization,
    List<String>? consultationType,
    List<String>? languages,
    required List<String> degrees,
    required String experience,
    required String licenseNumber,
    required String clinicName,
    required String clinicAddress,
    required List<String> availableDays,
    required String startTime,
    required String endTime,
  }) async {
    final requestData = {
      'specialization': specialization,
      'degrees': degrees,
      'experience': experience,
      'licenseNumber': licenseNumber,
      'clinicName': clinicName,
      'clinicAddress': clinicAddress,
      'availableDays': availableDays,
      'availableTime': {
        'start': startTime,
        'end': endTime,
      },
      if (consultationType != null && consultationType.isNotEmpty) 'consultationType': consultationType,
      if (languages != null && languages.isNotEmpty) 'languages': languages,
    };
    try {
      final response = await _apiService.post('/doctors/add_doctor_details', requestData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Profile updated successfully'};
      }
      return {'success': false, 'message': 'Failed to update profile'};
    } on DioException catch (_) {
      return _hub.updateDoctorProfile(requestData);
    } catch (_) {
      return _hub.updateDoctorProfile(requestData);
    }
  }

  Future<Map<String, dynamic>> addDoctorReview({required String doctorId, required double rating, String? review}) async {
    try {
      final response = await _apiService.post('/doctors/$doctorId/reviews', {
        'rating': rating,
        if (review != null) 'review': review,
      });
      if (response.statusCode == 200) {
        return {'success': true, 'doctor': response.data['doctor']};
      }
      return {'success': false, 'message': 'Failed to add review'};
    } on DioException catch (_) {
      return _hub.addDoctorReview(doctorId: doctorId, rating: rating, review: review);
    } catch (_) {
      return _hub.addDoctorReview(doctorId: doctorId, rating: rating, review: review);
    }
  }

  Future<Map<String, dynamic>> getDoctorById(String doctorId) async {
    try {
      final response = await _apiService.get('/doctors/$doctorId');
      if (response.statusCode == 200) {
        return {'success': true, 'doctor': response.data['doctor']};
      }
      return {'success': false, 'message': 'Failed to fetch doctor'};
    } on DioException catch (_) {
      return {'success': true, 'doctor': await _hub.getDoctorById(doctorId)};
    } catch (_) {
      return {'success': true, 'doctor': await _hub.getDoctorById(doctorId)};
    }
  }

  Future<Map<String, dynamic>> filterDoctors({String? specialization, String? consultationType, String? language, double? minRating}) async {
    try {
      final queryParams = <String>[];
      if (specialization != null) queryParams.add('specialization=$specialization');
      if (consultationType != null) queryParams.add('consultationType=$consultationType');
      if (language != null) queryParams.add('language=$language');
      if (minRating != null) queryParams.add('minRating=$minRating');
      final queryString = queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
      final response = await _apiService.get('/doctors/filter$queryString');
      if (response.statusCode == 200) {
        return {'success': true, 'doctors': response.data['doctors']};
      }
      return {'success': false, 'message': 'Failed to filter doctors'};
    } on DioException catch (_) {
      return _hub.filterDoctors(specialization: specialization, consultationType: consultationType, language: language, minRating: minRating);
    } catch (_) {
      return _hub.filterDoctors(specialization: specialization, consultationType: consultationType, language: language, minRating: minRating);
    }
  }

  Future<Map<String, dynamic>> updateAvailability({required List<String> availableDays, required Map<String, String> availableTime, List<String>? unavailableDates}) async {
    try {
      final response = await _apiService.put('/doctors/availability', {
        'availableDays': availableDays,
        'availableTime': availableTime,
        if (unavailableDates != null) 'unavailableDates': unavailableDates,
      });
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Availability updated'};
      }
      return {'success': false, 'message': 'Failed to update availability'};
    } on DioException catch (_) {
      return _hub.updateAvailability(availableDays: availableDays, availableTime: availableTime, unavailableDates: unavailableDates);
    } catch (_) {
      return _hub.updateAvailability(availableDays: availableDays, availableTime: availableTime, unavailableDates: unavailableDates);
    }
  }

  Future<Map<String, dynamic>> getAvailability() async {
    try {
      final response = await _apiService.get('/doctors/availability/me');
      if (response.statusCode == 200) {
        return {'success': true, 'availability': response.data['availability']};
      }
      return {'success': false, 'message': 'Failed to fetch availability'};
    } on DioException catch (_) {
      return _hub.getAvailability();
    } catch (_) {
      return _hub.getAvailability();
    }
  }
}
