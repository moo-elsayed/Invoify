import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/core/services/app_preferences/app_preferences_service.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/use_cases/get_user_info_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:invoify/features/settings/domain/use_cases/update_business_name_use_case.dart';
import 'package:invoify/features/settings/domain/use_cases/update_currency_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

class MockGetUserInfoUseCase extends Mock implements GetUserInfoUseCase {}

class MockUpdateCurrencyUseCase extends Mock implements UpdateCurrencyUseCase {}

class MockUpdateBusinessNameUseCase extends Mock
    implements UpdateBusinessNameUseCase {}

void main() {
  late MockAppPreferencesService mockAppPreferencesService;
  late MockGetUserInfoUseCase mockGetUserInfoUseCase;
  late MockUpdateCurrencyUseCase mockUpdateCurrencyUseCase;
  late MockUpdateBusinessNameUseCase mockUpdateBusinessNameUseCase;

  const tUserEntity = UserEntity(
    uid: '123',
    businessName: 'Original Business',
    email: 'test@example.com',
    currency: 'USD',
    isVerified: true,
  );

  const tFailure = ServerFailure(error: 'Update failed');

  setUpAll(() {
    registerFallbackValue(tUserEntity);
  });

  setUp(() {
    mockAppPreferencesService = MockAppPreferencesService();
    mockGetUserInfoUseCase = MockGetUserInfoUseCase();
    mockUpdateCurrencyUseCase = MockUpdateCurrencyUseCase();
    mockUpdateBusinessNameUseCase = MockUpdateBusinessNameUseCase();

    when(() => mockAppPreferencesService.getUser()).thenReturn(null);
    when(
      () => mockAppPreferencesService.saveUser(any()),
    ).thenAnswer((_) async {});
    when(() => mockAppPreferencesService.clearUser()).thenAnswer((_) async {});
  });

  UserInfoCubit createCubit() => UserInfoCubit(
    mockAppPreferencesService,
    mockGetUserInfoUseCase,
    mockUpdateCurrencyUseCase,
    mockUpdateBusinessNameUseCase,
  );

  group('UserInfoCubit', () {
    test('should emit UserInfoSuccess on init if cached user exists', () {
      when(() => mockAppPreferencesService.getUser()).thenReturn(tUserEntity);

      final cubit = createCubit();

      expect(cubit.state, isA<UserInfoSuccess>());
      expect((cubit.state as UserInfoSuccess).user, equals(tUserEntity));
    });

    test('should return currentUser correctly from state or cached prefs', () {
      when(() => mockAppPreferencesService.getUser()).thenReturn(tUserEntity);
      final cubit = createCubit();

      expect(cubit.currentUser, equals(tUserEntity));
    });

    blocTest<UserInfoCubit, UserInfoState>(
      'saveUserLocally should call saveUser on prefs and emit UserInfoSuccess',
      build: () => createCubit(),
      act: (cubit) => cubit.saveUserLocally(tUserEntity),
      expect: () => [isA<UserInfoSuccess>()],
      verify: (_) {
        verify(() => mockAppPreferencesService.saveUser(tUserEntity)).called(1);
      },
    );

    blocTest<UserInfoCubit, UserInfoState>(
      'clearUserLocally should call clearUser on prefs and emit UserInfoInitial',
      build: () => createCubit(),
      act: (cubit) => cubit.clearUserLocally(),
      expect: () => [isA<UserInfoInitial>()],
      verify: (_) {
        verify(() => mockAppPreferencesService.clearUser()).called(1);
      },
    );

    group('updateBusinessName', () {
      const newName = 'Updated Business Ltd';
      final updatedUser = tUserEntity.copyWith(businessName: newName);

      blocTest<UserInfoCubit, UserInfoState>(
        'emits UserUpdateSuccess when updateBusinessName succeeds',
        build: () {
          when(
            () => mockAppPreferencesService.getUser(),
          ).thenReturn(tUserEntity);
          when(
            () => mockUpdateBusinessNameUseCase(
              uid: tUserEntity.uid,
              businessName: newName,
            ),
          ).thenAnswer((_) async => const NetworkSuccess<void>());
          return createCubit();
        },
        act: (cubit) => cubit.updateBusinessName(newName),
        expect: () => [isA<UserUpdateSuccess>()],
        verify: (_) {
          verify(
            () => mockAppPreferencesService.saveUser(updatedUser),
          ).called(1);
        },
      );

      blocTest<UserInfoCubit, UserInfoState>(
        'emits UserUpdateFailure when updateBusinessName fails',
        build: () {
          when(
            () => mockAppPreferencesService.getUser(),
          ).thenReturn(tUserEntity);
          when(
            () => mockUpdateBusinessNameUseCase(
              uid: tUserEntity.uid,
              businessName: newName,
            ),
          ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
          return createCubit();
        },
        act: (cubit) => cubit.updateBusinessName(newName),
        expect: () => [isA<UserUpdateFailure>()],
      );
    });

    group('updateCurrency', () {
      const newCurrency = 'EUR';
      final updatedUser = tUserEntity.copyWith(currency: newCurrency);

      blocTest<UserInfoCubit, UserInfoState>(
        'emits UserUpdateSuccess when updateCurrency succeeds',
        build: () {
          when(
            () => mockAppPreferencesService.getUser(),
          ).thenReturn(tUserEntity);
          when(
            () => mockUpdateCurrencyUseCase(
              uid: tUserEntity.uid,
              currency: newCurrency,
            ),
          ).thenAnswer((_) async => const NetworkSuccess<void>());
          return createCubit();
        },
        act: (cubit) => cubit.updateCurrency(newCurrency),
        expect: () => [isA<UserUpdateSuccess>()],
        verify: (_) {
          verify(
            () => mockAppPreferencesService.saveUser(updatedUser),
          ).called(1);
        },
      );

      blocTest<UserInfoCubit, UserInfoState>(
        'emits UserUpdateFailure when updateCurrency fails',
        build: () {
          when(
            () => mockAppPreferencesService.getUser(),
          ).thenReturn(tUserEntity);
          when(
            () => mockUpdateCurrencyUseCase(
              uid: tUserEntity.uid,
              currency: newCurrency,
            ),
          ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));
          return createCubit();
        },
        act: (cubit) => cubit.updateCurrency(newCurrency),
        expect: () => [isA<UserUpdateFailure>()],
      );
    });
  });
}
