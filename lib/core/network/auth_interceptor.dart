import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../storage/secure_storage_service.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.storage, this.onUnauthorized);

  final SecureStorageService storage;
  final Future<void> Function() onUnauthorized;
  final Logger _logger = Logger();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.read(AppConstants.authTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    _logger.i('API request: ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    _logger.e('API error: ${err.response?.statusCode} ${err.requestOptions.uri}');
    if (err.response?.statusCode == 401) {
      await storage.delete(AppConstants.authTokenKey);
      await storage.delete(AppConstants.userStorageKey);
      await onUnauthorized();
    }
    handler.next(err);
  }
}
