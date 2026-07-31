import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';

abstract class InvoicesRepo {
  Future<NetworkResponse<List<InvoiceEntity>>> getInvoices({
    required String userId,
  });

  Stream<List<InvoiceEntity>> getInvoicesStream({
    required String userId,
  });

  Future<NetworkResponse<InvoiceEntity>> createInvoice({
    required InvoiceEntity invoice,
  });

  Future<NetworkResponse<void>> updateInvoice({
    required InvoiceEntity invoice,
  });

  Future<NetworkResponse<void>> deleteInvoice({
    required String invoiceId,
  });
}
