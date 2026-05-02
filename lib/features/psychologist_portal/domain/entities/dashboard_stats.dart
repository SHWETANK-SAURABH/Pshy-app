import 'session.dart';

class DashboardStats {
  final int upcomingSessions;
  final int completedSessions;
  final int totalSessions;
  final List<Session> upcomingSchedule;
  final List<Session> completedSchedule;

  DashboardStats({
    required this.upcomingSessions,
    required this.completedSessions,
    required this.totalSessions,
    required this.upcomingSchedule,
    required this.completedSchedule,
  });
}
