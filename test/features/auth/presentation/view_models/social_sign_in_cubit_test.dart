import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignInUseCase extends Mock implements GoogleSignInUseCase {}

class MockUserInfoCubit extends Mock implements UserInfoCubit {}

void main() {
  late MockGoogleSignInUseCase mockUseCase;
  late MockUserInfoCubit mockUserInfoCubit;

  const tUserEntity = UserEntity(
    uid: '123',
    businessName: 'Google Business',
    email: 'google@example.com',
    currency: 'USD',
    isVerified: true,
  );

  const tFailure = ServerFailure(error: 'Google Sign-In failed');

  setUpAll(() {
    registerFallbackValue(tUserEntity);
  });

  setUp(() {
    mockUseCase = MockGoogleSignInUseCase();
    mockUserInfoCubit = MockUserInfoCubit();

    when(
      () => mockUserInfoCubit.saveUserLocally(any()),
    ).thenAnswer((_) async {});

    if (GetIt.instance.isRegistered<UserInfoCubit>()) {
      GetIt.instance.unregister<UserInfoCubit>();
    }
    GetIt.instance.registerSingleton<UserInfoCubit>(mockUserInfoCubit);
  });

  group('SocialSignInCubit', () {
    test('initial state should be SocialSignInInitial', () {
      expect(SocialSignInCubit(mockUseCase).state, isA<SocialSignInInitial>());
    });

    blocTest<SocialSignInCubit, SocialSignInState>(
      'emits [GoogleLoading, GoogleSuccess] and saves user locally when Google Sign In succeeds',
      build: () {
        when(
          () => mockUseCase(),
        ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));
        return SocialSignInCubit(mockUseCase);
      },
      act: (cubit) => cubit.googleSignIn(),
      expect: () => [isA<GoogleLoading>(), isA<GoogleSuccess>()],
      verify: (_) {
        verify(() => mockUserInfoCubit.saveUserLocally(tUserEntity)).called(1);
      },
    );

    blocTest<SocialSignInCubit, SocialSignInState>(
      'emits [GoogleLoading, GoogleFailure] when Google Sign In fails',
      build: () {
        when(
          () => mockUseCase(),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));
        return SocialSignInCubit(mockUseCase);
      },
      act: (cubit) => cubit.googleSignIn(),
      expect: () => [isA<GoogleLoading>(), isA<GoogleFailure>()],
    );
  });
}
