import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/features/splash/presentation/view_models/splash_cubit/splash_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() {
  late MockAppPreferencesService mockAppPreferencesService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockAppPreferencesService = MockAppPreferencesService();
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
  });

  SplashCubit sut({FirebaseAuth? auth}) => SplashCubit(
    mockAppPreferencesService,
    firebaseAuth: auth ?? mockFirebaseAuth,
  );

  group('SplashCubit', () {
    test('initial state should be SplashInitial', () {
      expect(sut().state, equals(const SplashInitial()));
    });

    blocTest<SplashCubit, SplashState>(
      'emits [SplashSuccess(navigateToOnboarding)] when isFirstTime is true',
      build: () {
        when(() => mockAppPreferencesService.isFirstTime()).thenReturn(true);
        return sut();
      },
      act: (cubit) => cubit.checkAppStatus(),
      expect: () => [const SplashSuccess(SplashProcess.navigateToOnboarding)],
      verify: (_) {
        verify(() => mockAppPreferencesService.isFirstTime()).called(1);
      },
    );

    blocTest<SplashCubit, SplashState>(
      'emits [SplashSuccess(navigateToLogin)] when isFirstTime is false and user is not logged in',
      build: () {
        when(() => mockAppPreferencesService.isFirstTime()).thenReturn(false);
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);
        return sut();
      },
      act: (cubit) => cubit.checkAppStatus(),
      expect: () => [const SplashSuccess(SplashProcess.navigateToLogin)],
      verify: (_) {
        verify(() => mockAppPreferencesService.isFirstTime()).called(1);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      },
    );

    blocTest<SplashCubit, SplashState>(
      'emits [SplashSuccess(navigateToHome)] when isFirstTime is false and user is logged in',
      build: () {
        when(() => mockAppPreferencesService.isFirstTime()).thenReturn(false);
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        return sut();
      },
      act: (cubit) => cubit.checkAppStatus(),
      expect: () => [const SplashSuccess(SplashProcess.navigateToHome)],
      verify: (_) {
        verify(() => mockAppPreferencesService.isFirstTime()).called(1);
        verify(() => mockFirebaseAuth.currentUser).called(1);
      },
    );
  });
}
