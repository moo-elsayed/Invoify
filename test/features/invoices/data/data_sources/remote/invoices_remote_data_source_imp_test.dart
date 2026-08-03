import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/data/models/client_model.dart';
import 'package:invoify/features/invoices/data/data_sources/remote/invoices_remote_data_source_imp.dart';
import 'package:invoify/features/invoices/data/models/invoice_model.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late InvoicesRemoteDataSourceImp sut;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockFirestore = MockFirebaseFirestore();
    sut = InvoicesRemoteDataSourceImp(firestore: fakeFirestore);
  });

  final tDate1 = DateTime(2026, 1, 1, 10, 0);
  final tDate2 = DateTime(2026, 1, 2, 10, 0);

  final tClientModel = ClientModel(
    clientId: 'c1',
    userId: 'u1',
    name: 'Client Name',
    email: 'client@test.com',
    phone: '123456',
    address: '123 St',
    createdAt: tDate1,
  );

  final tInvoiceModel1 = InvoiceModel(
    invoiceId: 'inv_1',
    userId: 'u1',
    invoiceNumber: 'INV-001',
    client: tClientModel,
    issueDate: tDate1,
    dueDate: tDate1,
    items: [],
    subtotal: 100.0,
    taxRate: 14.0,
    taxAmount: 14.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 114.0,
    status: InvoiceStatus.draft,
    notes: 'Note 1',
    createdAt: tDate1,
  );

  final tInvoiceModel2 = InvoiceModel(
    invoiceId: 'inv_2',
    userId: 'u1',
    invoiceNumber: 'INV-002',
    client: tClientModel,
    issueDate: tDate2,
    dueDate: tDate2,
    items: [],
    subtotal: 200.0,
    taxRate: 14.0,
    taxAmount: 28.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 228.0,
    status: InvoiceStatus.sent,
    notes: 'Note 2',
    createdAt: tDate2,
  );

  final tOtherUserInvoiceModel = InvoiceModel(
    invoiceId: 'inv_3',
    userId: 'u2',
    invoiceNumber: 'INV-003',
    client: tClientModel,
    issueDate: tDate1,
    dueDate: tDate1,
    items: [],
    subtotal: 50.0,
    taxRate: 0.0,
    taxAmount: 0.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 50.0,
    status: InvoiceStatus.draft,
    notes: 'Other user',
    createdAt: tDate1,
  );

  group('getInvoices', () {
    test(
      'should return NetworkSuccess<List<InvoiceModel>> matching userId ordered by createdAt desc',
      () async {
        await fakeFirestore
            .collection('invoices')
            .doc(tInvoiceModel1.invoiceId)
            .set(tInvoiceModel1.toJson());
        await fakeFirestore
            .collection('invoices')
            .doc(tInvoiceModel2.invoiceId)
            .set(tInvoiceModel2.toJson());
        await fakeFirestore
            .collection('invoices')
            .doc(tOtherUserInvoiceModel.invoiceId)
            .set(tOtherUserInvoiceModel.toJson());

        final result = await sut.getInvoices(userId: 'u1');

        expect(result, isA<NetworkSuccess<List<InvoiceModel>>>());
        final invoices = (result as NetworkSuccess<List<InvoiceModel>>).data;
        expect(invoices?.length, equals(2));
        expect(invoices?[0].invoiceId, equals('inv_2'));
        expect(invoices?[1].invoiceId, equals('inv_1'));
      },
    );

    test(
      'should return empty list when no invoices exist for userId',
      () async {
        final result = await sut.getInvoices(userId: 'non_existent_user');

        expect(result, isA<NetworkSuccess<List<InvoiceModel>>>());
        final invoices = (result as NetworkSuccess<List<InvoiceModel>>).data;
        expect(invoices, isEmpty);
      },
    );

    test(
      'should return NetworkFailure when Firestore throws an exception on getInvoices',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = InvoicesRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.getInvoices(userId: 'u1');

        expect(result, isA<NetworkFailure<List<InvoiceModel>>>());
      },
    );
  });

  group('getInvoicesStream', () {
    test(
      'should emit stream of invoices matching userId ordered by createdAt desc',
      () async {
        await fakeFirestore
            .collection('invoices')
            .doc(tInvoiceModel1.invoiceId)
            .set(tInvoiceModel1.toJson());

        final stream = sut.getInvoicesStream(userId: 'u1');

        expect(
          stream,
          emitsInOrder([
            predicate<List<InvoiceModel>>(
              (list) => list.length == 1 && list.first.invoiceId == 'inv_1',
            ),
            predicate<List<InvoiceModel>>(
              (list) => list.length == 2 && list.first.invoiceId == 'inv_2',
            ),
          ]),
        );

        await fakeFirestore
            .collection('invoices')
            .doc(tInvoiceModel2.invoiceId)
            .set(tInvoiceModel2.toJson());
      },
    );
  });

  group('createInvoice', () {
    test(
      'should create invoice in fake firestore and return NetworkSuccess with generated invoiceId',
      () async {
        final result = await sut.createInvoice(invoice: tInvoiceModel1);

        expect(result, isA<NetworkSuccess<InvoiceModel>>());
        final created = (result as NetworkSuccess<InvoiceModel>).data;
        expect(created, isNotNull);
        expect(created!.invoiceId, isNotEmpty);
        expect(created.invoiceNumber, equals('INV-001'));

        final docSnapshot = await fakeFirestore
            .collection('invoices')
            .doc(created.invoiceId)
            .get();
        expect(docSnapshot.exists, isTrue);
        expect(docSnapshot.data()?['userId'], equals('u1'));
      },
    );

    test(
      'should return NetworkFailure when Firestore throws an exception on createInvoice',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = InvoicesRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.createInvoice(invoice: tInvoiceModel1);

        expect(result, isA<NetworkFailure<InvoiceModel>>());
      },
    );
  });

  group('updateInvoice', () {
    test('should update existing invoice document in fake firestore', () async {
      await fakeFirestore
          .collection('invoices')
          .doc(tInvoiceModel1.invoiceId)
          .set(tInvoiceModel1.toJson());

      final updatedInvoice = tInvoiceModel1.copyWith(
        status: InvoiceStatus.paid,
        notes: 'Updated Note',
      );

      final result = await sut.updateInvoice(invoice: updatedInvoice);

      expect(result, isA<NetworkSuccess<void>>());

      final docSnapshot = await fakeFirestore
          .collection('invoices')
          .doc(tInvoiceModel1.invoiceId)
          .get();
      expect(docSnapshot.data()?['status'], equals('paid'));
      expect(docSnapshot.data()?['notes'], equals('Updated Note'));
    });

    test(
      'should return NetworkFailure when Firestore throws an exception on updateInvoice',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = InvoicesRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.updateInvoice(invoice: tInvoiceModel1);

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });

  group('deleteInvoice', () {
    test(
      'should delete existing invoice document from fake firestore',
      () async {
        await fakeFirestore
            .collection('invoices')
            .doc(tInvoiceModel1.invoiceId)
            .set(tInvoiceModel1.toJson());

        final result = await sut.deleteInvoice(
          invoiceId: tInvoiceModel1.invoiceId,
        );

        expect(result, isA<NetworkSuccess<void>>());

        final docSnapshot = await fakeFirestore
            .collection('invoices')
            .doc(tInvoiceModel1.invoiceId)
            .get();
        expect(docSnapshot.exists, isFalse);
      },
    );

    test(
      'should return NetworkFailure when Firestore throws an exception on deleteInvoice',
      () async {
        when(() => mockFirestore.collection(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );
        final mockSut = InvoicesRemoteDataSourceImp(firestore: mockFirestore);

        final result = await mockSut.deleteInvoice(invoiceId: 'inv_1');

        expect(result, isA<NetworkFailure<void>>());
      },
    );
  });
}
