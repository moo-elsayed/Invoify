import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_material_button.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/args/add_edit_invoice_args.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:toastification/toastification.dart';

class InvoiceDetailsActionsRow extends StatelessWidget {
  const InvoiceDetailsActionsRow({super.key, required this.invoice});

  final InvoiceEntity invoice;

  void _onSendInvoice(BuildContext context) {
    final cubit = context.read<InvoicesCubit>();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: AppStrings.sendInvoice,
        subtitle: AppStrings.confirmSendInvoiceSubtitle,
        textConfirmButton: AppStrings.sendInvoice,
        onConfirm: () {
          dialogContext.pop();
          final updatedInvoice = invoice.copyWith(status: InvoiceStatus.sent);
          cubit.updateInvoice(updatedInvoice);
        },
      ),
    );
  }

  void _onMarkAsPaid(BuildContext context) {
    final cubit = context.read<InvoicesCubit>();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: AppStrings.confirmPaymentTitle,
        subtitle: AppStrings.confirmPaymentSubtitle,
        textConfirmButton: AppStrings.confirmPaymentButton,
        onConfirm: () {
          dialogContext.pop();
          final updatedInvoice = invoice.copyWith(
            status: InvoiceStatus.paid,
            paidAt: DateTime.now(),
          );
          cubit.updateInvoice(updatedInvoice);
        },
      ),
    );
  }

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
    if (invoice.status != InvoiceStatus.draft) {
      AppToast.show(
        context: context,
        title: AppStrings.cannotEditPaidOrCancelled,
        type: ToastificationType.warning,
      );
      return;
    }

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
    final isDraft = invoice.status == InvoiceStatus.draft;
    final isPendingOrOverdue =
        invoice.status == InvoiceStatus.sent ||
        invoice.status == InvoiceStatus.opened ||
        invoice.status == InvoiceStatus.overdue;

    return Column(
      children: [
        if (isDraft) ...[
          CustomMaterialButton(
            onPressed: () => _onSendInvoice(context),
            text: AppStrings.sendInvoice,
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            borderRadius: BorderRadius.circular(12.r),
            maxWidth: true,
          ),
          Gap(12.h),
        ],
        if (isPendingOrOverdue) ...[
          CustomMaterialButton(
            onPressed: () => _onMarkAsPaid(context),
            text: AppStrings.markAsPaid,
            borderRadius: BorderRadius.circular(12.r),
            backgroundColor: const Color(0xFF10B981), // Emerald Green
            maxWidth: true,
          ),
          Gap(12.h),
        ],
        Row(
          children: [
            if (isDraft) ...[
              Expanded(
                child: CustomMaterialButton(
                  onPressed: () => _navigateToEdit(context),
                  text: AppStrings.editInvoice,
                  borderRadius: BorderRadius.circular(12.r),
                  backgroundColor: colors.surface,
                ),
              ),
              Gap(12.w),
            ],
            Expanded(
              child: CustomMaterialButton(
                onPressed: () => _showDeleteConfirmation(context),
                text: AppStrings.deleteInvoice,
                borderRadius: BorderRadius.circular(12.r),
                backgroundColor: colors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
