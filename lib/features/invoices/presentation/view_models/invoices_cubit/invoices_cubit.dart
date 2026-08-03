import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/domain/use_cases/create_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/delete_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_stream_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/update_invoice_use_case.dart';
import 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit(
    this._getInvoicesStreamUseCase,
    this._createInvoiceUseCase,
    this._updateInvoiceUseCase,
    this._deleteInvoiceUseCase, {
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       super(const InvoicesInitial());

  final GetInvoicesStreamUseCase _getInvoicesStreamUseCase;
  final CreateInvoiceUseCase _createInvoiceUseCase;
  final UpdateInvoiceUseCase _updateInvoiceUseCase;
  final DeleteInvoiceUseCase _deleteInvoiceUseCase;
  final FirebaseAuth _firebaseAuth;

  List<InvoiceEntity> _allInvoices = [];
  List<InvoiceEntity> get allInvoices => _allInvoices;

  StreamSubscription<List<InvoiceEntity>>? _invoicesSubscription;

  void refreshLocalInvoices() {
    emit(InvoicesSuccess(List.from(_allInvoices)));
  }

  Future<void> getInvoices() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    emit(const InvoicesLoading());

    await _invoicesSubscription?.cancel();
    _invoicesSubscription = _getInvoicesStreamUseCase(firebaseUser.uid).listen(
      (invoices) {
        _allInvoices = invoices;
        emit(InvoicesSuccess(List.from(_allInvoices)));
      },
      onError: (error) {
        emit(InvoicesFailure(error.toString()));
      },
    );
  }

  Future<void> createInvoice(InvoiceEntity invoice) async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    final invoiceToCreate = invoice.copyWith(
      userId: firebaseUser.uid,
      createdAt: DateTime.now(),
    );

    final response = await _createInvoiceUseCase(invoiceToCreate);
    switch (response) {
      case NetworkSuccess<InvoiceEntity>():
        emit(InvoiceActionSuccess(AppStrings.invoiceCreatedSuccessfully));
      case NetworkFailure<InvoiceEntity>():
        emit(InvoicesFailure(response.error));
    }
  }

  Future<void> updateInvoice(InvoiceEntity invoice) async {
    final response = await _updateInvoiceUseCase(invoice);
    switch (response) {
      case NetworkSuccess<void>():
        final message = invoice.status == InvoiceStatus.sent
            ? AppStrings.invoiceSentSuccessfully
            : AppStrings.invoiceUpdatedSuccessfully;
        emit(InvoiceActionSuccess(message));
      case NetworkFailure<void>():
        emit(InvoicesFailure(response.error));
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    final response = await _deleteInvoiceUseCase(invoiceId);
    switch (response) {
      case NetworkSuccess<void>():
        emit(InvoicesSuccess(List.from(_allInvoices)));
      case NetworkFailure<void>():
        emit(InvoicesFailure(response.error));
    }
  }

  @override
  Future<void> close() {
    _invoicesSubscription?.cancel();
    return super.close();
  }
}
