import 'package:dio/dio.dart';
import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/utils/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://${ConstIp().ip}:8000/api',

      headers: {
        //  "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final lang = await PrefHelper.getLanguage();
          options.headers['Accept-Language'] = lang;

          print('➡️ [DioClient] Request: ${options.method} ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ [DioClient] Response: ${response.statusCode}');
          print('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (e, handler) {
          print('❌ [DioClient] Error: ${e.response?.statusCode}');
          print('Data: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
