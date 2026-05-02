import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/auth_interceptor.dart';
import '../../core/storage/secure_storage_service.dart';
import 'data/datasources/psychologist_remote_data_source.dart';
import 'data/repositories/psychologist_repository_impl.dart';
import 'domain/repositories/psychologist_repository.dart';
import 'domain/usecases/forgot_password_use_case.dart';
import 'domain/usecases/get_dashboard_use_case.dart';
import 'domain/usecases/get_sessions_use_case.dart';
import 'domain/usecases/login_use_case.dart';
import 'domain/usecases/logout_use_case.dart';
import 'domain/usecases/sync_availability_use_case.dart';
import 'domain/usecases/update_profile_use_case.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final tokenProvider = StateNotifierProvider<TokenNotifier, String?>((ref) {
  return TokenNotifier(ref.read(secureStorageServiceProvider));
});

class TokenNotifier extends StateNotifier<String?> {
  TokenNotifier(this._storage) : super(null) {
    _loadToken();
  }

  final SecureStorageService _storage;

  Future<void> _loadToken() async {
    state = await _storage.read(AppConstants.authTokenKey);
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: AppConstants.authTokenKey, value: token);
    state = token;
  }

  Future<void> clearToken() async {
    await _storage.delete(AppConstants.authTokenKey);
    await _storage.delete(AppConstants.userStorageKey);
    state = null;
  }
}

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(ref.read(secureStorageServiceProvider), () async {
    await ref.read(tokenProvider.notifier).clearToken();
  });
});

final dioProvider = Provider<Dio>((ref) {
  return createApiClient(interceptors: [ref.read(authInterceptorProvider)]);
});

final psychologistRemoteDataSourceProvider = Provider<PsychologistRemoteDataSource>((ref) {
  return PsychologistRemoteDataSource(ref.read(dioProvider));
});

final psychologistRepositoryProvider = Provider<PsychologistRepository>((ref) {
  return PsychologistRepositoryImpl(
    ref.read(psychologistRemoteDataSourceProvider),
    ref.read(secureStorageServiceProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(psychologistRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.read(psychologistRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(psychologistRepositoryProvider));
});

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  return GetDashboardUseCase(ref.read(psychologistRepositoryProvider));
});

final getSessionsUseCaseProvider = Provider<GetSessionsUseCase>((ref) {
  return GetSessionsUseCase(ref.read(psychologistRepositoryProvider));
});

final syncAvailabilityUseCaseProvider = Provider<SyncAvailabilityUseCase>((ref) {
  return SyncAvailabilityUseCase(ref.read(psychologistRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.read(psychologistRepositoryProvider));
});
