import 'package:equatable/equatable.dart';

/// Auth eventlar
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// App ochilganda — session tekshirish
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Owner ro'yxatdan o'tishi
class AuthRegisterOwnerRequested extends AuthEvent {
  final String fullName;
  final String phone;
  final String password;
  final String businessName;

  const AuthRegisterOwnerRequested({
    required this.fullName,
    required this.phone,
    required this.password,
    required this.businessName,
  });

  @override
  List<Object?> get props => [fullName, phone, password, businessName];
}

/// Login — telefon + parol
class AuthLoginRequested extends AuthEvent {
  final String phone;
  final String password;

  const AuthLoginRequested({
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [phone, password];
}

/// PIN bilan login
class AuthPinLoginRequested extends AuthEvent {
  final String pin;

  const AuthPinLoginRequested({required this.pin});

  @override
  List<Object?> get props => [pin];
}

/// Logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
