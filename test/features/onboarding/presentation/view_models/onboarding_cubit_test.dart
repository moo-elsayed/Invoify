import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/features/onboarding/presentation/view_models/onboarding_cubit/onboarding_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  late MockAppPreferencesService mockAppPreferencesService;

  setUp(() {
    mockAppPreferencesService = MockAppPreferencesService();
  });

  OnboardingCubit sut() => OnboardingCubit(mockAppPreferencesService);

  group('OnboardingCubit', () {
    test('initial state should be OnboardingInitial', () {
      expect(sut().state, isA<OnboardingInitial>());
    });

    group('setFirstTime', () {
      blocTest<OnboardingCubit, OnboardingState>(
        'calls saveFirstTime on AppPreferencesService and emits [OnboardingNavigateToLogin]',
        build: () {
          when(
            () => mockAppPreferencesService.saveFirstTime(),
          ).thenAnswer((_) async {});
          return sut();
        },
        act: (cubit) => cubit.setFirstTime(),
        expect: () => [isA<OnboardingNavigateToLogin>()],
        verify: (_) {
          verify(() => mockAppPreferencesService.saveFirstTime()).called(1);
        },
      );
    });
  });
}
