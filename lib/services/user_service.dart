
import 'package:dio/dio.dart';
import 'api_service.dart';
import 'api_config.dart';
import 'standalone_care_hub_service.dart';

class UserService {
  final ApiService _apiService = ApiService();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> getUserProfile({String? token}) async {
    try {
      final response = await _apiService.get('/users/profile', token: token);
      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final user = body['user'] ?? body['data']?['user'] ?? body;
        return {'success': true, 'user': user};
      }
      return {'success': false, 'message': 'Failed to fetch profile'};
    } on DioException catch (e) {
      // Only fall back to standalone on network errors, not auth/server errors
      final isNetwork = e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.response == null;
      if (isNetwork) {
        return _hub.getUserProfile(token: token);
      }
      // For 401/403/404 etc, return failure so caller can handle it
      return {'success': false, 'message': 'Profile fetch failed (${e.response?.statusCode})'};
    } catch (_) {
      return _hub.getUserProfile(token: token);
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
      return _hub.updateUserProfile(name: name, phoneNumber: phoneNumber, profilePicture: profilePicture);
    } catch (_) {
      return _hub.updateUserProfile(name: name, phoneNumber: phoneNumber, profilePicture: profilePicture);
    }
  }
}
