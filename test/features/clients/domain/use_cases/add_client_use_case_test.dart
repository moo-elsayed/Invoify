import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/repo/clients_repo.dart';
import 'package:invoify/features/clients/domain/use_cases/add_client_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockClientsRepo extends Mock implements ClientsRepo {}

void main() {
  late AddClientUseCase sut;
  late MockClientsRepo mockClientsRepo;

  setUp(() {
    mockClientsRepo = MockClientsRepo();
    sut = AddClientUseCase(mockClientsRepo);
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

  const tFailure = ServerFailure(error: 'Failed to add client');

  test(
    'should return NetworkSuccess<ClientEntity> when call succeeds',
    () async {
      when(
        () => mockClientsRepo.addClient(client: tClientEntity),
      ).thenAnswer((_) async => NetworkSuccess(tClientEntity));

      final result = await sut(tClientEntity);

      expect(result, isA<NetworkSuccess<ClientEntity>>());
      expect(
        (result as NetworkSuccess<ClientEntity>).data,
        equals(tClientEntity),
      );
      verify(() => mockClientsRepo.addClient(client: tClientEntity)).called(1);
      verifyNoMoreInteractions(mockClientsRepo);
    },
  );

  test('should return NetworkFailure<ClientEntity> when call fails', () async {
    when(
      () => mockClientsRepo.addClient(client: tClientEntity),
    ).thenAnswer((_) async => const NetworkFailure(tFailure));

    final result = await sut(tClientEntity);

    expect(result, isA<NetworkFailure<ClientEntity>>());
    expect((result as NetworkFailure<ClientEntity>).failure, equals(tFailure));
    verify(() => mockClientsRepo.addClient(client: tClientEntity)).called(1);
    verifyNoMoreInteractions(mockClientsRepo);
  });
}
