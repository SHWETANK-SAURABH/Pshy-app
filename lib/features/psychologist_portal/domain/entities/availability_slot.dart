class AvailabilitySlot {
  final String id;
  final DateTime start;
  final DateTime end;

  AvailabilitySlot({
    required this.id,
    required this.start,
    required this.end,
  });

  bool overlaps(AvailabilitySlot other) {
    return start.isBefore(other.end) && other.start.isBefore(end);
  }
}
