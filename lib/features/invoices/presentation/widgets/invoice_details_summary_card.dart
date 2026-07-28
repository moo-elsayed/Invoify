import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_summary_row_tile.dart';

class InvoiceDetailsSummaryCard extends StatelessWidget {
  const InvoiceDetailsSummaryCard({super.key, required this.invoice});

  final InvoiceEntity invoice;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
        ),
      ),
      child: Column(
        children: [
          InvoiceSummaryRowTile(
            label: AppStrings.subtotal,
            value: context.formatCurrency(invoice.subtotal),
          ),
          if (invoice.taxRate > 0) ...[
            Gap(8.h),
            InvoiceSummaryRowTile(
              label: '${AppStrings.taxAmount} (${invoice.taxRate}%)',
              value: '+${context.formatCurrency(invoice.taxAmount)}',
            ),
          ],
          if (invoice.discountAmount > 0) ...[
            Gap(8.h),
            InvoiceSummaryRowTile(
              label: invoice.discountType.isPercentage
                  ? '${AppStrings.discount} (${invoice.discountRate.toStringAsFixed(0)}%)'
                  : AppStrings.discount,
              value: '-${context.formatCurrency(invoice.discountAmount)}',
              valueColor: colors.error,
            ),
          ],
          Gap(12.h),
          Divider(color: colors.border.withValues(alpha: 0.5)),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.grandTotal,
                style: AppTextStyles.font16Bold.copyWith(
                  color: colors.mainText,
                ),
              ),
              Text(
                context.formatCurrency(invoice.totalAmount),
                style: AppTextStyles.font18Bold.copyWith(
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
