import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';

class UpdateInvoiceUseCase {
  UpdateInvoiceUseCase(this._invoicesRepo);

  final InvoicesRepo _invoicesRepo;

  Future<NetworkResponse<void>> call(InvoiceEntity invoice) async =>
      await _invoicesRepo.updateInvoice(invoice: invoice);
}
