import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc — global auth holat boshqaruvchisi
///
/// Core da joylashgan chunki barcha feature lar auth ga bog'liq
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthRegisterOwnerRequested>(_onRegisterOwnerRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthPinLoginRequested>(_onPinLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  /// App ochilganda — session tekshirish
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = await _authRepository.getCurrentSession();
      if (session != null) {
        emit(AuthAuthenticated(session: session));
      } else {
        final hasPin = await _authRepository.hasPin();
        emit(AuthUnauthenticated(hasPinSetup: hasPin));
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Owner ro'yxatdan o'tishi
  Future<void> _onRegisterOwnerRequested(
    AuthRegisterOwnerRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoginInProgress());
    try {
      final result = await _authRepository.registerOwner(
        fullName: event.fullName,
        phone: event.phone,
        password: event.password,
        businessName: event.businessName,
      );
      result.when(
        success: (session) => emit(AuthAuthenticated(session: session)),
        failure: (error) => emit(AuthLoginFailure(message: error.message)),
      );
    } catch (e) {
      emit(AuthLoginFailure(message: e.toString()));
    }
  }

  /// Telefon + parol login
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoginInProgress());
    try {
      final result = await _authRepository.login(
        phone: event.phone,
        password: event.password,
      );
      result.when(
        success: (session) => emit(AuthAuthenticated(session: session)),
        failure: (error) => emit(AuthLoginFailure(message: error.message)),
      );
    } catch (e) {
      emit(AuthLoginFailure(message: e.toString()));
    }
  }

  /// PIN bilan login
  Future<void> _onPinLoginRequested(
    AuthPinLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoginInProgress());
    try {
      final result = await _authRepository.loginWithPin(event.pin);
      result.when(
        success: (session) => emit(AuthAuthenticated(session: session)),
        failure: (error) => emit(AuthLoginFailure(message: error.message)),
      );
    } catch (e) {
      emit(AuthLoginFailure(message: e.toString()));
    }
  }

  /// Logout
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
