import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late GoogleSignInUseCase sut;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = .new();
    sut = GoogleSignInUseCase(mockAuthRepo);
  });

  const tUserEntity = UserEntity(
    uid: 'google_uid_123',
    businessName: 'Google User',
    email: 'google@example.com',
    currency: 'USD',
    isVerified: true,
  );

  const tFailure = ServerFailure(error: 'Google Sign In cancelled or failed');

  test(
    'should return NetworkSuccess<UserEntity> when Google Sign In succeeds',
    () async {
      when(
        () => mockAuthRepo.googleSignIn(),
      ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));

      final result = await sut();

      expect(result, equals(const NetworkSuccess(tUserEntity)));
      verify(() => mockAuthRepo.googleSignIn()).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );

  test(
    'should return NetworkFailure<UserEntity> when Google Sign In fails or user cancels',
    () async {
      when(
        () => mockAuthRepo.googleSignIn(),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut();

      expect(result, equals(const NetworkFailure<UserEntity>(tFailure)));
      verify(() => mockAuthRepo.googleSignIn()).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );
}
