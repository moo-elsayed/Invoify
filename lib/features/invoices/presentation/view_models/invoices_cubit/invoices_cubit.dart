import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/network/network_response.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/use_cases/create_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/delete_invoice_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/get_invoices_use_case.dart';
import 'package:invoify/features/invoices/domain/use_cases/update_invoice_use_case.dart';
import 'invoices_state.dart';

class InvoicesCubit extends Cubit<InvoicesState> {
  InvoicesCubit(
    this._getInvoicesUseCase,
    this._createInvoiceUseCase,
    this._updateInvoiceUseCase,
    this._deleteInvoiceUseCase,
  ) : super(const InvoicesInitial());

  final GetInvoicesUseCase _getInvoicesUseCase;
  final CreateInvoiceUseCase _createInvoiceUseCase;
  final UpdateInvoiceUseCase _updateInvoiceUseCase;
  final DeleteInvoiceUseCase _deleteInvoiceUseCase;

  List<InvoiceEntity> _allInvoices = [];
  List<InvoiceEntity> get allInvoices => _allInvoices;

  Future<void> getInvoices() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    emit(const InvoicesLoading());

    final response = await _getInvoicesUseCase(firebaseUser.uid);
    switch (response) {
      case NetworkSuccess<List<InvoiceEntity>>():
        _allInvoices = response.data ?? [];
        emit(InvoicesSuccess(_allInvoices));
      case NetworkFailure<List<InvoiceEntity>>():
        emit(InvoicesFailure(response.error));
    }
  }

  Future<void> createInvoice(InvoiceEntity invoice) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    emit(const InvoicesLoading());

    final invoiceToCreate = invoice.copyWith(
      userId: firebaseUser.uid,
      createdAt: DateTime.now(),
    );

    final response = await _createInvoiceUseCase(invoiceToCreate);
    switch (response) {
      case NetworkSuccess<InvoiceEntity>():
        if (response.data != null) {
          _allInvoices.insert(0, response.data!);
        }
        emit(InvoiceActionSuccess(AppStrings.invoiceCreatedSuccessfully));
      case NetworkFailure<InvoiceEntity>():
        emit(InvoicesFailure(response.error));
    }
  }

  Future<void> updateInvoice(InvoiceEntity invoice) async {
    emit(const InvoicesLoading());

    final response = await _updateInvoiceUseCase(invoice);
    switch (response) {
      case NetworkSuccess<void>():
        final index = _allInvoices.indexWhere(
          (inv) => inv.invoiceId == invoice.invoiceId,
        );
        if (index != -1) {
          _allInvoices[index] = invoice;
        }
        emit(InvoiceActionSuccess(AppStrings.saveChanges));
      case NetworkFailure<void>():
        emit(InvoicesFailure(response.error));
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    emit(const InvoicesLoading());

    final response = await _deleteInvoiceUseCase(invoiceId);
    switch (response) {
      case NetworkSuccess<void>():
        _allInvoices.removeWhere((inv) => inv.invoiceId == invoiceId);
        emit(InvoicesSuccess(List.from(_allInvoices)));
      case NetworkFailure<void>():
        emit(InvoicesFailure(response.error));
    }
  }
}
