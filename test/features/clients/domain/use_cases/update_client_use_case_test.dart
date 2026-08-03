import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/repo/clients_repo.dart';
import 'package:invoify/features/clients/domain/use_cases/update_client_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockClientsRepo extends Mock implements ClientsRepo {}

void main() {
  late UpdateClientUseCase sut;
  late MockClientsRepo mockClientsRepo;

  setUp(() {
    mockClientsRepo = MockClientsRepo();
    sut = UpdateClientUseCase(mockClientsRepo);
  });

  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: 'u1',
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '987654',
    address: '456 Ave',
    createdAt: DateTime(2026, 1, 1),
  );

  const tFailure = ServerFailure(error: 'Failed to update client');

  test('should return NetworkSuccess<void> when call succeeds', () async {
    when(
      () => mockClientsRepo.updateClient(client: tClientEntity),
    ).thenAnswer((_) async => const NetworkSuccess<void>());

    final result = await sut(tClientEntity);

    expect(result, isA<NetworkSuccess<void>>());
    verify(() => mockClientsRepo.updateClient(client: tClientEntity)).called(1);
    verifyNoMoreInteractions(mockClientsRepo);
  });

  test('should return NetworkFailure<void> when call fails', () async {
    when(
      () => mockClientsRepo.updateClient(client: tClientEntity),
    ).thenAnswer((_) async => const NetworkFailure<void>(tFailure));

    final result = await sut(tClientEntity);

    expect(result, isA<NetworkFailure<void>>());
    expect((result as NetworkFailure<void>).failure, equals(tFailure));
    verify(() => mockClientsRepo.updateClient(client: tClientEntity)).called(1);
    verifyNoMoreInteractions(mockClientsRepo);
  });
}
