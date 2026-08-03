import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late SignInWithEmailAndPasswordUseCase sut;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    sut = SignInWithEmailAndPasswordUseCase(mockAuthRepo);
  });

  const tEmail = 'user@example.com';
  const tPassword = 'password123';

  const tUserEntity = UserEntity(
    uid: 'uid_123',
    businessName: 'Business Name',
    email: tEmail,
    currency: 'USD',
    isVerified: true,
  );

  const tFailure = ServerFailure(error: 'Invalid credentials');

  test(
    'should return NetworkSuccess<UserEntity> when sign in succeeds',
    () async {
      when(
        () => mockAuthRepo.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));

      final result = await sut(email: tEmail, password: tPassword);

      expect(result, equals(const NetworkSuccess(tUserEntity)));
      verify(
        () => mockAuthRepo.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );

  test('should return NetworkFailure<UserEntity> when sign in fails', () async {
    when(
      () => mockAuthRepo.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ),
    ).thenAnswer((_) async => const NetworkFailure(tFailure));

    final result = await sut(email: tEmail, password: tPassword);

    expect(result, equals(const NetworkFailure<UserEntity>(tFailure)));
    verify(
      () => mockAuthRepo.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
