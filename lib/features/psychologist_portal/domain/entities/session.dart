class Session {
  final String id;
  final String clientName;
  final DateTime dateTime;
  final String meetingLink;
  final String status;

  Session({
    required this.id,
    required this.clientName,
    required this.dateTime,
    required this.meetingLink,
    required this.status,
  });

  bool get isUpcoming => status.toLowerCase() == 'upcoming';
  bool get isCompleted => status.toLowerCase() == 'completed';
}
