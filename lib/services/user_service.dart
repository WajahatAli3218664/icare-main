import 'package:dio/dio.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getUserProfile({String? token}) async {
    try {
      // Hostinger backend: /api/users/profile
      final response = await _apiService.get('/users/profile', token: token);
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        // Hostinger returns user directly, not nested
        final user = body['user'] ?? body['data']?['user'] ?? body;
        return {'success': true, 'user': user};
      }
      return {'success': false, 'message': 'Failed to fetch profile'};
    } on DioException catch (_) {
      return {'success': false, 'message': 'Profile fetch failed'};
    } catch (_) {
      return {'success': false, 'message': 'Profile fetch failed'};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phoneNumber,
    String? profilePicture,
  }) async {
    try {
      final response = await _apiService.put('/users/profile', {
        'name': name,
        'phoneNumber': phoneNumber,
        if (profilePicture != null) 'profilePicture': profilePicture,
      });
      if (response.statusCode == 200) {
        return {'success': true, 'user': response.data};
      }
      return {'success': false, 'message': 'Failed to update profile'};
    } on DioException catch (_) {
      return {'success': false, 'message': 'Failed to update profile'};
    } catch (_) {
      return {'success': false, 'message': 'Failed to update profile'};
    }
  }
}
