import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:storex/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    final statuscode = error.response?.statusCode;
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['Message'] != null) {
      return ApiError(message: data['Message'], statusCode: statuscode);
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Bad Connection".tr);
      case DioExceptionType.badResponse:
        return ApiError(message: error.toString());
      default:
        return ApiError(message: "Something went wrong".tr);
    }
  }
}
