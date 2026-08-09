import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smartware/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    final statuscode = error.response?.statusCode;
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      return ApiError(message: data['message'], statusCode: statuscode);
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Bad Connection".tr);
      case DioExceptionType.badResponse:
        return ApiError(message: error.message ?? "Something went wrong".tr);
      default:
        return ApiError(message: "Something went wrong".tr);
    }
  }
}
// class ApiExceptions {
//   static ApiError handleError(DioException error) {
//     final data = error.response?.data;

//     return ApiError(
//       message: data is Map<String, dynamic>
//           ? (data['message'] ?? data['Message'] ?? "Something went wrong".tr)
//           : (error.message ?? "Something went wrong".tr),
//       statusCode: error.response?.statusCode,
//     );
//   }
// }