import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_icon_action_button.dart';
import 'package:invoify/core/widgets/invoice_status_badge.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/args/invoice_details_args.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.onDelete,
    required this.onStatusChanged,
  });

  final InvoiceEntity invoice;
  final VoidCallback onDelete;
  final ValueChanged<InvoiceStatus> onStatusChanged;

  void _showDeleteConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        title: AppStrings.deleteInvoice,
        subtitle: AppStrings.deleteInvoiceConfirmation,
        textConfirmButton: AppStrings.deleteInvoice,
        onConfirm: () {
          dialogContext.pop();
          onDelete();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final issueDateStr = invoice.issueDate != null
        ? DateFormat('yyyy-MM-dd').format(invoice.issueDate!)
        : '';
    final dueDateStr = invoice.dueDate != null
        ? DateFormat('yyyy-MM-dd').format(invoice.dueDate!)
        : '';

    return InkWell(
      onTap: () => context.pushNamed(
        Routes.invoiceDetailsView,
        arguments: InvoiceDetailsArgs(
          invoice: invoice,
          cubit: context.read<InvoicesCubit>(),
        ),
      ),
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: context.isDarkMode
                ? colors.border.withValues(alpha: 0.5)
                : colors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Invoice Number, Status Badge & Action Buttons
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.receipt_rounded,
                    color: colors.primary,
                    size: 20.sp,
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.invoiceNumber,
                        style: AppTextStyles.font14Bold.copyWith(
                          color: colors.mainText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (invoice.client.name.isNotEmpty) ...[
                        Gap(2.h),
                        Text(
                          invoice.client.name,
                          style: AppTextStyles.font12Medium.copyWith(
                            color: colors.subText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                InvoiceStatusBadge(status: invoice.status),
              ],
            ),
            Gap(12.h),
            Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
            Gap(12.h),

            // Date & Total Amount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (issueDateStr.isNotEmpty)
                        Text(
                          '${AppStrings.issueDate}: $issueDateStr',
                          style: AppTextStyles.font11Regular.copyWith(
                            color: colors.subText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (dueDateStr.isNotEmpty) ...[
                        Gap(2.h),
                        Text(
                          '${AppStrings.dueDate}: $dueDateStr',
                          style: AppTextStyles.font11Regular.copyWith(
                            color: colors.subText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppStrings.grandTotal,
                          style: AppTextStyles.font11Medium.copyWith(
                            color: colors.subText,
                          ),
                        ),
                        Text(
                          context.formatCurrency(invoice.totalAmount),
                          style: AppTextStyles.font16Bold.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    Gap(12.w),
                    CustomIconActionButton(
                      icon: Icons.delete_outline_rounded,
                      onTap: () => _showDeleteConfirmation(context),
                      color: colors.error,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
