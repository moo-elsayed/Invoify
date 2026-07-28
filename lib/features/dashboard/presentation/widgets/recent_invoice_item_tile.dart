import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/di.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/routing/routes.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/invoice_status_badge.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/presentation/args/invoice_details_args.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';

class RecentInvoiceItemTile extends StatelessWidget {
  const RecentInvoiceItemTile({super.key, required this.invoice});

  final InvoiceEntity invoice;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () => context.pushNamed(
        Routes.invoiceDetailsView,
        arguments: InvoiceDetailsArgs(
          invoice: invoice,
          cubit: getIt<InvoicesCubit>(),
        ),
      ),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: context.isDarkMode
                ? colors.border.withValues(alpha: 0.5)
                : colors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 20.sp,
                color: colors.primary,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.client.name.isEmpty
                        ? AppStrings.selectClient
                        : invoice.client.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14Bold.copyWith(
                      color: colors.mainText,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    invoice.invoiceNumber,
                    style: AppTextStyles.font12Regular.copyWith(
                      color: colors.subText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.formatCurrency(invoice.totalAmount),
                  style: AppTextStyles.font14Bold.copyWith(
                    color: colors.mainText,
                  ),
                ),
                Gap(4.h),
                InvoiceStatusBadge(status: invoice.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
