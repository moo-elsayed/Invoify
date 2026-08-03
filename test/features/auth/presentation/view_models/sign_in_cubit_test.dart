import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/signin_cubit/sign_in_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInWithEmailAndPasswordUseCase extends Mock
    implements SignInWithEmailAndPasswordUseCase {}

class MockUserInfoCubit extends Mock implements UserInfoCubit {}

void main() {
  late MockSignInWithEmailAndPasswordUseCase mockUseCase;
  late MockUserInfoCubit mockUserInfoCubit;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  const tUserEntity = UserEntity(
    uid: '123',
    businessName: 'Test Business',
    email: tEmail,
    currency: 'USD',
    isVerified: true,
  );

  const tFailure = ServerFailure(error: 'Invalid credentials');

  setUpAll(() {
    registerFallbackValue(tUserEntity);
  });

  setUp(() {
    mockUseCase = MockSignInWithEmailAndPasswordUseCase();
    mockUserInfoCubit = MockUserInfoCubit();

    when(
      () => mockUserInfoCubit.saveUserLocally(any()),
    ).thenAnswer((_) async {});

    if (GetIt.instance.isRegistered<UserInfoCubit>()) {
      GetIt.instance.unregister<UserInfoCubit>();
    }
    GetIt.instance.registerSingleton<UserInfoCubit>(mockUserInfoCubit);
  });

  group('SignInCubit', () {
    test('initial state should be SignInInitial', () {
      expect(SignInCubit(mockUseCase).state, isA<SignInInitial>());
    });

    blocTest<SignInCubit, SignInState>(
      'emits [SignInLoading, SignInSuccess] and saves user locally when sign in succeeds',
      build: () {
        when(
          () => mockUseCase(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));
        return SignInCubit(mockUseCase);
      },
      act: (cubit) =>
          cubit.signInWithEmailAndPassword(email: tEmail, password: tPassword),
      expect: () => [isA<SignInLoading>(), isA<SignInSuccess>()],
      verify: (_) {
        verify(() => mockUserInfoCubit.saveUserLocally(tUserEntity)).called(1);
      },
    );

    blocTest<SignInCubit, SignInState>(
      'emits [SignInLoading, SignInFailure] when sign in fails',
      build: () {
        when(
          () => mockUseCase(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));
        return SignInCubit(mockUseCase);
      },
      act: (cubit) =>
          cubit.signInWithEmailAndPassword(email: tEmail, password: tPassword),
      expect: () => [isA<SignInLoading>(), isA<SignInFailure>()],
    );
  });
}
