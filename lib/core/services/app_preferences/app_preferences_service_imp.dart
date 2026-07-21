import 'package:shared_preferences/shared_preferences.dart';
import 'app_preferences_service.dart';

class AppPreferencesServiceImpl implements AppPreferencesService {
  AppPreferencesServiceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;
  static const String _keyIsFirstTime = 'is_first_time';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';

  @override
  Future<void> saveFirstTime() async =>
      await _sharedPreferences.setBool(_keyIsFirstTime, false);

  @override
  bool isFirstTime() => _sharedPreferences.getBool(_keyIsFirstTime) ?? true;

  @override
  Future<void> saveThemeMode(String theme) async =>
      await _sharedPreferences.setString(_keyThemeMode, theme);

  @override
  String getThemeMode() =>
      _sharedPreferences.getString(_keyThemeMode) ?? 'system';

  @override
  String getLanguage() => _sharedPreferences.getString(_keyLanguage) ?? 'ar';

  @override
  Future<void> saveLanguage(String lang) async =>
      await _sharedPreferences.setString(_keyLanguage, lang);
}
