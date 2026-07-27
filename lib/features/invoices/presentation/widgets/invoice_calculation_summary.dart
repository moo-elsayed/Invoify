import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/invoices/domain/enums/discount_type.dart';

class InvoiceCalculationSummary extends StatelessWidget {
  const InvoiceCalculationSummary({
    super.key,
    required this.subtotal,
    required this.taxRateController,
    required this.discountController,
    required this.discountTypeNotifier,
    this.onCalculationsChanged,
  });

  final double subtotal;
  final TextEditingController taxRateController;
  final TextEditingController discountController;
  final ValueNotifier<DiscountType> discountTypeNotifier;
  final VoidCallback? onCalculationsChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListenableBuilder(
      listenable: Listenable.merge([
        taxRateController,
        discountController,
        discountTypeNotifier,
      ]),
      builder: (context, child) {
        final taxRate = double.tryParse(taxRateController.text.trim()) ?? 0.0;
        final discountInput =
            double.tryParse(discountController.text.trim()) ?? 0.0;
        final discountType = discountTypeNotifier.value;

        final taxAmount = subtotal * (taxRate / 100);
        final double discountAmount = discountType.isPercentage
            ? subtotal * (discountInput / 100)
            : discountInput;

        final grandTotal = (subtotal + taxAmount - discountAmount).clamp(
          0.0,
          double.infinity,
        );

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              // Subtotal Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.subtotal,
                    style: AppTextStyles.font14Medium.copyWith(
                      color: colors.subText,
                    ),
                  ),
                  Text(
                    subtotal.toStringAsFixed(2),
                    style: AppTextStyles.font14Bold.copyWith(
                      color: colors.mainText,
                    ),
                  ),
                ],
              ),
              Gap(12.h),

              // Tax & Discount Input Row
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: taxRateController,
                      hint: AppStrings.taxRate,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) => onCalculationsChanged?.call(),
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: discountController,
                      hint: discountType.isPercentage
                          ? '${AppStrings.discount} (%)'
                          : '${AppStrings.discount} (\$)',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) => onCalculationsChanged?.call(),
                      suffixWidget: GestureDetector(
                        onTap: () {
                          discountTypeNotifier.value = discountType.isPercentage
                              ? DiscountType.fixed
                              : DiscountType.percentage;
                          onCalculationsChanged?.call();
                        },
                        child: Container(
                          margin: EdgeInsets.all(6.r),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            discountType.isPercentage ? '%' : '\$',
                            style: AppTextStyles.font14Bold.copyWith(
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(12.h),

              // Tax Amount Display Row
              if (taxAmount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.taxAmount,
                      style: AppTextStyles.font13Regular.copyWith(
                        color: colors.subText,
                      ),
                    ),
                    Text(
                      '+${taxAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.font13Regular.copyWith(
                        color: colors.subText,
                      ),
                    ),
                  ],
                ),
                Gap(6.h),
              ],

              // Discount Amount Display Row
              if (discountAmount > 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      discountType.isPercentage
                          ? '${AppStrings.discount} (${discountInput.toStringAsFixed(0)}%)'
                          : AppStrings.discount,
                      style: AppTextStyles.font13Regular.copyWith(
                        color: colors.error,
                      ),
                    ),
                    Text(
                      '-${discountAmount.toStringAsFixed(2)}',
                      style: AppTextStyles.font13Regular.copyWith(
                        color: colors.error,
                      ),
                    ),
                  ],
                ),
                Gap(6.h),
              ],

              Divider(color: colors.border),
              Gap(6.h),

              // Grand Total Highlight Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.grandTotal,
                      style: AppTextStyles.font16Bold.copyWith(
                        color: colors.primary,
                      ),
                    ),
                    Text(
                      grandTotal.toStringAsFixed(2),
                      style: AppTextStyles.font18Bold.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
