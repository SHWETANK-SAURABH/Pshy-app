import 'package:freezed_annotation/freezed_annotation.dart';

part 'psychologist.freezed.dart';
part 'psychologist.g.dart';

@freezed
class Psychologist with _$Psychologist {
  const factory Psychologist({
    required String id,
    required String firstName,
    required String lastName,
    required String gender,
    required int yearsOfExperience,
    required List<String> areasOfExpertise,
    required List<String> languages,
    required double consultationFee,
    @Default(true) bool isActive,
    String? profileImageUrl,
    String? contactEmail,
    DateTime? contractRenewalDate,
  }) = _Psychologist;

  factory Psychologist.fromJson(Map<String, dynamic> json) => _$PsychologistFromJson(json);
}
