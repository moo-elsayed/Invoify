import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import 'package:invoify/features/auth/presentation/view_models/signup_cubit/sign_up_cubit.dart';
import 'package:invoify/features/auth/presentation/view_models/user_info_cubit/user_info_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateUserWithEmailAndPasswordUseCase extends Mock
    implements CreateUserWithEmailAndPasswordUseCase {}

class MockUserInfoCubit extends Mock implements UserInfoCubit {}

void main() {
  late MockCreateUserWithEmailAndPasswordUseCase mockUseCase;
  late MockUserInfoCubit mockUserInfoCubit;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUsername = 'Test Business';

  const tUserEntity = UserEntity(
    uid: '123',
    businessName: tUsername,
    email: tEmail,
    currency: 'USD',
    isVerified: false,
  );

  const tFailure = ServerFailure(error: 'Email already in use');

  setUpAll(() {
    registerFallbackValue(tUserEntity);
  });

  setUp(() {
    mockUseCase = MockCreateUserWithEmailAndPasswordUseCase();
    mockUserInfoCubit = MockUserInfoCubit();

    when(
      () => mockUserInfoCubit.saveUserLocally(any()),
    ).thenAnswer((_) async {});

    if (GetIt.instance.isRegistered<UserInfoCubit>()) {
      GetIt.instance.unregister<UserInfoCubit>();
    }
    GetIt.instance.registerSingleton<UserInfoCubit>(mockUserInfoCubit);
  });

  group('SignupCubit', () {
    test('initial state should be SignUpInitial', () {
      expect(SignupCubit(mockUseCase).state, isA<SignUpInitial>());
    });

    blocTest<SignupCubit, SignupState>(
      'emits [SignUpLoading, SignUpSuccess] and saves user locally when sign up succeeds',
      build: () {
        when(
          () => mockUseCase(
            email: tEmail,
            password: tPassword,
            username: tUsername,
          ),
        ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));
        return SignupCubit(mockUseCase);
      },
      act: (cubit) => cubit.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        username: tUsername,
      ),
      expect: () => [isA<SignUpLoading>(), isA<SignUpSuccess>()],
      verify: (_) {
        verify(() => mockUserInfoCubit.saveUserLocally(tUserEntity)).called(1);
      },
    );

    blocTest<SignupCubit, SignupState>(
      'emits [SignUpLoading, SignUpFailure] when sign up fails',
      build: () {
        when(
          () => mockUseCase(
            email: tEmail,
            password: tPassword,
            username: tUsername,
          ),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));
        return SignupCubit(mockUseCase);
      },
      act: (cubit) => cubit.createUserWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
        username: tUsername,
      ),
      expect: () => [isA<SignUpLoading>(), isA<SignUpFailure>()],
    );
  });
}
