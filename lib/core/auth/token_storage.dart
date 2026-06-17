import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// JWT tokenlarni xavfsiz saqlash
/// 
/// Spec rule: JWT → flutter_secure_storage (SharedPreferences emas)
class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _tenantIdKey = 'tenant_id';
  static const _userDataKey = 'user_data';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  // ─── Access Token ───

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // ─── Refresh Token ───

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // ─── Tenant ID ───

  Future<String?> getTenantId() async {
    return await _storage.read(key: _tenantIdKey);
  }

  Future<void> setTenantId(String tenantId) async {
    await _storage.write(key: _tenantIdKey, value: tenantId);
  }

  // ─── User Data (JSON string) ───

  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  Future<void> setUserData(String userData) async {
    await _storage.write(key: _userDataKey, value: userData);
  }

  // ─── Tokens pair ───

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      setAccessToken(accessToken),
      setRefreshToken(refreshToken),
    ]);
  }

  /// Tokenlar mavjudligini tekshirish
  Future<bool> hasTokens() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Barcha tokenlarni o'chirish (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
