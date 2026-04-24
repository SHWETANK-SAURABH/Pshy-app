import 'package:freezed_annotation/freezed_annotation.dart';
import 'time_slot.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String psychologistId,
    required TimeSlot slot,
    required String clientName,
    required String clientEmail,
    required String clientPhone,
    required String issueType,
    required double paidAmount,
    @Default('confirmed') String status, // confirmed, rescheduled, completed
    required DateTime createdAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}
