import 'package:dio/dio.dart';
import '../../core/auth/token_storage.dart';
import '../../core/config/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/tenant_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Dio HTTP client — barcha API calllar shu orqali
class DioClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  final AppConfig _config;

  DioClient({
    required TokenStorage tokenStorage,
    required AppConfig config,
  })  : _tokenStorage = tokenStorage,
        _config = config {
    _dio = _createDio();
  }

  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage: _tokenStorage, dio: dio),
      TenantInterceptor(tokenStorage: _tokenStorage),
      ErrorInterceptor(),
      if (_config.isDebug)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => print('🌐 $obj'),
        ),
    ]);

    return dio;
  }
}
