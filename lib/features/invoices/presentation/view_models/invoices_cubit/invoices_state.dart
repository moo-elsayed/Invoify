import 'package:equatable/equatable.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';

sealed class InvoicesState extends Equatable {
  const InvoicesState();

  @override
  List<Object?> get props => [];
}

final class InvoicesInitial extends InvoicesState {
  const InvoicesInitial();
}

final class InvoicesLoading extends InvoicesState {
  const InvoicesLoading();
}

final class InvoicesSuccess extends InvoicesState {
  const InvoicesSuccess(this.invoices);

  final List<InvoiceEntity> invoices;

  @override
  List<Object?> get props => [invoices];
}

final class InvoiceActionSuccess extends InvoicesState {
  const InvoiceActionSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class InvoicesFailure extends InvoicesState {
  const InvoicesFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
