import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late ForgetPasswordUseCase sut;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    sut = ForgetPasswordUseCase(mockAuthRepo);
  });

  const tEmail = 'reset@example.com';
  const tFailure = ServerFailure(error: 'User not found');

  test(
    'should return NetworkSuccess<void> when password reset email is sent successfully',
    () async {
      when(
        () => mockAuthRepo.forgetPassword(tEmail),
      ).thenAnswer((_) async => const NetworkSuccess<void>());

      final result = await sut(tEmail);

      expect(result, isA<NetworkSuccess<void>>());
      verify(() => mockAuthRepo.forgetPassword(tEmail)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );

  test(
    'should return NetworkFailure<void> when user email does not exist',
    () async {
      when(
        () => mockAuthRepo.forgetPassword(tEmail),
      ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));

      final result = await sut(tEmail);

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(() => mockAuthRepo.forgetPassword(tEmail)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );
}
