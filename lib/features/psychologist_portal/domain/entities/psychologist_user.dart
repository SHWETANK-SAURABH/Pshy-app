class PsychologistUser {
  final String id;
  final String name;
  final String email;
  final List<String> expertise;
  final List<String> languages;
  final String role;

  PsychologistUser({
    required this.id,
    required this.name,
    required this.email,
    required this.expertise,
    required this.languages,
    this.role = 'psychologist',
  });

  PsychologistUser copyWith({
    String? name,
    String? email,
    List<String>? expertise,
    List<String>? languages,
  }) {
    return PsychologistUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      expertise: expertise ?? this.expertise,
      languages: languages ?? this.languages,
      role: role,
    );
  }
}
