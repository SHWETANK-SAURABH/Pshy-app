import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/psychologist_user.dart';
import '../../domain/usecases/forgot_password_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../psychologist_portal_providers.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState {
  final AuthStatus status;
  final PsychologistUser? user;
  final String? message;

  const AuthState({
    required this.status,
    this.user,
    this.message,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    PsychologistUser? user,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref)
      : _loginUseCase = _ref.read(loginUseCaseProvider),
        _forgotPasswordUseCase = _ref.read(forgotPasswordUseCaseProvider),
        _logoutUseCase = _ref.read(logoutUseCaseProvider),
        super(const AuthState(status: AuthStatus.initial)) {
    _ref.listen<String?>(tokenProvider, (previous, token) {
      if (token == null) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });
    if (_ref.read(tokenProvider) != null) {
      initialize();
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  final Ref _ref;
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> initialize() async {
    final token = _ref.read(tokenProvider);
    if (token != null) {
      final storedUser = await _ref.read(psychologistRepositoryProvider).restoreSession();
      if (storedUser != null) {
        state = AuthState(status: AuthStatus.authenticated, user: storedUser);
      } else {
        await logout();
      }
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final user = await _loginUseCase.execute(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (error) {
      state = AuthState(status: AuthStatus.failure, message: error.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      await _forgotPasswordUseCase.execute(email: email);
      state = state.copyWith(status: AuthStatus.initial, message: 'Check your inbox for recovery instructions.');
    } catch (error) {
      state = state.copyWith(status: AuthStatus.failure, message: error.toString());
    }
  }

  Future<void> logout() async {
    await _logoutUseCase.execute();
    await _ref.read(tokenProvider.notifier).clearToken();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
