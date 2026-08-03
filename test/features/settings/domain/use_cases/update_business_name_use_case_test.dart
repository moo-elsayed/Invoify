import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/settings/domain/repo/settings_repo.dart';
import 'package:invoify/features/settings/domain/use_cases/update_business_name_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

void main() {
  late UpdateBusinessNameUseCase sut;
  late MockSettingsRepo mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepo();
    sut = UpdateBusinessNameUseCase(mockRepo);
  });

  const tUid = 'u1';
  const tBusinessName = 'Corp';
  const tFailure = ServerFailure(error: 'Failed to update business name');

  test('should return NetworkSuccess<void> when call succeeds', () async {
    when(
      () => mockRepo.updateBusinessName(uid: tUid, businessName: tBusinessName),
    ).thenAnswer((_) async => const NetworkSuccess());

    final result = await sut(uid: tUid, businessName: tBusinessName);

    expect(result, isA<NetworkSuccess<void>>());
    verify(
      () => mockRepo.updateBusinessName(uid: tUid, businessName: tBusinessName),
    ).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return NetworkFailure<void> when call fails', () async {
    when(
      () => mockRepo.updateBusinessName(uid: tUid, businessName: tBusinessName),
    ).thenAnswer((_) async => const NetworkFailure(tFailure));

    final result = await sut(uid: tUid, businessName: tBusinessName);

    expect(result, isA<NetworkFailure<void>>());
    expect((result as NetworkFailure<void>).failure, equals(tFailure));
    verify(
      () => mockRepo.updateBusinessName(uid: tUid, businessName: tBusinessName),
    ).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
