import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/data/data_sources/remote/invoices_remote_data_source.dart';
import 'package:invoify/features/invoices/data/models/invoice_model.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/repo/invoices_repo.dart';

class InvoicesRepoImp implements InvoicesRepo {
  InvoicesRepoImp(this._remoteDataSource);

  final InvoicesRemoteDataSource _remoteDataSource;

  @override
  Future<NetworkResponse<List<InvoiceEntity>>> getInvoices({
    required String userId,
  }) async {
    final response = await _remoteDataSource.getInvoices(userId: userId);
    switch (response) {
      case NetworkSuccess<List<InvoiceModel>>():
        final entities =
            (response.data ?? []).map((model) => model.toEntity()).toList();
        return NetworkSuccess(entities);
      case NetworkFailure<List<InvoiceModel>>():
        return NetworkFailure(response.failure);
    }
  }

  @override
  Future<NetworkResponse<InvoiceEntity>> createInvoice({
    required InvoiceEntity invoice,
  }) async {
    final model = InvoiceModel.fromEntity(invoice);
    final response = await _remoteDataSource.createInvoice(invoice: model);
    switch (response) {
      case NetworkSuccess<InvoiceModel>():
        return NetworkSuccess(response.data!.toEntity());
      case NetworkFailure<InvoiceModel>():
        return NetworkFailure(response.failure);
    }
  }

  @override
  Future<NetworkResponse<void>> updateInvoice({
    required InvoiceEntity invoice,
  }) async =>
      await _remoteDataSource.updateInvoice(
        invoice: InvoiceModel.fromEntity(invoice),
      );

  @override
  Future<NetworkResponse<void>> deleteInvoice({
    required String invoiceId,
  }) async =>
      await _remoteDataSource.deleteInvoice(invoiceId: invoiceId);
}
