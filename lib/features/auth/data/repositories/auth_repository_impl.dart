import '../../domain/entities/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_models.dart';
import '../sources/auth_remote_source.dart';
import '../../../../core/api/api_result.dart';
import '../../../../core/auth/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Auth repository implementatsiyasi
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final TokenStorage _tokenStorage;
  final FlutterSecureStorage _secureStorage;

  UserSession? _cachedSession;

  AuthRepositoryImpl({
    required AuthRemoteSource remoteSource,
    required TokenStorage tokenStorage,
    FlutterSecureStorage? secureStorage,
  })  : _remoteSource = remoteSource,
        _tokenStorage = tokenStorage,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<ApiResult<UserSession>> registerOwner({
    required String fullName,
    required String phone,
    required String password,
    required String businessName,
  }) async {
    try {
      final response = await _remoteSource.registerOwner(
        fullName: fullName,
        phone: phone,
        password: password,
        businessName: businessName,
      );

      // Tokenlarni saqlash
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Tenant ID ni saqlash
      await _tokenStorage.setTenantId(response.user.tenantId);

      // User datani saqlash
      await _tokenStorage.setUserData(response.user.toJsonString());

      final session = response.user.toEntity();
      _cachedSession = session;

      return ApiResult.success(session);
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<UserSession>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _remoteSource.login(
        phone: phone,
        password: password,
      );

      // Tokenlarni saqlash
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      // Tenant ID ni saqlash
      await _tokenStorage.setTenantId(response.user.tenantId);

      // User datani saqlash
      await _tokenStorage.setUserData(response.user.toJsonString());

      final session = response.user.toEntity();
      _cachedSession = session;

      return ApiResult.success(session);
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<UserSession>> loginWithPin(String pin) async {
    try {
      final savedPin = await _secureStorage.read(key: 'user_pin');
      if (savedPin == null || savedPin != pin) {
        return const ApiResult.failure(
          AppError(type: AppErrorType.unauthorized, message: 'Noto\'g\'ri PIN'),
        );
      }

      // Cached session ni qaytarish
      final session = await getCurrentSession();
      if (session != null) {
        return ApiResult.success(session);
      }

      return const ApiResult.failure(
        AppError(type: AppErrorType.unauthorized, message: 'Sessiya topilmadi'),
      );
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<ApiResult<void>> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return const ApiResult.failure(
          AppError(type: AppErrorType.unauthorized, message: 'Token topilmadi'),
        );
      }

      final response = await _remoteSource.refreshToken(refreshToken);
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(_handleError(e));
    }
  }

  @override
  Future<UserSession?> getCurrentSession() async {
    if (_cachedSession != null) return _cachedSession;

    final userData = await _tokenStorage.getUserData();
    if (userData != null) {
      try {
        final model = UserSessionModel.fromJsonString(userData);
        _cachedSession = model.toEntity();
        return _cachedSession;
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: 'user_pin', value: pin);
  }

  @override
  Future<bool> hasPin() async {
    final pin = await _secureStorage.read(key: 'user_pin');
    return pin != null && pin.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _remoteSource.logout(refreshToken);
      }
    } catch (_) {
      // Ignored: Server xatoligi yoki internet yo'qligida ham local logout qilish kerak
    } finally {
      _cachedSession = null;
      await _tokenStorage.clearAll();
    }
  }

  AppError _handleError(dynamic e) {
    if (e is AppError) return e;
    return AppError.unknown(e.toString());
  }
}
