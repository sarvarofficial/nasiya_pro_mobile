import '../entities/user_session.dart';
import '../../../../core/api/api_result.dart';

/// Auth repository — abstract interface
/// Data layer da implement qilinadi
abstract class AuthRepository {
  /// Owner (Director) sifatida yangi biznes ro'yxatdan o'tkazish
  Future<ApiResult<UserSession>> registerOwner({
    required String fullName,
    required String phone,
    required String password,
    required String businessName,
  });

  /// Telefon + parol bilan login
  Future<ApiResult<UserSession>> login({
    required String phone,
    required String password,
  });

  /// PIN bilan tez login
  Future<ApiResult<UserSession>> loginWithPin(String pin);

  /// Token yangilash
  Future<ApiResult<void>> refreshToken();

  /// Session qaytarish (cached)
  Future<UserSession?> getCurrentSession();

  /// PIN saqlash
  Future<void> savePin(String pin);

  /// PIN mavjudligini tekshirish
  Future<bool> hasPin();

  /// Logout — tokenlar o'chirish
  Future<void> logout();
}
