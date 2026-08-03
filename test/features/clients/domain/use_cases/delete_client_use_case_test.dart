import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/repo/clients_repo.dart';
import 'package:invoify/features/clients/domain/use_cases/delete_client_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockClientsRepo extends Mock implements ClientsRepo {}

void main() {
  late DeleteClientUseCase sut;
  late MockClientsRepo mockClientsRepo;

  setUp(() {
    mockClientsRepo = MockClientsRepo();
    sut = DeleteClientUseCase(mockClientsRepo);
  });

  const tClientId = 'c1';
  const tFailure = ServerFailure(error: 'Failed to delete client');

  test('should return NetworkSuccess<void> when call succeeds', () async {
    when(
      () => mockClientsRepo.deleteClient(clientId: tClientId),
    ).thenAnswer((_) async => const NetworkSuccess<void>());

    final result = await sut(tClientId);

    expect(result, isA<NetworkSuccess<void>>());
    verify(() => mockClientsRepo.deleteClient(clientId: tClientId)).called(1);
    verifyNoMoreInteractions(mockClientsRepo);
  });

  test('should return NetworkFailure<void> when call fails', () async {
    when(
      () => mockClientsRepo.deleteClient(clientId: tClientId),
    ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));

    final result = await sut(tClientId);

    expect(result, isA<NetworkFailure<void>>());
    expect((result as NetworkFailure<void>).failure, equals(tFailure));
    verify(() => mockClientsRepo.deleteClient(clientId: tClientId)).called(1);
    verifyNoMoreInteractions(mockClientsRepo);
  });
}
