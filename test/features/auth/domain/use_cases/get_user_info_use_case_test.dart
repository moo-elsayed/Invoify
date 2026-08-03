import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/auth/domain/entities/user_entity.dart';
import 'package:invoify/features/auth/domain/repo/auth_repo.dart';
import 'package:invoify/features/auth/domain/use_cases/get_user_info_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late GetUserInfoUseCase sut;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = .new();
    sut = GetUserInfoUseCase(mockAuthRepo);
  });

  const tUid = 'uid_123';
  const tUserEntity = UserEntity(
    uid: tUid,
    businessName: 'Business Name',
    email: 'user@example.com',
    currency: 'USD',
    isVerified: true,
  );

  const tFailure = ServerFailure(error: 'User info not found');

  test(
    'should return NetworkSuccess<UserEntity> when user info is retrieved successfully',
    () async {
      when(
        () => mockAuthRepo.getUserInfo(tUid),
      ).thenAnswer((_) async => const NetworkSuccess(tUserEntity));

      final result = await sut(tUid);

      expect(result, equals(const NetworkSuccess(tUserEntity)));
      verify(() => mockAuthRepo.getUserInfo(tUid)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );

  test(
    'should return NetworkFailure<UserEntity> when fetching user info fails',
    () async {
      when(
        () => mockAuthRepo.getUserInfo(tUid),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut(tUid);

      expect(result, equals(const NetworkFailure<UserEntity>(tFailure)));
      verify(() => mockAuthRepo.getUserInfo(tUid)).called(1);
      verifyNoMoreInteractions(mockAuthRepo);
    },
  );
}
