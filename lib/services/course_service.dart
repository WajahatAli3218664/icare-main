
import 'package:dio/dio.dart';
import 'api_service.dart';
import 'standalone_care_hub_service.dart';

class CourseService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<List<dynamic>> listPublicCourses() async {
    try {
      final response = await _apiService.get('/students/courses');
      return response.data['courses'] ?? [];
    } catch (_) {
      return _hub.listPublicCourses();
    }
  }

  Future<Map<String, dynamic>> getCourseDetails(String courseId) async {
    try {
      final response = await _apiService.get('/students/courses/$courseId');
      return response.data['course'];
    } catch (_) {
      return _hub.getCourseDetails(courseId);
    }
  }

  Future<Map<String, dynamic>> buyCourse(String courseId) async {
    try {
      final response = await _apiService.post('/students/courses/enrollments', {
        'courseId': courseId,
      });
      return response.data;
    } on DioException catch (_) {
      return _hub.buyCourse(courseId);
    } catch (_) {
      return _hub.buyCourse(courseId);
    }
  }

  Future<List<dynamic>> myPurchases() async {
    try {
      final response = await _apiService.get('/students/courses/enrollments/my');
      return response.data['items'] ?? response.data['enrollments'] ?? [];
    } catch (_) {
      return _hub.myPurchases();
    }
  }

  Future<Map<String, dynamic>> updateProgress(String enrollmentId, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put('/students/courses/enrollments/$enrollmentId/progress', data);
      return response.data;
    } catch (_) {
      return _hub.updateProgress(enrollmentId, data);
    }
  }

  Future<List<dynamic>> myCertificates() async {
    try {
      final response = await _apiService.get('/students/courses/certificates/my');
      return response.data['certificates'] ?? [];
    } catch (_) {
      return _hub.myCertificates();
    }
  }
}
