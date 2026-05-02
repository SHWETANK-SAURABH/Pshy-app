import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/availability_slot_model.dart';
import '../models/dashboard_stats_model.dart';
import '../models/psychologist_user_model.dart';
import '../models/session_model.dart';
import '../models/api_error.dart';
import '../../domain/entities/session_page.dart';

class PsychologistRemoteDataSource {
  PsychologistRemoteDataSource(this._dio);

  final Dio _dio;

  PsychologistUserModel _mockUser = PsychologistUserModel(
    id: 'psych-123',
    name: 'Dr. Maya Carter',
    email: 'demo@gmail.com',
    expertise: ['Anxiety', 'Depression', 'Stress Management'],
    languages: ['English', 'Spanish'],
  );

  final List<SessionModel> _mockSessions = [
    SessionModel(
      id: 'sess-001',
      clientName: 'Ava Martin',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
      meetingLink: 'https://meet.example.com/session/001',
      status: 'upcoming',
    ),
    SessionModel(
      id: 'sess-002',
      clientName: 'Noah Patel',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 14)),
      meetingLink: 'https://meet.example.com/session/002',
      status: 'upcoming',
    ),
    SessionModel(
      id: 'sess-003',
      clientName: 'Lily Chen',
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      meetingLink: 'https://meet.example.com/session/003',
      status: 'completed',
    ),
  ];

  final List<AvailabilitySlotModel> _mockAvailability = [
    AvailabilitySlotModel(
      id: 'slot-001',
      start: DateTime.now().add(const Duration(days: 1, hours: 9)),
      end: DateTime.now().add(const Duration(days: 1, hours: 11)),
    ),
    AvailabilitySlotModel(
      id: 'slot-002',
      start: DateTime.now().add(const Duration(days: 2, hours: 13)),
      end: DateTime.now().add(const Duration(days: 2, hours: 16)),
    ),
  ];

  final List<DateTime> _mockBlockedDates = [];

  bool get _useMockBackend => AppConstants.apiBaseUrl == 'https://api.example.com';

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    if (_useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (email.toLowerCase() == 'demo@gmail.com' && password == '123456789') {
        return {
          'accessToken': 'mock-jwt-token-psyc-123',
          'user': _mockUser.toJson(),
        };
      }
      throw ApiError(message: 'Invalid email or password.', statusCode: 401);
    }

    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return Map<String, dynamic>.from(response.data as Map<String, dynamic>);
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    if (_useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return;
    }

    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  Future<DashboardStatsModel> getDashboard() async {
    if (_useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final upcoming = _mockSessions.where((s) => s.status == 'upcoming').toList();
      final completed = _mockSessions.where((s) => s.status == 'completed').toList();
      return DashboardStatsModel(
        upcomingSessions: upcoming.length,
        completedSessions: completed.length,
        totalSessions: _mockSessions.length,
        upcomingSchedule: upcoming,
        completedSchedule: completed,
      );
    }

    try {
      final response = await _dio.get('/psychologist/dashboard');
      return DashboardStatsModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  Future<SessionPage> getSessions({required String status, required int page, required int pageSize}) async {
    if (_useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      final filtered = _mockSessions.where((session) => session.status == status).toList();
      final start = (page - 1) * pageSize;
      final end = start + pageSize;
      final pageItems = filtered.sublist(start.clamp(0, filtered.length), end.clamp(0, filtered.length));
      return SessionPage(
        sessions: pageItems,
        page: page,
        pageSize: pageSize,
        total: filtered.length,
      );
    }

    try {
      final response = await _dio.get('/psychologist/sessions', queryParameters: {
        'status': status,
        'page': page,
        'pageSize': pageSize,
      });
      final data = response.data as Map<String, dynamic>;
      final sessionsJson = List<Map<String, dynamic>>.from(data['data'] as List<dynamic>? ?? []);
      final sessions = sessionsJson.map((item) => SessionModel.fromJson(item)).toList();
      return SessionPage(
        sessions: sessions,
        page: data['page'] as int? ?? page,
        pageSize: data['pageSize'] as int? ?? pageSize,
        total: data['total'] as int? ?? sessions.length,
      );
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  Future<void> saveAvailability({
    required List<AvailabilitySlotModel> slots,
    required List<DateTime> blockedDates,
  }) async {
    if (_useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      _mockAvailability
        ..clear()
        ..addAll(slots);
      _mockBlockedDates
        ..clear()
        ..addAll(blockedDates);
      return;
    }

    try {
      await _dio.post('/psychologist/availability', data: {
        'slots': slots.map((slot) => slot.toJson()).toList(),
        'blockedDates': blockedDates.map((date) => date.toIso8601String()).toList(),
      });
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  Future<PsychologistUserModel> updateProfile({required PsychologistUserModel user}) async {
    if (_useMockBackend) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      _mockUser = PsychologistUserModel(
        id: _mockUser.id,
        name: user.name,
        email: user.email,
        expertise: user.expertise,
        languages: user.languages,
      );
      return _mockUser;
    }

    try {
      final response = await _dio.put('/psychologist/profile', data: user.toJson());
      return PsychologistUserModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  ApiError _parseError(DioError error) {
    final response = error.response?.data;
    final message = response is Map<String, dynamic>
        ? (response['message'] as String? ?? 'Unable to process request.')
        : error.message;
    return ApiError(message: message.toString(), statusCode: error.response?.statusCode);
  }
}
