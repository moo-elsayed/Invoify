import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/widgets/app_toasts.dart';
import 'package:invoify/core/widgets/custom_app_bar.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_state.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_dates_section_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_actions_row.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_client_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_header_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_items_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_notes_card.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_details_summary_card.dart';
import 'package:toastification/toastification.dart';

class InvoiceDetailsView extends StatelessWidget {
  const InvoiceDetailsView({super.key, required this.invoice});

  final InvoiceEntity invoice;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(title: AppStrings.invoiceDetails, showArrowBack: true),
    body: SafeArea(
      child: BlocConsumer<InvoicesCubit, InvoicesState>(
        listener: (context, state) {
          if (ModalRoute.of(context)?.isCurrent != true) return;
          if (state is InvoiceActionSuccess) {
            AppToast.show(
              context: context,
              title: state.message,
              type: ToastificationType.success,
            );
          } else if (state is InvoicesFailure) {
            AppToast.show(
              context: context,
              title: state.error,
              type: ToastificationType.error,
            );
          } else if (state is InvoicesSuccess) {
            final isDeleted = !state.invoices.any(
              (item) => item.invoiceId == invoice.invoiceId,
            );
            if (isDeleted) {
              AppToast.show(
                context: context,
                title: AppStrings.invoiceDeletedSuccessfully,
                type: ToastificationType.success,
              );
              context.pop();
            }
          }
        },
        builder: (context, state) {
          final cubit = context.read<InvoicesCubit>();
          final currentInvoice = cubit.allInvoices.firstWhere(
            (item) => item.invoiceId == invoice.invoiceId,
            orElse: () => (state is InvoicesSuccess)
                ? state.invoices.firstWhere(
                    (item) => item.invoiceId == invoice.invoiceId,
                    orElse: () => invoice,
                  )
                : invoice,
          );

          final issueDateStr = currentInvoice.issueDate != null
              ? DateFormat('yyyy-MM-dd').format(currentInvoice.issueDate!)
              : '';
          final dueDateStr = currentInvoice.dueDate != null
              ? DateFormat('yyyy-MM-dd').format(currentInvoice.dueDate!)
              : '';
          final paidDateStr = currentInvoice.paidAt != null
              ? DateFormat('yyyy-MM-dd HH:mm').format(currentInvoice.paidAt!)
              : null;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card: Invoice Number & Reactive Status Badge
                InvoiceDetailsHeaderCard(invoice: currentInvoice),
                Gap(16.h),

                // Client Information Card
                InvoiceDetailsClientCard(client: currentInvoice.client),
                Gap(16.h),

                // Dates Section Card
                InvoiceDatesSectionCard(
                  issueDateStr: issueDateStr,
                  dueDateStr: dueDateStr,
                  paidDateStr: paidDateStr,
                ),
                Gap(16.h),

                // Invoice Items Card
                InvoiceDetailsItemsCard(items: currentInvoice.items),
                Gap(16.h),

                // Financial Breakdown Card
                InvoiceDetailsSummaryCard(invoice: currentInvoice),

                // Notes Card
                if (currentInvoice.notes.isNotEmpty) ...[
                  Gap(16.h),
                  InvoiceDetailsNotesCard(notes: currentInvoice.notes),
                ],
                Gap(24.h),

                // Actions Row: Edit & Delete Buttons
                InvoiceDetailsActionsRow(invoice: currentInvoice),
              ],
            ),
          );
        },
      ),
    ),
  );
}
