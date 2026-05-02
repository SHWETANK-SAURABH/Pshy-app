class AppConstants {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String authTokenKey = 'psychologist_jwt';
  static const String userStorageKey = 'psychologist_user';
}
