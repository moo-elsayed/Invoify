import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late SettingsRemoteDataSourceImp sut;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockFirestore = MockFirebaseFirestore();
    sut = SettingsRemoteDataSourceImp(firestore: fakeFirestore);
  });

  const tUid = 'u1';

  group('updateCurrency', () {
    test(
      'should update currency field in fake firestore document and return NetworkSuccess<void>',
      () async {
        await fakeFirestore.collection('users').doc(tUid).set({
          'currency': 'USD',
          'businessName': 'Old Corp',
        });

        final result = await sut.updateCurrency(uid: tUid, currency: 'EUR');

        expect(result, isA<NetworkSuccess<void>>());

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(tUid)
            .get();
        expect(snapshot.data()?['currency'], equals('EUR'));
      },
    );

    test(
      'should return NetworkFailure<void> when Firestore throws an exception on updateCurrency',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = SettingsRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.updateCurrency(uid: tUid, currency: 'EUR');

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });

  group('updateBusinessName', () {
    test(
      'should update businessName field in fake firestore document and return NetworkSuccess<void>',
      () async {
        await fakeFirestore.collection('users').doc(tUid).set({
          'currency': 'USD',
          'businessName': 'Old Corp',
        });

        final result = await sut.updateBusinessName(
          uid: tUid,
          businessName: 'New Corp',
        );

        expect(result, isA<NetworkSuccess<void>>());

        final snapshot = await fakeFirestore
            .collection('users')
            .doc(tUid)
            .get();
        expect(snapshot.data()?['businessName'], equals('New Corp'));
      },
    );

    test(
      'should return NetworkFailure<void> when Firestore throws an exception on updateBusinessName',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = SettingsRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.updateBusinessName(
          uid: tUid,
          businessName: 'New Corp',
        );

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });
}
