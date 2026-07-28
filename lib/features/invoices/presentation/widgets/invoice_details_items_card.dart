import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';

class InvoiceDetailsItemsCard extends StatelessWidget {
  const InvoiceDetailsItemsCard({super.key, required this.items});

  final List<InvoiceItemEntity> items;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.invoiceItems,
            style: AppTextStyles.font14Bold.copyWith(color: colors.mainText),
          ),
          Gap(12.h),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: AppTextStyles.font14Medium.copyWith(
                                color: colors.mainText,
                              ),
                            ),
                            Gap(4.h),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                '${item.quantity} × ${context.formatCurrency(item.unitPrice)}',
                                style: AppTextStyles.font12Regular.copyWith(
                                  color: colors.subText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        context.formatCurrency(item.totalPrice),
                        style: AppTextStyles.font14Bold.copyWith(
                          color: colors.mainText,
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    Gap(8.h),
                    Divider(color: colors.border.withValues(alpha: 0.5)),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
