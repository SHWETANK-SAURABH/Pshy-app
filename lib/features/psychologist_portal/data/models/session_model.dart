import '../../domain/entities/session.dart';

class SessionModel extends Session {
  SessionModel({
    required super.id,
    required super.clientName,
    required super.dateTime,
    required super.meetingLink,
    required super.status,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String? ?? '',
      clientName: json['clientName'] as String? ?? '',
      dateTime: DateTime.parse(json['dateTime'] as String? ?? DateTime.now().toIso8601String()),
      meetingLink: json['meetingLink'] as String? ?? '',
      status: json['status'] as String? ?? 'upcoming',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'dateTime': dateTime.toIso8601String(),
      'meetingLink': meetingLink,
      'status': status,
    };
  }
}
