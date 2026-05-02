import 'dart:convert';

import '../../domain/entities/availability_slot.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/psychologist_user.dart';
import '../../domain/entities/session_page.dart';
import '../../domain/repositories/psychologist_repository.dart';
import '../datasources/psychologist_remote_data_source.dart';
import '../models/availability_slot_model.dart';
import '../models/psychologist_user_model.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../models/api_error.dart';

class PsychologistRepositoryImpl implements PsychologistRepository {
  PsychologistRepositoryImpl(
    this._remoteDataSource,
    this._storage,
  );

  final PsychologistRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  @override
  Future<PsychologistUser> login({required String email, required String password}) async {
    final response = await _remoteDataSource.login(email: email, password: password);
    final token = response['accessToken'] as String?;
    final userJson = response['user'] as Map<String, dynamic>?;

    if (token == null || userJson == null) {
      throw ApiError(message: 'Invalid authentication response.');
    }

    await _storage.write(key: AppConstants.authTokenKey, value: token);
    await _storage.write(key: AppConstants.userStorageKey, value: jsonEncode(userJson));
    return PsychologistUserModel.fromJson(userJson);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    return _remoteDataSource.forgotPassword(email: email);
  }

  @override
  Future<void> logout() async {
    await _storage.delete(AppConstants.authTokenKey);
    await _storage.delete(AppConstants.userStorageKey);
  }

  @override
  Future<PsychologistUser?> restoreSession() async {
    final token = await _storage.read(AppConstants.authTokenKey);
    final userJsonText = await _storage.read(AppConstants.userStorageKey);
    if (token == null || userJsonText == null) {
      return null;
    }

    try {
      final userJson = jsonDecode(userJsonText) as Map<String, dynamic>;
      return PsychologistUserModel.fromJson(userJson);
    } catch (_) {
      await logout();
      return null;
    }
  }

  @override
  Future<DashboardStats> getDashboard() async {
    return _remoteDataSource.getDashboard();
  }

  @override
  Future<SessionPage> getSessions({required String status, required int page, required int pageSize}) {
    return _remoteDataSource.getSessions(status: status, page: page, pageSize: pageSize);
  }

  @override
  Future<void> saveAvailability({required List<AvailabilitySlot> slots, required List<DateTime> blockedDates}) async {
    final models = slots.map((slot) {
      return AvailabilitySlotModel(id: slot.id, start: slot.start, end: slot.end);
    }).toList();
    return _remoteDataSource.saveAvailability(slots: models, blockedDates: blockedDates);
  }

  @override
  Future<PsychologistUser> updateProfile({required PsychologistUser user}) async {
    final updatedUser = await _remoteDataSource.updateProfile(
      user: PsychologistUserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        expertise: user.expertise,
        languages: user.languages,
        role: user.role,
      ),
    );
    await _storage.write(key: AppConstants.userStorageKey, value: jsonEncode(updatedUser.toJson()));
    return updatedUser;
  }
}
