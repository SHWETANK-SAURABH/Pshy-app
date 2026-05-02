import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/session.dart';
import '../../domain/usecases/get_sessions_use_case.dart';
import '../../psychologist_portal_providers.dart';

class SessionsState {
  final List<Session> sessions;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasMore;
  final String filter;
  final String? error;
  final int page;

  SessionsState({
    required this.sessions,
    required this.isLoading,
    required this.isRefreshing,
    required this.hasMore,
    required this.filter,
    required this.page,
    this.error,
  });

  factory SessionsState.initial() => SessionsState(
        sessions: [],
        isLoading: false,
        isRefreshing: false,
        hasMore: true,
        filter: 'upcoming',
        page: 1,
      );

  SessionsState copyWith({
    List<Session>? sessions,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasMore,
    String? filter,
    String? error,
    int? page,
  }) {
    return SessionsState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      filter: filter ?? this.filter,
      error: error,
      page: page ?? this.page,
    );
  }
}

class SessionsController extends StateNotifier<SessionsState> {
  SessionsController(Ref ref)
      : _getSessionsUseCase = ref.read(getSessionsUseCaseProvider),
        super(SessionsState.initial()) {
    loadSessions();
  }

  final GetSessionsUseCase _getSessionsUseCase;

  Future<void> loadSessions({bool reset = false}) async {
    if (state.isLoading) return;
    final nextPage = reset ? 1 : state.page;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _getSessionsUseCase.execute(
        status: state.filter,
        page: nextPage,
        pageSize: 10,
      );

      final allSessions = reset ? response.sessions : [...state.sessions, ...response.sessions];
      state = state.copyWith(
        sessions: allSessions,
        isLoading: false,
        isRefreshing: false,
        hasMore: response.hasMore,
        page: response.page + 1,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    await loadSessions(reset: true);
  }

  Future<void> changeFilter(String filter) async {
    state = state.copyWith(filter: filter, page: 1, sessions: [], hasMore: true, error: null);
    await loadSessions(reset: true);
  }

  Future<void> markSessionCompleted(String sessionId) async {
    final updated = state.sessions.map((session) {
      if (session.id == sessionId) {
        return Session(
          id: session.id,
          clientName: session.clientName,
          dateTime: session.dateTime,
          meetingLink: session.meetingLink,
          status: 'completed',
        );
      }
      return session;
    }).toList();
    state = state.copyWith(sessions: updated);
  }

  Future<void> markSessionNoShow(String sessionId) async {
    final updated = state.sessions.map((session) {
      if (session.id == sessionId) {
        return Session(
          id: session.id,
          clientName: session.clientName,
          dateTime: session.dateTime,
          meetingLink: session.meetingLink,
          status: 'no-show',
        );
      }
      return session;
    }).toList();
    state = state.copyWith(sessions: updated);
  }
}

final sessionsControllerProvider = StateNotifierProvider<SessionsController, SessionsState>(
  (ref) => SessionsController(ref),
);
