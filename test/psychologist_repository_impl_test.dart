import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient/core/storage/secure_storage_service.dart';
import 'package:gradient/features/psychologist_portal/data/datasources/psychologist_remote_data_source.dart';
import 'package:gradient/features/psychologist_portal/data/models/availability_slot_model.dart';
import 'package:gradient/features/psychologist_portal/data/models/dashboard_stats_model.dart';
import 'package:gradient/features/psychologist_portal/data/models/psychologist_user_model.dart';
import 'package:gradient/features/psychologist_portal/data/models/session_model.dart';
import 'package:gradient/features/psychologist_portal/data/repositories/psychologist_repository_impl.dart';
import 'package:gradient/features/psychologist_portal/domain/entities/psychologist_user.dart';
import 'package:gradient/features/psychologist_portal/domain/entities/session.dart';
import 'package:gradient/features/psychologist_portal/domain/entities/availability_slot.dart';
import 'package:gradient/features/psychologist_portal/domain/entities/dashboard_stats.dart';
import 'package:gradient/features/psychologist_portal/domain/entities/session_page.dart';

class FakeRemoteDataSource extends PsychologistRemoteDataSource {
  FakeRemoteDataSource() : super(Dio());

  @override
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    return {
      'accessToken': 'fake-token',
      'user': {
        'id': 'user-1',
        'name': 'Dr. Test',
        'email': email,
        'expertise': ['Cognitive Therapy'],
        'languages': ['English'],
      }
    };
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    return;
  }

  @override
  Future<DashboardStatsModel> getDashboard() async {
    return DashboardStatsModel(
      upcomingSessions: 1,
      completedSessions: 2,
      totalSessions: 3,
      upcomingSchedule: [
        SessionModel(
          id: 'session-1',
          clientName: 'Client A',
          dateTime: DateTime.now().add(const Duration(days: 1)),
          meetingLink: 'https://meet.example.com/1',
          status: 'upcoming',
        ),
      ],
      completedSchedule: const [],
    );
  }

  @override
  Future<SessionPage> getSessions({required String status, required int page, required int pageSize}) async {
    return SessionPage(
      sessions: [],
      page: page,
      pageSize: pageSize,
      total: 0,
    );
  }

  @override
  Future<void> saveAvailability({required List<AvailabilitySlotModel> slots, required List<DateTime> blockedDates}) async {
    return;
  }

  @override
  Future<PsychologistUserModel> updateProfile({required PsychologistUserModel user}) async {
    return user;
  }
}

class FakeStorageService extends SecureStorageService {
  final Map<String, String> _store = {};

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    return _store[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }
}

void main() {
  late FakeRemoteDataSource remoteDataSource;
  late FakeStorageService storage;
  late PsychologistRepositoryImpl repository;

  setUp(() {
    remoteDataSource = FakeRemoteDataSource();
    storage = FakeStorageService();
    repository = PsychologistRepositoryImpl(remoteDataSource, storage);
  });

  test('login stores token and user information', () async {
    final user = await repository.login(email: 'test@example.com', password: 'password');

    expect(user.name, 'Dr. Test');
    expect(user.email, 'test@example.com');
    expect(await storage.read('psychologist_jwt'), 'fake-token');
    expect(jsonDecode(await storage.read('psychologist_user') ?? ''), isA<Map<String, dynamic>>());
  });

  test('restoreSession returns user when token and user data exist', () async {
    await storage.write(key: 'psychologist_jwt', value: 'fake-token');
    await storage.write(
      key: 'psychologist_user',
      value: jsonEncode({
        'id': 'user-1',
        'name': 'Dr. Test',
        'email': 'test@example.com',
        'expertise': ['Cognitive Therapy'],
        'languages': ['English'],
      }),
    );

    final user = await repository.restoreSession();

    expect(user, isNotNull);
    expect(user?.name, 'Dr. Test');
    expect(user?.email, 'test@example.com');
  });

  test('logout clears secure storage', () async {
    await storage.write(key: 'psychologist_jwt', value: 'fake-token');
    await storage.write(key: 'psychologist_user', value: '{}');

    await repository.logout();

    expect(await storage.read('psychologist_jwt'), isNull);
    expect(await storage.read('psychologist_user'), isNull);
  });
}
