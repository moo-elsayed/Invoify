abstract class AppPreferencesService {
  Future<void> saveFirstTime();

  bool isFirstTime();

  Future<bool> isLoggedIn();

  Future<void> logout();

  Future<void> saveUserData(String userJson);

  String? getUserData();

  Future<void> saveThemeMode(String theme);

  String getThemeMode();

  Future<void> saveLanguage(String lang);

  String getLanguage();
}
