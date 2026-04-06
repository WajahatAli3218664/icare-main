import 'package:icare/services/api_service.dart';

class InstructorService {
  final ApiService _apiService = ApiService();
  String? _cachedInstructorId;

  // Get instructor profile for logged-in instructor
  Future<Map<String, dynamic>> getMyProfile() async {
    final response = await _apiService.get('/instructors/me');
    final instructor = response.data['instructor'];
    _cachedInstructorId = instructor['_id'];
    return instructor;
  }

  // Update/Create instructor profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.post('/instructors/add_instructor_details', data);
    return response.data['instructor'] ?? response.data['existingProfile'];
  }

  // Get all instructors (public)
  Future<List<dynamic>> getAllInstructors() async {
    final response = await _apiService.get('/instructors/get_all_instructors');
    return response.data['instructors'] as List;
  }

  // Get instructor by ID
  Future<Map<String, dynamic>> getInstructorById(String id) async {
    final response = await _apiService.get('/instructors/$id');
    return response.data['instructor'];
  }

  Future<String> _getInstructorId() async {
    if (_cachedInstructorId != null) {
      return _cachedInstructorId!;
    }
    final profile = await getMyProfile();
    return profile['_id'];
  }

  // ═══════════════════════════════════════════════════════════════════════
  // COURSES MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════

  // Get my courses
  Future<List<dynamic>> getMyCourses() async {
    try {
      final instructorId = await _getInstructorId();
      final response = await _apiService.get('/instructors/courses?instructorId=$instructorId');
      return response.data['courses'] as List;
    } catch (e) {
      print('Error getting my courses: $e');
      rethrow;
    }
  }

  // Get all public courses
  Future<List<dynamic>> getAllCourses({String? visibility, String? search}) async {
    String url = '/instructors/courses';
    List<String> params = [];
    
    if (visibility != null) params.add('visibility=$visibility');
    if (search != null && search.isNotEmpty) params.add('q=${Uri.encodeComponent(search)}');
    
    if (params.isNotEmpty) url += '?${params.join('&')}';
    
    final response = await _apiService.get(url);
    return response.data['courses'] as List;
  }

  // Get course by ID
  Future<Map<String, dynamic>> getCourseById(String id) async {
    final response = await _apiService.get('/instructors/courses/$id');
    return response.data['course'];
  }

  // Create course
  Future<Map<String, dynamic>> createCourse(Map<String, dynamic> data) async {
    final response = await _apiService.post('/instructors/courses', data);
    return response.data['course'];
  }

  // Update course
  Future<Map<String, dynamic>> updateCourse(String id, Map<String, dynamic> data) async {
    final response = await _apiService.put('/instructors/courses/$id', data);
    return response.data['course'];
  }

  // Delete course
  Future<void> deleteCourse(String id) async {
    await _apiService.delete('/instructors/courses/$id');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PRECAUTIONS MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════

  // Get my precautions
  Future<List<dynamic>> getMyPrecautions() async {
    try {
      final instructorId = await _getInstructorId();
      final response = await _apiService.get('/instructors/precautions?instructorId=$instructorId');
      return response.data['precautions'] as List;
    } catch (e) {
      print('Error getting my precautions: $e');
      rethrow;
    }
  }

  // Get all precautions
  Future<List<dynamic>> getAllPrecautions({String? instructorId}) async {
    String url = '/instructors/precautions';
    if (instructorId != null) url += '?instructorId=$instructorId';
    
    final response = await _apiService.get(url);
    return response.data['precautions'] as List;
  }

  // Get precaution by ID
  Future<Map<String, dynamic>> getPrecautionById(String id) async {
    final response = await _apiService.get('/instructors/precautions/$id');
    return response.data['precaution'];
  }

  // Create precaution
  Future<Map<String, dynamic>> createPrecaution(Map<String, dynamic> data) async {
    final response = await _apiService.post('/instructors/precautions', data);
    return response.data['precaution'];
  }

  // Update precaution
  Future<Map<String, dynamic>> updatePrecaution(String id, Map<String, dynamic> data) async {
    final response = await _apiService.put('/instructors/precautions/$id', data);
    return response.data['precaution'];
  }

  // Delete precaution
  Future<void> deletePrecaution(String id) async {
    await _apiService.delete('/instructors/precautions/$id');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> getStats() async {
    try {
      final courses = await getMyCourses();
      final precautions = await getMyPrecautions();
      
      // Calculate stats from courses
      int totalCourses = courses.length;
      int publicCourses = courses.where((c) => c['visibility'] == 'public').length;
      
      // Mock student count (would need enrollment data from backend)
      int totalStudents = courses.fold<int>(0, (sum, _) => sum + 50); // Mock: 50 students per course
      
      return {
        'totalCourses': totalCourses,
        'publicCourses': publicCourses,
        'totalStudents': totalStudents,
        'totalPrecautions': precautions.length,
        'avgRating': 4.7, // Mock value - would need reviews system
        'revenue': 84000, // Mock value - would need payment system
      };
    } catch (e) {
      print('Error getting stats: $e');
      rethrow;
    }
  }
}
