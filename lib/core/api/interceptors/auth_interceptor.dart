import 'package:dio/dio.dart';
import '../../auth/token_storage.dart';

/// JWT interceptor — har bir requestga token qo'shadi
/// 401 bo'lsa — auto refresh + retry
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Public endpointlar uchun token qo'shmaslik
    if (_isPublicEndpoint(options.path)) {
      handler.next(options);
      return;
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Token yangilandi — asl requestni qayta yuborish
          final newToken = await _tokenStorage.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(err.requestOptions);
          _isRefreshing = false;
          handler.resolve(response);
          return;
        }
      } catch (_) {
        // Refresh ham xato — login sahifasiga yo'naltirish
      }
      _isRefreshing = false;
      await _tokenStorage.clearAll();
    }
    handler.next(err);
  }

  /// Refresh token orqali yangi access token olish
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      // Interceptorsiz yangi Dio instance — loop oldini olish uchun
      final refreshDio = Dio(BaseOptions(
        baseUrl: _dio.options.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ));

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'],
          refreshToken: data['refreshToken'],
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Public endpointlarni tekshirish (token kerak emas)
  bool _isPublicEndpoint(String path) {
    const publicPaths = ['/auth/login', '/auth/register-owner', '/auth/refresh'];
    return publicPaths.any((p) => path.contains(p));
  }
}
