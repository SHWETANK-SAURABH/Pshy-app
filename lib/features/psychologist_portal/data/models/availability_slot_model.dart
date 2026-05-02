import '../../domain/entities/availability_slot.dart';

class AvailabilitySlotModel extends AvailabilitySlot {
  AvailabilitySlotModel({
    required super.id,
    required super.start,
    required super.end,
  });

  factory AvailabilitySlotModel.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlotModel(
      id: json['id'] as String? ?? '',
      start: DateTime.parse(json['start'] as String? ?? DateTime.now().toIso8601String()),
      end: DateTime.parse(json['end'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}
