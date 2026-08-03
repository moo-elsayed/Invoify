import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';
import 'package:invoify/features/invoices/domain/use_cases/update_invoice_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockInvoicesRepo extends Mock implements InvoicesRepo {}

void main() {
  late UpdateInvoiceUseCase sut;
  late MockInvoicesRepo mockRepo;

  setUp(() {
    mockRepo = MockInvoicesRepo();
    sut = UpdateInvoiceUseCase(mockRepo);
  });

  final tDate = DateTime(2026, 1, 1);
  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: 'u1',
    name: 'Client Name',
    email: 'client@test.com',
    phone: '123456',
    address: '123 St',
    createdAt: tDate,
  );

  final tInvoiceEntity = InvoiceEntity(
    invoiceId: 'inv_1',
    userId: 'u1',
    invoiceNumber: 'INV-001',
    client: tClientEntity,
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

  const tFailure = ServerFailure(error: 'Failed to update invoice');

  test('should return NetworkSuccess<void> when call succeeds', () async {
    when(
      () => mockRepo.updateInvoice(invoice: tInvoiceEntity),
    ).thenAnswer((_) async => const NetworkSuccess());

    final result = await sut(tInvoiceEntity);

    expect(result, isA<NetworkSuccess<void>>());
    verify(() => mockRepo.updateInvoice(invoice: tInvoiceEntity)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return NetworkFailure<void> when call fails', () async {
    when(
      () => mockRepo.updateInvoice(invoice: tInvoiceEntity),
    ).thenAnswer((_) async => const NetworkFailure(tFailure));

    final result = await sut(tInvoiceEntity);

    expect(result, isA<NetworkFailure<void>>());
    expect((result as NetworkFailure<void>).failure, equals(tFailure));
    verify(() => mockRepo.updateInvoice(invoice: tInvoiceEntity)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
