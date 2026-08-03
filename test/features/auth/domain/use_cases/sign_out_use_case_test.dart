import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late SignOutUseCase sut;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    sut = SignOutUseCase(mockAuthRepo);
  });

  const tFailure = ServerFailure(error: 'Sign out failed');

  test('should return NetworkSuccess<void> when sign out succeeds', () async {
    when(
      () => mockAuthRepo.signOut(),
    ).thenAnswer((_) async => const NetworkSuccess<void>());

    final result = await sut();

    expect(result, isA<NetworkSuccess<void>>());
    verify(() => mockAuthRepo.signOut()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test(
    'should return NetworkFailure<void> when sign out encounters an error',
    () async {
      when(
        () => mockAuthRepo.signOut(),
      ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));

      final result = await sut();

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(() => mockAuthRepo.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );
}
