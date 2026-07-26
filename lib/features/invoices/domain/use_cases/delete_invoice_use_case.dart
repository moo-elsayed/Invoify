import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';

class DeleteInvoiceUseCase {
  DeleteInvoiceUseCase(this._invoicesRepo);

  final InvoicesRepo _invoicesRepo;

  Future<NetworkResponse<void>> call(String invoiceId) async =>
      await _invoicesRepo.deleteInvoice(invoiceId: invoiceId);
}
