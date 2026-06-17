import 'package:equatable/equatable.dart';
import '../../features/auth/domain/entities/user_session.dart';

/// Auth state — UI qanday ko'rinadi
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Boshlang'ich holat — hali tekshirilmagan
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Session tekshirilmoqda
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Foydalanuvchi tizimga kirgan
class AuthAuthenticated extends AuthState {
  final UserSession session;

  const AuthAuthenticated({required this.session});

  @override
  List<Object?> get props => [session];
}

/// Tizimga kirilmagan
class AuthUnauthenticated extends AuthState {
  final bool hasPinSetup;

  const AuthUnauthenticated({this.hasPinSetup = false});

  @override
  List<Object?> get props => [hasPinSetup];
}

/// Login jarayonida
class AuthLoginInProgress extends AuthState {
  const AuthLoginInProgress();
}

/// Login xatosi
class AuthLoginFailure extends AuthState {
  final String message;

  const AuthLoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
