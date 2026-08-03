import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/settings/domain/repo/settings_repo.dart';
import 'package:invoify/features/settings/domain/use_cases/update_currency_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

void main() {
  late UpdateCurrencyUseCase sut;
  late MockSettingsRepo mockRepo;

  setUp(() {
    mockRepo = MockSettingsRepo();
    sut = UpdateCurrencyUseCase(mockRepo);
  });

  const tUid = 'u1';
  const tCurrency = 'USD';
  const tFailure = ServerFailure(error: 'Failed to update currency');

  test('should return NetworkSuccess<void> when call succeeds', () async {
    when(
      () => mockRepo.updateCurrency(uid: tUid, currency: tCurrency),
    ).thenAnswer((_) async => const NetworkSuccess());

    final result = await sut(uid: tUid, currency: tCurrency);

    expect(result, isA<NetworkSuccess<void>>());
    verify(
      () => mockRepo.updateCurrency(uid: tUid, currency: tCurrency),
    ).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return NetworkFailure<void> when call fails', () async {
    when(
      () => mockRepo.updateCurrency(uid: tUid, currency: tCurrency),
    ).thenAnswer((_) async => const NetworkFailure(tFailure));

    final result = await sut(uid: tUid, currency: tCurrency);

    expect(result, isA<NetworkFailure<void>>());
    expect((result as NetworkFailure<void>).failure, equals(tFailure));
    verify(
      () => mockRepo.updateCurrency(uid: tUid, currency: tCurrency),
    ).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
