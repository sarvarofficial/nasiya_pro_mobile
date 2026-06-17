import 'package:dio/dio.dart';
import '../models/auth_models.dart';

/// Auth API calls
class AuthRemoteSource {
  final Dio _dio;

  AuthRemoteSource({required Dio dio}) : _dio = dio;

  /// Owner (Director) ro'yxatdan o'tishi
  Future<LoginResponseModel> registerOwner({
    required String fullName,
    required String phone,
    required String password,
    required String businessName,
  }) async {
    final response = await _dio.post('/auth/register-owner', data: {
      'full_name': fullName,
      'phone': phone,
      'password': password,
      'business_name': businessName,
    });
    return LoginResponseModel.fromJson(
      response.data['data'] as Map<String, dynamic>? ?? response.data as Map<String, dynamic>,
    );
  }

  /// Login — telefon + parol
  Future<LoginResponseModel> login({
    required String phone,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'phone': phone,
      'password': password,
    });
    return LoginResponseModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Token yangilash
  Future<LoginResponseModel> refreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    return LoginResponseModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Joriy user ma'lumotlarini olish
  Future<UserSessionModel> getMe() async {
    final response = await _dio.get('/auth/me');
    return UserSessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Server-side logout
  Future<void> logout(String refreshToken) async {
    await _dio.post('/auth/logout', data: {
      'refreshToken': refreshToken,
    });
  }
}
