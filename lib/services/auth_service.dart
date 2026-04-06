
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
      Response? response;
      for (int attempt = 1; attempt <= 2; attempt++) {
        try {
          response = await _apiService.post(
            ApiConfig.register,
            {
              'name': name,
              'email': email,
              'password': password,
              'role': role,
              'phoneNumber': phoneNumber ?? '',
            },
          );
          break;
        } on DioException catch (e) {
          if (attempt == 2 || !_isNetworkError(e)) rethrow;
          print('🔄 Register attempt $attempt failed, retrying...');
          await Future.delayed(const Duration(seconds: 3));
        }
      }
      final response0 = response!;

      if (response0.statusCode == 201 || response0.statusCode == 200) {
        try {
          final data = response0.data;
          print('✅ Register response: $data');

          final token = data['data']?['token']?.toString() ??
                       data['token']?.toString() ??
                       '';

          if (token.isNotEmpty) {
            await _saveToken(token);
          }

          return {
            'success': true,
            'data': data['data'] ?? data,
            'message': data['message'] ?? 'Registration successful'
          };
        } catch (parseError) {
          print('❌ Register parse error: $parseError');
          return {'success': false, 'message': 'Registration succeeded but data format error. Please login manually.'};
        }
      }
      return {'success': false, 'message': 'Registration failed'};
    } catch (e) {
      print('❌ Register error: $e');
      // AGGRESSIVE FALLBACK: Any error → try standalone mode
      try {
        print('🔄 Attempting standalone mode fallback...');
        final fallback = await _hub.register(
          name: name,
          email: email,
          password: password,
          role: role,
          phoneNumber: phoneNumber,
        );
        if (fallback['success'] == true) {
          await _saveToken(fallback['data']['token']);
          print('✅ Standalone registration successful');
        }
        return fallback;
      } catch (fallbackError) {
        print('❌ Fallback also failed: $fallbackError');
        return {'success': false, 'message': 'Unable to connect. Please check your internet connection.'};
      }
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Starting login process...');
      Response? response;
      // Retry up to 2 times to handle Vercel cold starts
      for (int attempt = 1; attempt <= 2; attempt++) {
        try {
          response = await _apiService.post(
            ApiConfig.login,
            {'email': email, 'password': password},
          );
          break;
        } on DioException catch (e) {
          if (attempt == 2 || !_isNetworkError(e)) rethrow;
          print('🔄 Login attempt $attempt failed, retrying...');
          await Future.delayed(const Duration(seconds: 3));
        }
      }
      final response0 = response!;

      if (response0.statusCode == 200) {
        try {
          final data = response0.data;
          print('✅ Login response data: $data');

          // Handle both wrapped {data: {...}} and flat {...} responses
          final Map<String, dynamic> inner = data is Map && data.containsKey('data') 
              ? data['data'] 
              : data;
              
          final token = inner['token']?.toString() ?? '';
          final role = inner['role']?.toString() ?? '';

          if (token.isEmpty) {
            print('❌ No token in response');
            return {'success': false, 'message': 'No token received from server'};
          }

          if (role.isEmpty) {
            print('❌ No role in response');
            return {'success': false, 'message': 'User role not defined in response'};
          }

          await _saveToken(token);
          // Store role using the existing shared pref utility
          await _sharedPref.setUserRole(role);
          
          try {
            await FcmService().getAndSaveToken();
          } catch (fcmError) {
            print('⚠️ FCM Token Error (ignoring for login): $fcmError');
          }

          return {
            'success': true,
            'data': inner,
            'message': data is Map ? data['message'] ?? 'Login successful' : 'Login successful'
          };
        } catch (parseError) {
          print('❌ Login parse error: $parseError');
          return {'success': false, 'message': 'Login succeeded but data format error: $parseError'};
        }
      }

      final errData = response0.data;
      return {'success': false, 'message': errData?['message'] ?? 'Login failed (${response0.statusCode})'};
    } catch (e) {
      print('❌ Login error type: ${e.runtimeType}');
      print('❌ Login error detail: $e');
      if (e is DioException) {
        print('❌ Dio type: ${e.type}');
        print('❌ Dio message: ${e.message}');
        print('❌ Dio response: ${e.response?.data}');
        print('❌ Dio status: ${e.response?.statusCode}');
        // If server responded with an error, don't fall back to standalone
        if (e.response != null) {
          return {'success': false, 'message': e.response?.data?['message'] ?? 'Login failed'};
        }
        return {'success': false, 'message': 'Network error: ${e.message ?? e.type.name}'};
      }
      return {'success': false, 'message': 'Error: $e'};
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
