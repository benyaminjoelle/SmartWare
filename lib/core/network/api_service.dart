import 'package:dio/dio.dart';
import 'package:storex/core/constants/const_ip.dart';
import 'package:storex/core/network/api_error.dart';
import 'package:storex/core/utils/pref_helper.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio dio;

  ApiService._internal() {
    dio = Dio(
      BaseOptions(

        baseUrl: 'http://${ConstIp().ip}:8000/api',

        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
        },
        // Allow Dio to handle 4xx manually
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          final lang = await PrefHelper.getLanguage();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          options.headers['Accept-Language'] = lang;

          print('➡️ REQUEST [${options.method}] ${options.uri}');
          print('➡️ Headers: ${options.headers}');
          print('➡️ Data: ${options.data}');

          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE [${response.statusCode}] ${response.requestOptions.uri}');
          print('✅ Data: ${response.data}');
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ ERROR [${e.response?.statusCode}] ${e.requestOptions.uri}');
          print('❌ Data: ${e.response?.data}');
          handler.next(e);
        },
      ),
    );
  }

  // =========================
  // GET
  // =========================
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await dio.get(endpoint, queryParameters: queryParameters);

      if (response.statusCode == 401) {
        return ApiError(message: 'Unauthorized');
      }

      return response.data;
    } on DioException catch (e) {
      return ApiError(message: e.message ?? 'Network error');
    }
  }

  // =========================
  // POST (supports FormData)
  // =========================
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        options: body is FormData
            ? Options(
                headers: {
                  'Accept': 'application/json',
                },
              )
            : null,
      );

      if (response.statusCode == 401) {
        return ApiError(message: 'Unauthorized');
      }

      return response.data;
    } on DioException catch (e) {
      print('❌ STATUS CODE: ${e.response?.statusCode}');
      print('❌ RESPONSE DATA: ${e.response?.data}');
      print('❌ REQUEST DATA: ${e.requestOptions.data}');
      rethrow;
    }
  }

  // =========================
  // PUT
  // =========================
  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final response = await dio.put(endpoint, data: data);

      if (response.statusCode == 401) {
        return ApiError(message: 'Unauthorized');
      }

      return response.data;
    } on DioException catch (e) {
      return ApiError(message: e.message ?? 'Network error');
    }
  }

  // =========================
  // DELETE
  // =========================
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await dio.delete(endpoint);

      if (response.statusCode == 401) {
        return ApiError(message: 'Unauthorized');
      }

      return response.data;
    } on DioException catch (e) {
      return ApiError(message: e.message ?? 'Network error');
    }
  }
  // =========================
// PATCH
// =========================
Future<dynamic> patch(String endpoint, dynamic data) async {
  try {
    final response = await dio.patch(endpoint, data: data);

    if (response.statusCode == 401) {
      return ApiError(message: 'Unauthorized');
    }

    print('✅ PATCH RESPONSE [${response.statusCode}] ${response.requestOptions.uri}');
    print('✅ Data: ${response.data}');

    return response.data;
  } on DioException catch (e) {
    print('❌ PATCH ERROR [${e.response?.statusCode}] ${e.requestOptions.uri}');
    print('❌ Data: ${e.response?.data}');
    print('❌ Request Data: ${e.requestOptions.data}');
    return ApiError(message: e.message ?? 'Network error');
  }
}

}
