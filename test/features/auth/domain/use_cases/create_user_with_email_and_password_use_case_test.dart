import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late CreateUserWithEmailAndPasswordUseCase sut;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    sut = CreateUserWithEmailAndPasswordUseCase(mockAuthRepo);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUsername = 'Test Business';

  const tUserEntity = UserEntity(
    uid: 'uid_123',
    businessName: tUsername,
    email: tEmail,
    currency: 'USD',
    isVerified: false,
  );

  const tFailure = ServerFailure(error: 'Email already in use');

  test(
    'should return NetworkSuccess<UserEntity> when account creation succeeds',
    () async {
      when(
        () => mockAuthRepo.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));

      final result = await sut(
        email: tEmail,
        password: tPassword,
        username: tUsername,
      );

      expect(result, equals(const NetworkSuccess(tUserEntity)));
      verify(
        () => mockAuthRepo.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );

  test(
    'should return NetworkFailure<UserEntity> when account creation fails',
    () async {
      when(
        () => mockAuthRepo.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut(
        email: tEmail,
        password: tPassword,
        username: tUsername,
      );

      expect(result, equals(const NetworkFailure<UserEntity>(tFailure)));
      verify(
        () => mockAuthRepo.createUserWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          username: tUsername,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );
}
