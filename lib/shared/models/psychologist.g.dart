// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychologist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PsychologistImpl _$$PsychologistImplFromJson(Map<String, dynamic> json) =>
    _$PsychologistImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      areasOfExpertise: (json['areasOfExpertise'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      consultationFee: (json['consultationFee'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      profileImageUrl: json['profileImageUrl'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contractRenewalDate: json['contractRenewalDate'] == null
          ? null
          : DateTime.parse(json['contractRenewalDate'] as String),
    );

Map<String, dynamic> _$$PsychologistImplToJson(_$PsychologistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'yearsOfExperience': instance.yearsOfExperience,
      'areasOfExpertise': instance.areasOfExpertise,
      'languages': instance.languages,
      'consultationFee': instance.consultationFee,
      'isActive': instance.isActive,
      'profileImageUrl': instance.profileImageUrl,
      'contactEmail': instance.contactEmail,
      'contractRenewalDate': instance.contractRenewalDate?.toIso8601String(),
    };
