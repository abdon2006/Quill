import 'package:dio/dio.dart';
import 'package:quill/core/errors/failures.dart';
import 'package:quill/core/network/auth_interceptor.dart';

/// GET  → query params  (بتطلب/بتفلتر)
/// POST → body data     (بتبعت/بتنشئ)
/// PUT  → body data     (بتستبدل كامل)
/// PATCH → body data    (بتعدل جزء)

class NetworkService {
  final AuthInterceptor authInterceptor;
  final Dio dio;
  NetworkService({required this.authInterceptor, required this.dio}) {
    dio.interceptors.add(authInterceptor);
  }

  Future<Response> dioPost(String endPoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.post(endPoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioErrors(e);
    }
  }

  Future<Response> dioGet(
    String endPoint,
    Map<String, dynamic> queryParams,
  ) async {
    try {
      final response = await dio.get(endPoint, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw _handleDioErrors(e);
    }
  }

  Future<Response> dioPut(String endPoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.put(endPoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioErrors(e);
    }
  }

  Future<Response> dioPatch(String endPoint, Map<String, dynamic> data) async {
    try {
      final response = await dio.patch(endPoint, data: data);
      return response;
    } on DioException catch (e) {
      throw _handleDioErrors(e);
    }
  }

  Failure _handleDioErrors(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const TimeoutFailure(message: 'Connection timeout');
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure(message: 'Server not responding');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ?? "SomeThing Went Wrong";
        if (statusCode == 401) {
          return const UnauthorizedFailure(message: 'Unauthorized');
        }
        return ServerFailure(message: message, statusCode: statusCode);
      default:
        return NetworkFailure(message: 'Network error');
    }
  }
}
