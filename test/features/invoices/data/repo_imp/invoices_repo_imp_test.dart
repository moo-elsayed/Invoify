import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/data/models/client_model.dart';
import 'package:invoify/features/invoices/data/data_sources/remote/invoices_remote_data_source.dart';
import 'package:invoify/features/invoices/data/models/invoice_model.dart';
import 'package:invoify/features/invoices/data/repo_imp/invoices_repo_imp.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:mocktail/mocktail.dart';

class MockInvoicesRemoteDataSource extends Mock
    implements InvoicesRemoteDataSource {}

void main() {
  late MockInvoicesRemoteDataSource mockDataSource;
  late InvoicesRepoImp sut;

  final tDate = DateTime(2026, 1, 1);
  final tClientModel = ClientModel(
    clientId: 'c1',
    userId: 'u1',
    name: 'Client Name',
    email: 'client@test.com',
    phone: '123456',
    address: '123 St',
    createdAt: tDate,
  );

  final tInvoiceModel = InvoiceModel(
    invoiceId: 'inv_1',
    userId: 'u1',
    invoiceNumber: 'INV-001',
    client: tClientModel,
    issueDate: tDate,
    dueDate: tDate,
    items: [],
    subtotal: 100.0,
    taxRate: 14.0,
    taxAmount: 14.0,
    discountRate: 0.0,
    discountAmount: 0.0,
    totalAmount: 114.0,
    status: InvoiceStatus.draft,
    notes: '',
    createdAt: tDate,
  );

  final tInvoiceEntity = tInvoiceModel.toEntity();
  const tFailure = ServerFailure(error: 'Database Error');

  setUpAll(() {
    registerFallbackValue(tInvoiceModel);
  });

  setUp(() {
    mockDataSource = MockInvoicesRemoteDataSource();
    sut = InvoicesRepoImp(mockDataSource);
  });

  group('getInvoices', () {
    test(
      'should return NetworkSuccess<List<InvoiceEntity>> when call succeeds',
      () async {
        when(
          () => mockDataSource.getInvoices(userId: 'u1'),
        ).thenAnswer((_) async => NetworkSuccess([tInvoiceModel]));

        final result = await sut.getInvoices(userId: 'u1');

        expect(result, isA<NetworkSuccess<List<InvoiceEntity>>>());
        expect(
          (result as NetworkSuccess<List<InvoiceEntity>>).data,
          equals([tInvoiceEntity]),
        );
        verify(() => mockDataSource.getInvoices(userId: 'u1')).called(1);
      },
    );

    test('should return NetworkFailure when call fails', () async {
      when(
        () => mockDataSource.getInvoices(userId: 'u1'),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut.getInvoices(userId: 'u1');

      expect(result, isA<NetworkFailure<List<InvoiceEntity>>>());
      expect(
        (result as NetworkFailure<List<InvoiceEntity>>).failure,
        equals(tFailure),
      );
      verify(() => mockDataSource.getInvoices(userId: 'u1')).called(1);
    });
  });

  group('getInvoicesStream', () {
    test(
      'should emit stream of mapped List<InvoiceEntity> when remote data source emits List<InvoiceModel>',
      () {
        when(
          () => mockDataSource.getInvoicesStream(userId: 'u1'),
        ).thenAnswer((_) => Stream.value([tInvoiceModel]));

        final resultStream = sut.getInvoicesStream(userId: 'u1');

        expect(resultStream, emits([tInvoiceEntity]));
        verify(() => mockDataSource.getInvoicesStream(userId: 'u1')).called(1);
      },
    );
  });

  group('createInvoice', () {
    test(
      'should return NetworkSuccess<InvoiceEntity> when call succeeds',
      () async {
        when(
          () => mockDataSource.createInvoice(invoice: any(named: 'invoice')),
        ).thenAnswer((_) async => NetworkSuccess(tInvoiceModel));

        final result = await sut.createInvoice(invoice: tInvoiceEntity);

        expect(result, isA<NetworkSuccess<InvoiceEntity>>());
        expect(
          (result as NetworkSuccess<InvoiceEntity>).data,
          equals(tInvoiceEntity),
        );
        verify(
          () => mockDataSource.createInvoice(invoice: any(named: 'invoice')),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure<InvoiceEntity> when call fails',
      () async {
        when(
          () => mockDataSource.createInvoice(invoice: any(named: 'invoice')),
        ).thenAnswer((_) async => const NetworkFailure(tFailure));

        final result = await sut.createInvoice(invoice: tInvoiceEntity);

        expect(result, isA<NetworkFailure<InvoiceEntity>>());
        expect(
          (result as NetworkFailure<InvoiceEntity>).failure,
          equals(tFailure),
        );
        verify(
          () => mockDataSource.createInvoice(invoice: any(named: 'invoice')),
        ).called(1);
      },
    );
  });

  group('updateInvoice', () {
    test('should return NetworkSuccess<void> when call succeeds', () async {
      when(
        () => mockDataSource.updateInvoice(invoice: any(named: 'invoice')),
      ).thenAnswer((_) async => const NetworkSuccess());

      final result = await sut.updateInvoice(invoice: tInvoiceEntity);

      expect(result, isA<NetworkSuccess<void>>());
      verify(
        () => mockDataSource.updateInvoice(invoice: any(named: 'invoice')),
      ).called(1);
    });

    test('should return NetworkFailure<void> when call fails', () async {
      when(
        () => mockDataSource.updateInvoice(invoice: any(named: 'invoice')),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut.updateInvoice(invoice: tInvoiceEntity);

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(
        () => mockDataSource.updateInvoice(invoice: any(named: 'invoice')),
      ).called(1);
    });
  });

  group('deleteInvoice', () {
    test('should return NetworkSuccess<void> when call succeeds', () async {
      when(
        () => mockDataSource.deleteInvoice(invoiceId: 'inv_1'),
      ).thenAnswer((_) async => const NetworkSuccess());

      final result = await sut.deleteInvoice(invoiceId: 'inv_1');

      expect(result, isA<NetworkSuccess<void>>());
      verify(() => mockDataSource.deleteInvoice(invoiceId: 'inv_1')).called(1);
    });

    test('should return NetworkFailure<void> when call fails', () async {
      when(
        () => mockDataSource.deleteInvoice(invoiceId: 'inv_1'),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut.deleteInvoice(invoiceId: 'inv_1');

      expect(result, isA<NetworkFailure<void>>());
      expect((result as NetworkFailure<void>).failure, equals(tFailure));
      verify(() => mockDataSource.deleteInvoice(invoiceId: 'inv_1')).called(1);
    });
  });
}
