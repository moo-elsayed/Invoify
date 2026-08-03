import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';

class InvoiceDetailsArgs {
  const InvoiceDetailsArgs({required this.invoice, required this.cubit});

  final InvoiceEntity invoice;
  final InvoicesCubit cubit;
}
