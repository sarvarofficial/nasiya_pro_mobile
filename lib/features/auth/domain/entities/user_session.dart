import 'package:equatable/equatable.dart';

/// User session — auth state da saqlanadi
/// 
/// Spec: role + branchId + permissions JWT dan decode qilinadi
class UserSession extends Equatable {
  final String userId;
  final String fullName;
  final String phone;
  final String role;
  final String tenantId;
  final String? branchId;
  final String? branchName;
  final List<String> permissions;

  const UserSession({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.tenantId,
    this.branchId,
    this.branchName,
    this.permissions = const [],
  });

  /// Role tekshirish
  bool get isOwner => role == 'owner';
  bool get isManager => role == 'manager';
  bool get isSeller => role == 'seller';
  bool get isAccountant => role == 'accountant';
  bool get isSuperAdmin => role == 'super_admin';

  /// Permission tekshirish
  bool hasPermission(String permission) => permissions.contains(permission);
  
  bool get canCreateDebt => hasPermission('debt:create');
  bool get canEditDebt => hasPermission('debt:edit');
  bool get canDeleteDebt => hasPermission('debt:delete');
  bool get canVerifyPayment => hasPermission('payment:verify');
  bool get canExportReport => hasPermission('report:export');
  bool get canManageUsers => hasPermission('user:manage');


  @override
  List<Object?> get props => [userId, role, tenantId, branchId];
}
