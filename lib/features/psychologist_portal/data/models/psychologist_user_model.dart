import '../../domain/entities/psychologist_user.dart';

class PsychologistUserModel extends PsychologistUser {
  PsychologistUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.expertise,
    required super.languages,
    super.role = 'psychologist',
  });

  factory PsychologistUserModel.fromJson(Map<String, dynamic> json) {
    return PsychologistUserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      expertise: List<String>.from(json['expertise'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      role: json['role'] as String? ?? 'psychologist',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'expertise': expertise,
      'languages': languages,
      'role': role,
    };
  }
}
