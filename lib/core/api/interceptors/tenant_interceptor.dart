import 'package:dio/dio.dart';
import '../../auth/token_storage.dart';

/// Tenant interceptor — har bir requestga X-Tenant-ID header qo'shadi
/// Multi-tenant tizimi uchun — server qaysi schemani ishlatishini aniqlaydi
class TenantInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  TenantInterceptor({required TokenStorage tokenStorage})
      : _tokenStorage = tokenStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final tenantId = await _tokenStorage.getTenantId();
    if (tenantId != null && tenantId.isNotEmpty) {
      options.headers['X-Tenant-ID'] = tenantId;
    }
    handler.next(options);
  }
}
