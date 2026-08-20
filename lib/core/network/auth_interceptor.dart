import 'package:dio/dio.dart';
import 'package:quill/features/discover/storage/app_storage.dart';

class AuthInterceptor extends Interceptor {
  final AppStorage appStorage;

  AuthInterceptor({required this.appStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await appStorage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
