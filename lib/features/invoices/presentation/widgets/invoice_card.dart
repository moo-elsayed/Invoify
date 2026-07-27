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
import 'package:invoify/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:invoify/core/widgets/custom_bottom_sheet.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/custom_icon_action_button.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/args/invoice_details_args.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_status_badge.dart';

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
        title: AppStrings.deleteClient,
        subtitle: AppStrings.deleteInvoiceConfirmation,
        textConfirmButton: AppStrings.deleteClient,
        onConfirm: () {
          dialogContext.pop();
          onDelete();
        },
      ),
    );
  }

  String _getStatusText(InvoiceStatus status) => switch (status) {
        InvoiceStatus.draft => AppStrings.statusDraft,
        InvoiceStatus.sent => AppStrings.statusSent,
        InvoiceStatus.paid => AppStrings.statusPaid,
        InvoiceStatus.overdue => AppStrings.statusOverdue,
        InvoiceStatus.cancelled => AppStrings.statusCancelled,
      };

  void _showStatusBottomSheet(BuildContext context) {
    CustomBottomSheet.show(
      context: context,
      title: AppStrings.updateStatus,
      items: InvoiceStatus.values
          .map(
            (status) => CustomBottomSheetSelectionItem<InvoiceStatus>(
              title: _getStatusText(status),
              value: status,
              isSelected: invoice.status == status,
              onTap: () => onStatusChanged(status),
            ),
          )
          .toList(),
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
                InkWell(
                  onTap: () => _showStatusBottomSheet(context),
                  borderRadius: BorderRadius.circular(20.r),
                  child: InvoiceStatusBadge(
                    status: invoice.status,
                    showDropdownIcon: true,
                  ),
                ),
              ],
            ),
            Gap(12.h),
            Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
            Gap(12.h),

            // Date & Total Amount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (issueDateStr.isNotEmpty)
                      Text(
                        '${AppStrings.issueDate}: $issueDateStr',
                        style: AppTextStyles.font11Regular.copyWith(
                          color: colors.subText,
                        ),
                      ),
                    if (dueDateStr.isNotEmpty) ...[
                      Gap(2.h),
                      Text(
                        '${AppStrings.dueDate}: $dueDateStr',
                        style: AppTextStyles.font11Regular.copyWith(
                          color: colors.subText,
                        ),
                      ),
                    ],
                  ],
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
                          invoice.totalAmount.toStringAsFixed(2),
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
