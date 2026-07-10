import 'package:dio/dio.dart';
import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/features/auth/models/user_model.dart';

class AuthRepo {
  final ApiService _api = ApiService();
  final baseUrl = 'http://${ConstIp().ip}:8000';

  Future<UserModel> managerRegister(Map<String, dynamic> userData) async {
    try {
      print('════════ REGISTER START ════════');
      print('📤 Request Data:');
      print(userData);

      final response = await _api.post(
        'http://${ConstIp().ip}:8000/api/register-manager',
        FormData.fromMap(userData),
      );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        print('❌ ApiError returned from ApiService');
        print('❌ Message: ${response.message}');
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        print('❌ Response is not a Map');
        print('❌ Runtime Type: ${response.runtimeType}');

        throw ApiError(message: 'Invalid response from server');
      }

      print('✅ Response Keys: ${response.keys.toList()}');

      final userJson = response['user'];

      print('👤 User JSON:');
      print(userJson);

      if (userJson == null) {
        print('❌ user key is NULL');
        print('❌ Full Response: $response');

        throw ApiError(message: response['message'] ?? 'User data not found');
      }

      final user = UserModel.fromJson(userJson);

      print('✅ User Parsed Successfully');
      print('🆔 ID: ${user.id}');
      print('📧 Email: ${user.email}');
      print('👤 Name: ${user.firstName} ${user.lastName}');
      print('📱 Phone: ${user.phoneNumber}');
      print('🎭 Role: ${user.role}');
      print('════════ REGISTER SUCCESS ════════');

      return user;
    } on DioException catch (e) {
      print('════════ REGISTER DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('❌ Request Data: ${e.requestOptions.data}');
      print('═══════════════════════════════════');

      throw ApiError(
        message: e.response?.data?['message'] ?? 'Registration failed',
      );
    } catch (e, stackTrace) {
      print('════════ REGISTER ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace:');
      print(stackTrace);
      print('════════════════════════════════');

      if (e is ApiError) rethrow;

      throw ApiError(message: 'Registration failed');
    }
  }

  Future<UserModel> clientRegister(Map<String, dynamic> userData) async {
    try {
      print('════════ REGISTER START ════════');
      print('📤 Request Data:');
      print(userData);

      final response = await _api.post(
        'http://${ConstIp().ip}:8000/api/register-client',
        FormData.fromMap(userData),
      );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        print('❌ ApiError returned from ApiService');
        print('❌ Message: ${response.message}');
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        print('❌ Response is not a Map');
        print('❌ Runtime Type: ${response.runtimeType}');

        throw ApiError(message: 'Invalid response from server');
      }

      print('✅ Response Keys: ${response.keys.toList()}');

      final userJson = response['user'];

      print('👤 User JSON:');
      print(userJson);

      if (userJson == null) {
        print('❌ user key is NULL');
        print('❌ Full Response: $response');

        throw ApiError(message: response['message'] ?? 'User data not found');
      }

      final user = UserModel.fromJson(userJson);

      print('✅ User Parsed Successfully');
      print('🆔 ID: ${user.id}');
      print('📧 Email: ${user.email}');
      print('👤 Name: ${user.firstName} ${user.lastName}');
      print('📱 Phone: ${user.phoneNumber}');
      print('📱 Phone: ${user.businessName}');
      print('🎭 Role: ${user.role}');
      print('════════ REGISTER SUCCESS ════════');

      return user;
    } on DioException catch (e) {
      print('════════ REGISTER DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('❌ Request Data: ${e.requestOptions.data}');
      print('═══════════════════════════════════');

      throw ApiError(
        message: e.response?.data?['message'] ?? 'Registration failed',
      );
    } catch (e, stackTrace) {
      print('════════ REGISTER ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace:');
      print(stackTrace);
      print('════════════════════════════════');

      if (e is ApiError) rethrow;

      throw ApiError(message: 'Registration failed');
    }
  }

  Future<UserModel> workerRegister(Map<String, dynamic> userData) async {
    try {
      print('════════ REGISTER START ════════');
      print('📤 Request Data:');
      print(userData);

      final response = await _api.post(
        'http://${ConstIp().ip}:8000/api/register-worker',
        FormData.fromMap(userData),
      );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        print('❌ ApiError returned from ApiService');
        print('❌ Message: ${response.message}');
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        print('❌ Response is not a Map');
        print('❌ Runtime Type: ${response.runtimeType}');

        throw ApiError(message: 'Invalid response from server');
      }

      print('✅ Response Keys: ${response.keys.toList()}');

      final userJson = response['user'];

      print('👤 User JSON:');
      print(userJson);

      if (userJson == null) {
        print('❌ user key is NULL');
        print('❌ Full Response: $response');

        throw ApiError(message: response['message'] ?? 'User data not found');
      }

      final user = UserModel.fromJson(userJson);

      print('✅ User Parsed Successfully');
      print('🆔 ID: ${user.id}');
      print('📧 Email: ${user.email}');
      print('👤 Name: ${user.firstName} ${user.lastName}');
      print('📱 Phone: ${user.phoneNumber}');
      print('📱 Phone: ${user.businessName}');
      print('📱 Phone: ${user.nationalId}');
      print('🎭 Role: ${user.role}');
      print('════════ REGISTER SUCCESS ════════');

      return user;
    } on DioException catch (e) {
      print('════════ REGISTER DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('❌ Request Data: ${e.requestOptions.data}');
      print('═══════════════════════════════════');

      throw ApiError(
        message: e.response?.data?['message'] ?? 'Registration failed',
      );
    } catch (e, stackTrace) {
      print('════════ REGISTER ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace:');
      print(stackTrace);
      print('════════════════════════════════');

      if (e is ApiError) rethrow;

      throw ApiError(message: 'Registration failed');
    }
  }

  ///========================LOGIN============================
  Future<UserModel> login({
    required String
    loginIdentifier, // Can be phone number based on spec example
    required String password,
  }) async {
    try {
      print('════════ STANDARD LOGIN START ════════');

      // Must be Multipart/Form-Data as specified by OpenAPI
      final FormData formData = FormData.fromMap({
        'login': loginIdentifier,
        'password': password,
      });

      final response = await _api.post('$baseUrl/api/login', formData);
      print('📥 Raw Response: $response');

      if (response is ApiError) throw response;
      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid response from server');
      }

      final userJson = response['user'];
      final token = response['token'];

      if (userJson == null) {
        throw ApiError(message: response['message'] ?? 'User data not found');
      }

      return UserModel.fromJson(userJson, token: token);
    } on DioException catch (e) {
      throw ApiError(message: e.response?.data?['message'] ?? 'Login failed');
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Login failed');
    }
  }

  ///=================VERIFIED LOGIN=========================???
  Future<UserModel> verifiedLogin({
    required String email,
    required String password,
  }) async {
    try {
      print('════════ VERIFIED LOGIN START ════════');

   final FormData formData = FormData.fromMap({
    'login': email.trim(),
    'password': password,
   });

    print('📤 Request Data (Form Data): email = ${email.trim()}');

    final response = await _api.post(
      '$baseUrl/api/email/verified-login',
      formData,
    );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        print('❌ ApiError returned from ApiService');
        print('❌ Message: ${response.message}');
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        print('❌ Response is not a Map');
        print('❌ Runtime Type: ${response.runtimeType}');

        throw ApiError(message: 'Invalid response from server');
      }

      print('✅ Response Keys: ${response.keys.toList()}');

      final userJson = response['user'];
      final token = response['token'];

      print('👤 User JSON:');
      print(userJson);

      print('🔑 Token: $token');

      if (userJson == null) {
        throw ApiError(message: response['message'] ?? 'User data not found');
      }

      final user = UserModel.fromJson(userJson, token: token);

      print('✅ Login Successful');
      print('🆔 ID: ${user.id}');
      print('📧 Email: ${user.email}');
      print('🎭 Role: ${user.role}');
      print('🔑 Token Saved');
      print('════════ VERIFIED LOGIN SUCCESS ════════');

      return user;
    } on DioException catch (e) {
      print('════════ VERIFIED LOGIN DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('═════════════════════════════════════════');

      throw ApiError(
        message: e.response?.data?['message'] ?? 'Verification login failed',
      );
    } catch (e, stackTrace) {
      print('════════ VERIFIED LOGIN ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print(stackTrace);
      print('══════════════════════════════════════');

      if (e is ApiError) rethrow;

      throw ApiError(message: 'Verification login failed');
    }
  }

  ///============================================================
  Future<void> resendVerificationEmail({required String email}) async {
    try {
      print('════════ RESEND EMAIL START ════════');

      final requestData = {'email': email};

      print('📤 Request Data:');
      print(requestData);

      final response = await _api.post(
        'http://${ConstIp().ip}:8000/api/email/resend',
        requestData,
      );

      print('📥 Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      print('════════ RESEND EMAIL SUCCESS ════════');
    } on DioException catch (e) {
      print('════════ RESEND EMAIL DIO ERROR ════════');
      print(e.response?.data);

      throw ApiError(
        message: e.response?.data?['message'] ?? 'Failed to resend email',
      );
    } catch (e) {
      print('════════ RESEND EMAIL ERROR ════════');
      print(e);

      if (e is ApiError) rethrow;

      throw ApiError(message: 'Failed to resend email');
    }
  }

///==================cHANGE EMAIL======================
Future<void> changeEmail({
  required int userId,
  required String email,
}) async {
  try {
    print('════════ CHANGE EMAIL START ════════');

    final FormData formData = FormData.fromMap({
      'email': email.trim(),
    });

    print('📤 Request Data (Form Data): email = ${email.trim()} to ID: $userId');

    final response = await _api.post(
      'http://${ConstIp().ip}:8000/api/email/change/$userId',
      formData,
    );

    print('📥 Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    print('════════ CHANGE EMAIL SUCCESS ════════');
  } catch (e) {
    print('════════ CHANGE EMAIL ERROR ════════');
    print(e);

    if (e is ApiError) rethrow;

    throw ApiError(
      message: 'Failed to change email',
    );
  }
}
///=============================================================




///=================FORGOT PASSWORD======================
///==================1st screen==================
   Future<Map<String,dynamic>> sendPasswordResetEmail ({
    required String email,
   }) async {
    try {
      print('════════ FORGOT PASSWORD START ════════');

      final FormData formData = FormData.fromMap({
        'email': email.trim(),
      });

    print('📤 Requesting reset link for email: ${email.trim()}');

    final response = await _api.post('$baseUrl/api/password/forgot', formData);

    print('📥 Response: $response');

    if (response is ApiError) throw response;

      print('════════ FORGOT PASSWORD SUCCESS ════════');
      return response;
    } catch (e) {
      print('════════ FORGOT PASSWORD ERROR ════════');
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to send password reset email');
    }
   }

 
///=================2nd screen=====================
  Future<Map<String,dynamic>> verifyResetToken({
    required String token,
    required String email,
  }) async {
    try{
      print('════════ VERIFY RESET TOKEN START ════════');
      print('📤 Query Params -> Email: $email | Token: $token');


      final response = await _api.get(
        '$baseUrl/api/password/reset',
        queryParameters: {
          'token': token,
          'email': email.trim(),
        },
      );

      print ('📥 Response: $response');

      if (response is ApiError) throw response;

      print('════════ VERIFY RESET TOKEN SUCCESS ════════');
      return response;
    } catch (e) {
      print('════════ VERIFY RESET TOKEN ERROR ════════');
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Link validation or reset request failed');
    }
  }
  ///====================3rd screen=========================
    Future<Map<String, dynamic>> changePassword ({
    required String newPassword,
    required String confirmPassword,
   }) async {
    try {
      print('════════ CHANGE PASSWORD START ════════');

      final FormData formData = FormData.fromMap({
        'current_password': newPassword,
        'new_password': confirmPassword,
      });
      print('📤 Submitting password alteration request...');

      final response = await _api.post('$baseUrl/api/password/change',
        formData,
        );
      print('📥 Response: $response');
      if (response is ApiError) throw response;

      print('════════ CHANGE PASSWORD SUCCESS ════════');
      return response;

    } catch (e) {
      print('════════ CHANGE PASSWORD ERROR ════════');
      if (e is ApiError) rethrow;
      throw ApiError(message: 'Failed to alter account password');
    }
   }
}
