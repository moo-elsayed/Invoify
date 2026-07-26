import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';

class GetInvoicesUseCase {
  GetInvoicesUseCase(this._invoicesRepo);

  final InvoicesRepo _invoicesRepo;

  Future<NetworkResponse<List<InvoiceEntity>>> call(String userId) async =>
      await _invoicesRepo.getInvoices(userId: userId);
}
