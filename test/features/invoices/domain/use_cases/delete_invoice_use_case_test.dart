import 'package:flutter_test/flutter_test.dart';
import 'package:invoify/core/errors/failures.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';
import 'package:invoify/features/invoices/domain/use_cases/delete_invoice_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockInvoicesRepo extends Mock implements InvoicesRepo {}

void main() {
  late DeleteInvoiceUseCase sut;
  late MockInvoicesRepo mockRepo;

  setUp(() {
    mockRepo = MockInvoicesRepo();
    sut = DeleteInvoiceUseCase(mockRepo);
  });

  const tInvoiceId = 'inv_1';
  const tFailure = ServerFailure(error: 'Failed to delete invoice');

  test('should return NetworkSuccess<void> when call succeeds', () async {
    when(
      () => mockRepo.deleteInvoice(invoiceId: tInvoiceId),
    ).thenAnswer((_) async => const NetworkSuccess());

    final result = await sut(tInvoiceId);

    expect(result, isA<NetworkSuccess<void>>());
    verify(() => mockRepo.deleteInvoice(invoiceId: tInvoiceId)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return NetworkFailure<void> when call fails', () async {
    when(
      () => mockRepo.deleteInvoice(invoiceId: tInvoiceId),
    ).thenAnswer((_) async => const NetworkFailure(tFailure));

    final result = await sut(tInvoiceId);

    expect(result, isA<NetworkFailure<void>>());
    expect((result as NetworkFailure<void>).failure, equals(tFailure));
    verify(() => mockRepo.deleteInvoice(invoiceId: tInvoiceId)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
