import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/clients/domain/repo/clients_repo.dart';
import 'package:invoify/features/clients/domain/use_cases/get_clients_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockClientsRepo extends Mock implements ClientsRepo {}

void main() {
  late GetClientsUseCase sut;
  late MockClientsRepo mockClientsRepo;

  setUp(() {
    mockClientsRepo = MockClientsRepo();
    sut = GetClientsUseCase(mockClientsRepo);
  });

  const tUserId = 'u1';
  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: tUserId,
    name: 'Jane Doe',
    email: 'jane@example.com',
    phone: '987654',
    address: '456 Ave',
    createdAt: DateTime(2026, 1, 1),
  );

  const tFailure = ServerFailure(error: 'Failed to fetch clients');

  test(
    'should return NetworkSuccess<List<ClientEntity>> when call succeeds',
    () async {
      when(
        () => mockClientsRepo.getClients(userId: tUserId),
      ).thenAnswer((_) async => NetworkSuccess([tClientEntity]));

      final result = await sut(tUserId);

      expect(result, isA<NetworkSuccess<List<ClientEntity>>>());
      expect(
        (result as NetworkSuccess<List<ClientEntity>>).data,
        equals([tClientEntity]),
      );
      verify(() => mockClientsRepo.getClients(userId: tUserId)).called(1);
      verifyNoMoreInteractions(mockClientsRepo);
    },
  );

  test(
    'should return NetworkFailure<List<ClientEntity>> when call fails',
    () async {
      when(
        () => mockClientsRepo.getClients(userId: tUserId),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut(tUserId);

      expect(result, isA<NetworkFailure<List<ClientEntity>>>());
      expect(
        (result as NetworkFailure<List<ClientEntity>>).failure,
        equals(tFailure),
      );
      verify(() => mockClientsRepo.getClients(userId: tUserId)).called(1);
      verifyNoMoreInteractions(mockClientsRepo);
    },
  );
}
