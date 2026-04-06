import 'package:dio/dio.dart';
import '../utils/shared_pref.dart';
import 'api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _setupInterceptors();
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status! < 500,
    ),
  );
  final SharedPref _sharedPref = SharedPref();

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🌐 REQUEST[${options.method}] => ${options.uri}');
          print('📤 Headers: ${options.headers}');
          print('📤 Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
          print('📥 Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ ERROR[${e.response?.statusCode}] => ${e.requestOptions.uri}');
          print('❌ Error Type: ${e.type}');
          print('❌ Error Message: ${e.message}');
          print('❌ Response: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _setAuthToken({String? providedToken}) async {
    String? token = providedToken;

    if (token == null) {
      token = await _sharedPref.getToken();
      print(
        "🔑 ApiService: Token from SharedPref: ${token != null ? '${token.substring(0, 20)}...' : 'null'}",
      );
    } else {
      print(
        "🔑 ApiService: Using provided token: ${token.substring(0, 20)}...",
      );
    }
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      print("✅ ApiService: Authorization header set");
    } else {
      print("⚠️ ApiService: No token found, request will be unauthorized");
    }
  }

  Future<Response> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    await _setAuthToken(providedToken: token);
    return await _dio.post(endpoint, data: data);
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    await _setAuthToken(providedToken: token);
    return await _dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> put(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    await _setAuthToken(providedToken: token);
    return await _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {String? token}) async {
    await _setAuthToken(providedToken: token);
    return await _dio.delete(endpoint);
  }

  // Support for file uploads
  Future<Response> postMultipart(
    String endpoint,
    FormData formData, {
    String? token,
  }) async {
    await _setAuthToken(providedToken: token);
    return await _dio.post(
      endpoint,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}
