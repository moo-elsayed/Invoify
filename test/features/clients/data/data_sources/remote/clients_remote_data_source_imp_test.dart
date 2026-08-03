import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/data/data_sources/remote/clients_remote_data_source_imp.dart';
import 'package:invoify/features/clients/data/models/client_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late ClientsRemoteDataSourceImp sut;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockFirestore = MockFirebaseFirestore();
    sut = ClientsRemoteDataSourceImp(firestore: fakeFirestore);
  });

  final tClient1 = ClientModel(
    clientId: 'c1',
    userId: 'u1',
    name: 'Client One',
    email: 'c1@test.com',
    phone: '123456',
    address: 'Street 1',
    createdAt: DateTime(2026, 1, 1),
  );

  final tClient2 = ClientModel(
    clientId: 'c2',
    userId: 'u1',
    name: 'Client Two',
    email: 'c2@test.com',
    phone: '654321',
    address: 'Street 2',
    createdAt: DateTime(2026, 1, 2),
  );

  final tClientOtherUser = ClientModel(
    clientId: 'c3',
    userId: 'u2',
    name: 'Client Three',
    email: 'c3@test.com',
    phone: '999999',
    address: 'Street 3',
    createdAt: DateTime(2026, 1, 3),
  );

  group('getClients', () {
    test(
      'should return list of clients for specific userId ordered by createdAt descending',
      () async {
        await fakeFirestore
            .collection('clients')
            .doc(tClient1.clientId)
            .set(tClient1.toJson());
        await fakeFirestore
            .collection('clients')
            .doc(tClient2.clientId)
            .set(tClient2.toJson());
        await fakeFirestore
            .collection('clients')
            .doc(tClientOtherUser.clientId)
            .set(tClientOtherUser.toJson());

        final result = await sut.getClients(userId: 'u1');

        expect(result, isA<NetworkSuccess<List<ClientModel>>>());
        final clients = (result as NetworkSuccess<List<ClientModel>>).data;
        expect(clients?.length, equals(2));
        expect(clients?[0].clientId, equals('c2'));
        expect(clients?[1].clientId, equals('c1'));
      },
    );

    test(
      'should return empty list when no clients exist for specified userId',
      () async {
        final result = await sut.getClients(userId: 'non_existing_user');

        expect(result, isA<NetworkSuccess<List<ClientModel>>>());
        final clients = (result as NetworkSuccess<List<ClientModel>>).data;
        expect(clients, isEmpty);
      },
    );

    test(
      'should return NetworkFailure when Firestore throws an exception',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = ClientsRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.getClients(userId: 'u1');

        expect(result, isA<NetworkFailure<List<ClientModel>>>());
      },
    );
  });

  group('addClient', () {
    test(
      'should add client to fake Firestore and return NetworkSuccess<ClientModel> with generated ID',
      () async {
        final newClientInput = ClientModel(
          clientId: '',
          userId: 'u1',
          name: 'New Client',
          email: 'new@test.com',
          phone: '123',
          address: 'Addr',
          createdAt: DateTime(2026, 1, 1),
        );

        final result = await sut.addClient(client: newClientInput);

        expect(result, isA<NetworkSuccess<ClientModel>>());
        final addedClient = (result as NetworkSuccess<ClientModel>).data;
        expect(addedClient?.clientId, isNotEmpty);
        expect(addedClient?.name, equals('New Client'));

        final snapshot = await fakeFirestore
            .collection('clients')
            .doc(addedClient!.clientId)
            .get();
        expect(snapshot.exists, isTrue);
        expect(snapshot.data()?['name'], equals('New Client'));
        expect(snapshot.data()?['userId'], equals('u1'));
      },
    );

    test(
      'should return NetworkFailure when Firestore throws an exception on addClient',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = ClientsRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.addClient(client: tClient1);

        expect(result, isA<NetworkFailure<ClientModel>>());
      },
    );
  });

  group('updateClient', () {
    test('should update existing client document in fake Firestore', () async {
      await fakeFirestore
          .collection('clients')
          .doc(tClient1.clientId)
          .set(tClient1.toJson());

      final updatedClient = ClientModel(
        clientId: tClient1.clientId,
        userId: tClient1.userId,
        name: 'Updated Name',
        email: tClient1.email,
        phone: '000000',
        address: tClient1.address,
        createdAt: tClient1.createdAt,
      );

      final result = await sut.updateClient(client: updatedClient);

      expect(result, isA<NetworkSuccess<void>>());

      final snapshot = await fakeFirestore
          .collection('clients')
          .doc(tClient1.clientId)
          .get();
      expect(snapshot.data()?['name'], equals('Updated Name'));
      expect(snapshot.data()?['phone'], equals('000000'));
    });

    test(
      'should return NetworkFailure when Firestore throws an exception on updateClient',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = ClientsRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.updateClient(client: tClient1);

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });

  group('deleteClient', () {
    test('should delete client document from fake Firestore', () async {
      await fakeFirestore
          .collection('clients')
          .doc(tClient1.clientId)
          .set(tClient1.toJson());

      final result = await sut.deleteClient(clientId: tClient1.clientId);

      expect(result, isA<NetworkSuccess<void>>());

      final snapshot = await fakeFirestore
          .collection('clients')
          .doc(tClient1.clientId)
          .get();
      expect(snapshot.exists, isFalse);
    });

    test(
      'should return NetworkFailure when Firestore throws an exception on deleteClient',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = ClientsRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.deleteClient(clientId: 'c1');

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });
}
