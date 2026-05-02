import 'session.dart';

class SessionPage {
  final List<Session> sessions;
  final int page;
  final int pageSize;
  final int total;

  SessionPage({
    required this.sessions,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  bool get hasMore => sessions.length < total;
}
