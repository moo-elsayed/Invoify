import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/clients/domain/entities/client_entity.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockInvoicesRepo extends Mock implements InvoicesRepo {}

void main() {
  late GetInvoicesUseCase sut;
  late MockInvoicesRepo mockRepo;

  setUp(() {
    mockRepo = MockInvoicesRepo();
    sut = GetInvoicesUseCase(mockRepo);
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

  const tFailure = ServerFailure(error: 'Failed to fetch invoices');

  test(
    'should return NetworkSuccess<List<InvoiceEntity>> when call succeeds',
    () async {
      when(
        () => mockRepo.getInvoices(userId: tUserId),
      ).thenAnswer((_) async => NetworkSuccess([tInvoiceEntity]));

      final result = await sut(tUserId);

      expect(result, isA<NetworkSuccess<List<InvoiceEntity>>>());
      expect(
        (result as NetworkSuccess<List<InvoiceEntity>>).data,
        equals([tInvoiceEntity]),
      );
      verify(() => mockRepo.getInvoices(userId: tUserId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    },
  );

  test(
    'should return NetworkFailure<List<InvoiceEntity>> when call fails',
    () async {
      when(
        () => mockRepo.getInvoices(userId: tUserId),
      ).thenAnswer((_) async => const NetworkFailure(tFailure));

      final result = await sut(tUserId);

      expect(result, isA<NetworkFailure<List<InvoiceEntity>>>());
      expect(
        (result as NetworkFailure<List<InvoiceEntity>>).failure,
        equals(tFailure),
      );
      verify(() => mockRepo.getInvoices(userId: tUserId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    },
  );
}
