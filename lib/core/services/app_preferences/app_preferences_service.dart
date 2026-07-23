import 'package:invoify/features/auth/domain/entities/user_entity.dart';

abstract class AppPreferencesService {
  Future<void> saveFirstTime();

  bool isFirstTime();

  Future<void> saveThemeMode(String theme);

  String getThemeMode();

  Future<void> saveLanguage(String lang);

  String getLanguage();

  Future<void> saveUser(UserEntity user);

  UserEntity? getUser();

  Future<void> clearUser();
}
