import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoify/core/network/api_helper.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/data/models/invoice_model.dart';
import 'invoices_remote_data_source.dart';

class InvoicesRemoteDataSourceImp implements InvoicesRemoteDataSource {
  InvoicesRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _invoicesCollection = 'invoices';

  @override
  Future<NetworkResponse<List<InvoiceModel>>> getInvoices({
    required String userId,
  }) async => ApiHelper.executeSafely(() async {
    final querySnapshot = await _firestore
        .collection(_invoicesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    final invoices = querySnapshot.docs
        .map((doc) => InvoiceModel.fromJson(doc.data(), docId: doc.id))
        .toList();

    return invoices;
  }, functionName: 'getInvoices');

  @override
  Stream<List<InvoiceModel>> getInvoicesStream({
    required String userId,
  }) =>
      _firestore
          .collection(_invoicesCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => InvoiceModel.fromJson(doc.data(), docId: doc.id))
                .toList(),
          );

  @override
  Future<NetworkResponse<InvoiceModel>> createInvoice({
    required InvoiceModel invoice,
  }) async => ApiHelper.executeSafely(() async {
    final docRef = _firestore.collection(_invoicesCollection).doc();
    final newInvoice = invoice.copyWith(invoiceId: docRef.id);
    await docRef.set(newInvoice.toJson());
    return newInvoice;
  }, functionName: 'createInvoice');

  @override
  Future<NetworkResponse<void>> updateInvoice({
    required InvoiceModel invoice,
  }) async => ApiHelper.executeSafely(() async {
    await _firestore
        .collection(_invoicesCollection)
        .doc(invoice.invoiceId)
        .update(invoice.toJson());
  }, functionName: 'updateInvoice');

  @override
  Future<NetworkResponse<void>> deleteInvoice({
    required String invoiceId,
  }) async => ApiHelper.executeSafely(() async {
    await _firestore.collection(_invoicesCollection).doc(invoiceId).delete();
  }, functionName: 'deleteInvoice');
}
