import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_stream_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockInvoicesRepo extends Mock implements InvoicesRepo {}

void main() {
  late GetInvoicesStreamUseCase sut;
  late MockInvoicesRepo mockRepo;

  setUp(() {
    mockRepo = MockInvoicesRepo();
    sut = GetInvoicesStreamUseCase(mockRepo);
  });

  const tUserId = 'u1';
  final tDate = DateTime(2026, 1, 1);
  final tClientEntity = ClientEntity(
    clientId: 'c1',
    userId: tUserId,
    name: 'Client Name',
    email: 'client@test.com',
    phone: '123456',
    address: '123 St',
    createdAt: tDate,
  );

  final tInvoiceEntity = InvoiceEntity(
    invoiceId: 'inv_1',
    userId: tUserId,
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

  test('should forward stream from repository when call is invoked', () {
    when(
      () => mockRepo.getInvoicesStream(userId: tUserId),
    ).thenAnswer((_) => Stream.value([tInvoiceEntity]));

    final resultStream = sut(tUserId);

    expect(resultStream, emits([tInvoiceEntity]));
    verify(() => mockRepo.getInvoicesStream(userId: tUserId)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
