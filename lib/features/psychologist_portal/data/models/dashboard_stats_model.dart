import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/session.dart';
import 'session_model.dart';

class DashboardStatsModel extends DashboardStats {
  DashboardStatsModel({
    required super.upcomingSessions,
    required super.completedSessions,
    required super.totalSessions,
    required super.upcomingSchedule,
    required super.completedSchedule,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final upcomingJson = json['upcomingSchedule'] as List<dynamic>? ?? [];
    final completedJson = json['completedSchedule'] as List<dynamic>? ?? [];
    return DashboardStatsModel(
      upcomingSessions: json['upcomingSessions'] as int? ?? 0,
      completedSessions: json['completedSessions'] as int? ?? 0,
      totalSessions: json['totalSessions'] as int? ?? 0,
      upcomingSchedule: upcomingJson
          .map((item) => SessionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      completedSchedule: completedJson
          .map((item) => SessionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
