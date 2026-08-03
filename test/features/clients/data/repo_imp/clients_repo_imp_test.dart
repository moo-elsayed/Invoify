import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/data/data_sources/remote/clients_remote_data_source.dart';
import 'package:invoify/features/clients/data/models/client_model.dart';
import 'package:invoify/features/clients/data/repo_imp/clients_repo_imp.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockClientsRemoteDataSource extends Mock
    implements ClientsRemoteDataSource {}

void main() {
  late MockClientsRemoteDataSource mockDataSource;
  late ClientsRepoImp sut;

  final tDate = DateTime(2026, 1, 1);
  final tClientModel = ClientModel(
    clientId: 'c1',
    userId: 'u1',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '123456',
    address: '123 St',
    createdAt: tDate,
  );

  final tClientEntity = tClientModel.toEntity();
  const tFailure = ServerFailure(error: 'Database Error');

  setUpAll(() {
    registerFallbackValue(tClientModel);
  });

  setUp(() {
    mockDataSource = MockClientsRemoteDataSource();
    sut = ClientsRepoImp(mockDataSource);
  });

  group('getClients', () {
    test(
      'should return NetworkSuccess<List<ClientEntity>> when call succeeds',
      () async {
        when(
          () => mockDataSource.getClients(userId: 'u1'),
        ).thenAnswer((_) async => NetworkSuccess([tClientModel]));

        final result = await sut.getClients(userId: 'u1');

        expect(result, isA<NetworkSuccess<List<ClientEntity>>>());
        expect(
          (result as NetworkSuccess<List<ClientEntity>>).data,
          equals([tClientEntity]),
        );
        verify(() => mockDataSource.getClients(userId: 'u1')).called(1);
      },
    );

    test('should return NetworkFailure when call fails', () async {
      when(
        () => mockDataSource.getClients(userId: 'u1'),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut.getClients(userId: 'u1');

      expect(result, isA<NetworkFailure<List<ClientEntity>>>());
      expect(
        (result as NetworkFailure<List<ClientEntity>>).failure,
        equals(tFailure),
      );
      verify(() => mockDataSource.getClients(userId: 'u1')).called(1);
    });
  });

  group('addClient', () {
    test(
      'should return NetworkSuccess<ClientEntity> when call succeeds',
      () async {
        when(
          () => mockDataSource.addClient(client: any(named: 'client')),
        ).thenAnswer((_) async => NetworkSuccess(tClientModel));

        final result = await sut.addClient(client: tClientEntity);

        expect(result, isA<NetworkSuccess<ClientEntity>>());
        expect(
          (result as NetworkSuccess<ClientEntity>).data,
          equals(tClientEntity),
        );
        verify(
          () => mockDataSource.addClient(client: any(named: 'client')),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<ClientEntity> when call fails',
      () async {
        when(
          () => mockDataSource.addClient(client: any(named: 'client')),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.addClient(client: tClientEntity);

        expect(result, isA<NetworkFailure<ClientEntity>>());
        expect(
          (result as NetworkFailure<ClientEntity>).failure,
          equals(tFailure),
        );
        verify(
          () => mockDataSource.addClient(client: any(named: 'client')),
        ).called(1);
      },
    );
  });

  group('updateClient', () {
    test('should return NetworkSuccess<void> when call succeeds', () async {
      when(
        () => mockDataSource.updateClient(client: any(named: 'client')),
      ).thenAnswer((_) async => const NetworkSuccess());

      final result = await sut.updateClient(client: tClientEntity);

      expect(result, isA<NetworkSuccess<void>>());
      verify(
        () => mockDataSource.updateClient(client: any(named: 'client')),
      ).called(1);
    });

    test('should return NetworkFailure<void> when call fails', () async {
      when(
        () => mockDataSource.updateClient(client: any(named: 'client')),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut.updateClient(client: tClientEntity);

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(
        () => mockDataSource.updateClient(client: any(named: 'client')),
      ).called(1);
    });
  });

  group('deleteClient', () {
    test('should return NetworkSuccess<void> when call succeeds', () async {
      when(
        () => mockDataSource.deleteClient(clientId: 'c1'),
      ).thenAnswer((_) async => const NetworkSuccess());

      final result = await sut.deleteClient(clientId: 'c1');

      expect(result, isA<NetworkSuccess<void>>());
      verify(() => mockDataSource.deleteClient(clientId: 'c1')).called(1);
    });

    test('should return NetworkFailure<void> when call fails', () async {
      when(
        () => mockDataSource.deleteClient(clientId: 'c1'),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut.deleteClient(clientId: 'c1');

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(() => mockDataSource.deleteClient(clientId: 'c1')).called(1);
    });
  });
}
