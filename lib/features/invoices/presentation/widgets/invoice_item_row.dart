import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/widgets/custom_icon_action_button.dart';
import 'package:invoify/core/widgets/text_form_field_helper.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_item_entity.dart';

class InvoiceItemRow extends StatefulWidget {
  const InvoiceItemRow({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onChanged,
  });

  final InvoiceItemEntity item;
  final int index;
  final VoidCallback onRemove;
  final ValueChanged<InvoiceItemEntity> onChanged;

  @override
  State<InvoiceItemRow> createState() => _InvoiceItemRowState();
}

class _InvoiceItemRowState extends State<InvoiceItemRow> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(
      text: widget.item.quantity == 0
          ? ''
          : widget.item.quantity.toStringAsFixed(0),
    );
    _priceController = TextEditingController(
      text: widget.item.unitPrice == 0
          ? ''
          : widget.item.unitPrice.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _notifyChanges() {
    final qty = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final updated = widget.item.copyWith(
      name: _nameController.text.trim(),
      quantity: qty,
      unitPrice: price,
    );
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final qty = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final totalPrice = qty * price;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.isDarkMode
              ? colors.border.withValues(alpha: 0.5)
              : colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isDarkMode
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Item Number badge + Delete button
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${AppStrings.addItem} #${widget.index + 1}',
                  style: AppTextStyles.font12Bold.copyWith(
                    color: colors.primary,
                  ),
                ),
              ),
              const Spacer(),
              CustomIconActionButton(
                icon: Icons.delete_outline_rounded,
                onTap: widget.onRemove,
                color: colors.error,
              ),
            ],
          ),
          Gap(12.h),

          // Item Name Input Field
          TextFormFieldHelper(
            controller: _nameController,
            hint: AppStrings.itemName,
            onChanged: (val) => _notifyChanges(),
          ),
          Gap(10.h),

          // Quantity, Unit Price, and Subtotal Pill
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormFieldHelper(
                  controller: _quantityController,
                  hint: AppStrings.quantity,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _notifyChanges(),
                ),
              ),
              Gap(8.w),
              Expanded(
                flex: 4,
                child: TextFormFieldHelper(
                  controller: _priceController,
                  hint: AppStrings.unitPrice,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) => _notifyChanges(),
                ),
              ),
              Gap(8.w),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    context.formatCurrency(totalPrice),
                    style: AppTextStyles.font14Bold.copyWith(
                      color: colors.primary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
