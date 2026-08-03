import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/core/theming/app_theme_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  late MockAppPreferencesService mockAppPreferencesService;

  setUp(() {
    mockAppPreferencesService = MockAppPreferencesService();
  });

  group('AppThemeCubit', () {
    test(
      'initial state should emit ThemeMode.light when saved theme is light',
      () {
        when(
          () => mockAppPreferencesService.getThemeMode(),
        ).thenReturn('light');

        final cubit = AppThemeCubit(mockAppPreferencesService);

        expect(cubit.state, equals(ThemeMode.light));
        verify(() => mockAppPreferencesService.getThemeMode()).called(1);
      },
    );

    test(
      'initial state should emit ThemeMode.dark when saved theme is dark',
      () {
        when(() => mockAppPreferencesService.getThemeMode()).thenReturn('dark');

        final cubit = AppThemeCubit(mockAppPreferencesService);

        expect(cubit.state, equals(ThemeMode.dark));
        verify(() => mockAppPreferencesService.getThemeMode()).called(1);
      },
    );

    test(
      'initial state should emit ThemeMode.system when saved theme is system',
      () {
        when(
          () => mockAppPreferencesService.getThemeMode(),
        ).thenReturn('system');

        final cubit = AppThemeCubit(mockAppPreferencesService);

        expect(cubit.state, equals(ThemeMode.system));
        verify(() => mockAppPreferencesService.getThemeMode()).called(1);
      },
    );

    blocTest<AppThemeCubit, ThemeMode>(
      'emits [ThemeMode.light] and saves light when changeTheme(ThemeMode.light) is called',
      build: () {
        when(
          () => mockAppPreferencesService.getThemeMode(),
        ).thenReturn('system');
        when(
          () => mockAppPreferencesService.saveThemeMode('light'),
        ).thenAnswer((_) async {});
        return AppThemeCubit(mockAppPreferencesService);
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.light),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(
          () => mockAppPreferencesService.saveThemeMode('light'),
        ).called(1);
      },
    );

    blocTest<AppThemeCubit, ThemeMode>(
      'emits [ThemeMode.dark] and saves dark when changeTheme(ThemeMode.dark) is called',
      build: () {
        when(
          () => mockAppPreferencesService.getThemeMode(),
        ).thenReturn('system');
        when(
          () => mockAppPreferencesService.saveThemeMode('dark'),
        ).thenAnswer((_) async {});
        return AppThemeCubit(mockAppPreferencesService);
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(() => mockAppPreferencesService.saveThemeMode('dark')).called(1);
      },
    );

    blocTest<AppThemeCubit, ThemeMode>(
      'emits [ThemeMode.system] and saves system when changeTheme(ThemeMode.system) is called',
      build: () {
        when(
          () => mockAppPreferencesService.getThemeMode(),
        ).thenReturn('light');
        when(
          () => mockAppPreferencesService.saveThemeMode('system'),
        ).thenAnswer((_) async {});
        return AppThemeCubit(mockAppPreferencesService);
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.system),
      expect: () => [ThemeMode.system],
      verify: (_) {
        verify(
          () => mockAppPreferencesService.saveThemeMode('system'),
        ).called(1);
      },
    );
  });
}
