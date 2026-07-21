abstract class AppPreferencesService {
  Future<void> saveFirstTime();

  bool isFirstTime();

  Future<void> saveThemeMode(String theme);

  String getThemeMode();

  Future<void> saveLanguage(String lang);

  String getLanguage();
}
