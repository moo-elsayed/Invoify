import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service_imp.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppPreferencesServiceImpl sut;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    sut = AppPreferencesServiceImpl(sharedPreferences);
  });

  final tDate = DateTime(2026, 1, 1);
  final tUserEntity = UserEntity(
    uid: 'u1',
    email: 'user@test.com',
    businessName: 'User Business',
    currency: 'USD',
    createdAt: tDate,
  );

  group('AppPreferencesServiceImpl', () {
    group('isFirstTime & saveFirstTime', () {
      test('isFirstTime should return true by default when not set', () {
        expect(sut.isFirstTime(), isTrue);
      });

      test('saveFirstTime should persist false for isFirstTime', () async {
        await sut.saveFirstTime();
        expect(sut.isFirstTime(), isFalse);
      });
    });

    group('getThemeMode & saveThemeMode', () {
      test('getThemeMode should return system by default', () {
        expect(sut.getThemeMode(), equals('system'));
      });

      test('saveThemeMode should persist selected theme', () async {
        await sut.saveThemeMode('dark');
        expect(sut.getThemeMode(), equals('dark'));
      });
    });

    group('getLanguage & saveLanguage', () {
      test('getLanguage should return ar by default', () {
        expect(sut.getLanguage(), equals('ar'));
      });

      test('saveLanguage should persist selected language', () async {
        await sut.saveLanguage('en');
        expect(sut.getLanguage(), equals('en'));
      });
    });

    group('getUser, saveUser & clearUser', () {
      test('getUser should return null when no user is cached', () {
        expect(sut.getUser(), isNull);
      });

      test(
        'saveUser should persist UserEntity and getUser should retrieve it',
        () async {
          await sut.saveUser(tUserEntity);

          final retrieved = sut.getUser();

          expect(retrieved, isNotNull);
          expect(retrieved?.uid, equals('u1'));
          expect(retrieved?.email, equals('user@test.com'));
          expect(retrieved?.businessName, equals('User Business'));
          expect(retrieved?.currency, equals('USD'));
        },
      );

      test('getUser should return null when json is invalid', () async {
        await sharedPreferences.setString('cached_user', 'invalid_json_data');

        expect(sut.getUser(), isNull);
      });

      test('clearUser should remove cached user from preferences', () async {
        await sut.saveUser(tUserEntity);
        expect(sut.getUser(), isNotNull);

        await sut.clearUser();

        expect(sut.getUser(), isNull);
      });
    });
  });
}
