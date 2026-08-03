import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';

class GetInvoicesStreamUseCase {
  GetInvoicesStreamUseCase(this._invoicesRepo);

  final InvoicesRepo _invoicesRepo;

  Stream<List<InvoiceEntity>> call(String userId) =>
      _invoicesRepo.getInvoicesStream(userId: userId);
}
