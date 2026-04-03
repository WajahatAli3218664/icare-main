
import 'package:dio/dio.dart';
import '../utils/shared_pref.dart';
import 'api_service.dart';
import 'api_config.dart';
import 'fcm_service.dart';
import 'standalone_care_hub_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final SharedPref _sharedPref = SharedPref();
  final StandaloneCareHubService _hub = StandaloneCareHubService();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phoneNumber,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        {
          'username': name,
          'email': email,
          'password': password,
          'role': role,
          'phone': phoneNumber ?? '',
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        // Backend returns { success, data: { token, user } }
        final token = data['data']?['token'] ?? data['token'];
        await _saveToken(token);
        return {'success': true, 'data': data['data'] ?? data};
      }
      return {'success': false, 'message': 'Registration failed'};
    } on DioException catch (e) {
      // Only fall back to standalone on network/connectivity errors, not server errors
      if (_isNetworkError(e)) {
        final fallback = await _hub.register(
          name: name,
          email: email,
          password: password,
          role: role,
          phoneNumber: phoneNumber,
        );
        if (fallback['success'] == true) {
          await _saveToken(fallback['data']['token']);
        }
        return fallback;
      }
      final msg = e.response?.data?['message'] ?? e.response?.data?['error'] ?? 'Registration failed (${e.response?.statusCode})';
      return {'success': false, 'message': msg};
    } catch (_) {
      final fallback = await _hub.register(
        name: name,
        email: email,
        password: password,
        role: role,
        phoneNumber: phoneNumber,
      );
      if (fallback['success'] == true) {
        await _saveToken(fallback['data']['token']);
      }
      return fallback;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('✅ Login response data: $data');
        // Backend returns { success, data: { token, user } }
        final inner = data['data'] ?? data;
        final token = inner['token']?.toString();
        if (token == null || token.isEmpty) {
          return {'success': false, 'message': 'No token received from server'};
        }
        await _saveToken(token);
        FcmService().getAndSaveToken();
        return {'success': true, 'data': inner};
      }
      final errData = response.data;
      return {'success': false, 'message': errData?['message'] ?? 'Login failed (${response.statusCode})'};
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        final fallback = await _hub.login(email: email, password: password);
        if (fallback['success'] == true) {
          await _saveToken(fallback['data']['token']);
          FcmService().getAndSaveToken();
        }
        return fallback;
      }
      final msg = e.response?.data?['message'] ?? e.response?.data?['error'] ?? 'Login failed (${e.response?.statusCode})';
      return {'success': false, 'message': msg};
    } catch (e) {
      print('❌ Login unexpected error: $e');
      if (e is DioException) {
        final msg = e.response?.data?['message'] ?? e.response?.data?['error'] ?? 'Login failed (${e.response?.statusCode})';
        return {'success': false, 'message': msg};
      }
      return {'success': false, 'message': 'An unexpected error occurred. Please try again.'};
    }
  }

  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.response == null;
  }

  Future<void> _saveToken(String token) async {
    await _sharedPref.setToken(token);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {}

  Future<String?> getToken() async {
    return await _sharedPref.getToken();
  }

  Future<void> logout() async {
    await _sharedPref.remove('token');
    await _sharedPref.remove('userData');
    await _sharedPref.remove('userRole');
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await _apiService.post(
        ApiConfig.forgetPassword,
        {'email': email},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'OTP sent to your email',
          'otp': response.data['otp'],
        };
      }
      return {'success': false, 'message': 'Failed to send OTP'};
    } on DioException catch (_) {
      return {
        'success': true,
        'message': 'Password reset is not connected to a live backend in standalone mode. Please use demo password Pass@123 or create a new account.',
      };
    } catch (_) {
      return {
        'success': true,
        'message': 'Password reset is not connected to a live backend in standalone mode. Please use demo password Pass@123 or create a new account.',
      };
    }
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.checkOTP,
        {'email': email, 'code': code},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'OTP verified successfully'};
      }
      return {'success': false, 'message': 'Invalid OTP'};
    } on DioException catch (_) {
      return {'success': true, 'message': 'OTP verification bypassed in standalone demo mode'};
    } catch (_) {
      return {'success': true, 'message': 'OTP verification bypassed in standalone demo mode'};
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.resetPassword,
        {
          'email': email,
          'password': password,
          'confirmpassword': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password reset successfully'};
      }
      return {'success': false, 'message': 'Failed to reset password'};
    } on DioException catch (_) {
      return {'success': true, 'message': 'Standalone mode does not persist password reset flows yet.'};
    } catch (_) {
      return {'success': true, 'message': 'Standalone mode does not persist password reset flows yet.'};
    }
  }
}
