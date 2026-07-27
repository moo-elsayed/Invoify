import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/presentation/args/add_edit_invoice_args.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';

class InvoiceDetailsActionsRow extends StatelessWidget {
  const InvoiceDetailsActionsRow({super.key, required this.invoice});

  final InvoiceEntity invoice;

  void _showDeleteConfirmation(BuildContext context) {
    final cubit = context.read<InvoicesCubit>();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: AppStrings.deleteInvoice,
        subtitle: AppStrings.deleteInvoiceConfirmation,
        textConfirmButton: AppStrings.deleteInvoice,
        onConfirm: () {
          dialogContext.pop();
          cubit.deleteInvoice(invoice.invoiceId);
        },
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    final cubit = context.read<InvoicesCubit>();
    context
        .pushNamed(
          Routes.addEditInvoiceView,
          arguments: AddEditInvoiceArgs(invoice: invoice, cubit: cubit),
        )
        .then((_) => cubit.refreshLocalInvoices());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: CustomMaterialButton(
            onPressed: () => _navigateToEdit(context),
            text: AppStrings.editInvoice,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: CustomMaterialButton(
            onPressed: () => _showDeleteConfirmation(context),
            text: AppStrings.deleteInvoice,
            borderRadius: BorderRadius.circular(12.r),
            backgroundColor: colors.error,
          ),
        ),
      ],
    );
  }
}
