// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      psychologistId: json['psychologistId'] as String,
      slot: TimeSlot.fromJson(json['slot'] as Map<String, dynamic>),
      clientName: json['clientName'] as String,
      clientEmail: json['clientEmail'] as String,
      clientPhone: json['clientPhone'] as String,
      issueType: json['issueType'] as String,
      paidAmount: (json['paidAmount'] as num).toDouble(),
      status: json['status'] as String? ?? 'confirmed',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'psychologistId': instance.psychologistId,
      'slot': instance.slot,
      'clientName': instance.clientName,
      'clientEmail': instance.clientEmail,
      'clientPhone': instance.clientPhone,
      'issueType': instance.issueType,
      'paidAmount': instance.paidAmount,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
