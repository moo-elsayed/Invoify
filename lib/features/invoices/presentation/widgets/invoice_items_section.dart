import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';
import 'package:invoify/features/invoices/presentation/widgets/invoice_item_row.dart';

class InvoiceItemsSection extends StatelessWidget {
  const InvoiceItemsSection({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onUpdateItem,
  });

  final List<InvoiceItemEntity> items;
  final VoidCallback onAddItem;
  final ValueChanged<int> onRemoveItem;
  final Function(int index, InvoiceItemEntity updatedItem) onUpdateItem;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.invoiceItems,
              style: AppTextStyles.font16Bold.copyWith(color: colors.mainText),
            ),
            InkWell(
              onTap: onAddItem,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 18.sp,
                      color: colors.primary,
                    ),
                    Gap(6.w),
                    Text(
                      AppStrings.addItem,
                      style: AppTextStyles.font13Bold.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Gap(12.h),
        if (items.isEmpty)
          Container(
            padding: EdgeInsets.all(16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              AppStrings.pleaseAddAtLeastOneItem,
              style: AppTextStyles.font13Regular.copyWith(
                color: colors.subText,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Gap(12.h),
            itemBuilder: (context, index) {
              final item = items[index];
              return InvoiceItemRow(
                key: ValueKey(item.itemId.isNotEmpty ? item.itemId : index),
                item: item,
                index: index,
                onRemove: () => onRemoveItem(index),
                onChanged: (updatedItem) => onUpdateItem(index, updatedItem),
              );
            },
          ),
      ],
    );
  }
}
