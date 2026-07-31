import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/data/models/invoice_model.dart';

abstract class InvoicesRemoteDataSource {
  Future<NetworkResponse<List<InvoiceModel>>> getInvoices({
    required String userId,
  });

  Stream<List<InvoiceModel>> getInvoicesStream({
    required String userId,
  });

  Future<NetworkResponse<InvoiceModel>> createInvoice({
    required InvoiceModel invoice,
  });

  Future<NetworkResponse<void>> updateInvoice({
    required InvoiceModel invoice,
  });

  Future<NetworkResponse<void>> deleteInvoice({
    required String invoiceId,
  });
}
