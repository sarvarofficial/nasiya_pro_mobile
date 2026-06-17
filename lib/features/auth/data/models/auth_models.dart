import 'dart:convert';

import '../../domain/entities/user_session.dart';

/// Login javob modeli — API dan kelgan JSON ni parse qiladi
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserSessionModel user;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'] as String;
    final userJson = Map<String, dynamic>.from(json['user'] as Map<String, dynamic>);

    // Agar user ichida tenantId kelmasa, uni JWT (accessToken) dan o'qiymiz
    if (!userJson.containsKey('tenantId') || userJson['tenantId'] == null) {
      try {
        final parts = accessToken.split('.');
        if (parts.length >= 2) {
          String normalized = base64Url.normalize(parts[1]);
          final payloadStr = utf8.decode(base64Url.decode(normalized));
          final payloadJson = jsonDecode(payloadStr);
          userJson['tenantId'] = payloadJson['tenantId'];
        }
      } catch (_) {
        // Ignored fallback
      }
    }

    return LoginResponseModel(
      accessToken: accessToken,
      refreshToken: json['refreshToken'] as String,
      user: UserSessionModel.fromJson(userJson),
    );
  }
}

/// User modeli — JSON serializable
class UserSessionModel {
  final String userId;
  final String fullName;
  final String phone;
  final String role;
  final String tenantId;
  final String? branchId;
  final String? branchName;
  final List<String> permissions;

  const UserSessionModel({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.tenantId,
    this.branchId,
    this.branchName,
    this.permissions = const [],
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) {
    return UserSessionModel(
      userId: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      tenantId: json['tenantId'] as String? ?? '',
      branchId: json['branchId'] as String?,
      branchName: json['branchName'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          _defaultPermissions(json['role'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'tenantId': tenantId,
      'branchId': branchId,
      'branchName': branchName,
      'permissions': permissions,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserSessionModel.fromJsonString(String json) {
    return UserSessionModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Domain entity ga convert
  UserSession toEntity() {
    return UserSession(
      userId: userId,
      fullName: fullName,
      phone: phone,
      role: role,
      tenantId: tenantId,
      branchId: branchId,
      branchName: branchName,
      permissions: permissions,
    );
  }

  /// Role bo'yicha default permissionlar
  static List<String> _defaultPermissions(String role) {
    return switch (role) {
      'owner' || 'super_admin' => [
        'debt:create', 'debt:edit', 'debt:delete',
        'payment:receive', 'payment:verify',
        'report:export', 'user:manage',
      ],
      'manager' => [
        'debt:create', 'debt:edit',
        'payment:receive', 'payment:verify',
        'report:export',
      ],
      'seller' => [
        'debt:create',
        'payment:receive',
      ],
      'accountant' => [
        'report:export',
      ],
      _ => [],
    };
  }
}
