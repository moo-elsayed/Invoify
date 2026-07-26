import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';

class CreateInvoiceUseCase {
  CreateInvoiceUseCase(this._invoicesRepo);

  final InvoicesRepo _invoicesRepo;

  Future<NetworkResponse<InvoiceEntity>> call(InvoiceEntity invoice) async =>
      await _invoicesRepo.createInvoice(invoice: invoice);
}
