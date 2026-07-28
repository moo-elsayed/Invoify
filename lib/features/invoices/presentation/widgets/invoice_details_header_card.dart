import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:invoify/core/widgets/custom_bottom_sheet.dart';
import 'package:invoify/core/widgets/invoice_status_badge.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';

class InvoiceDetailsHeaderCard extends StatefulWidget {
  const InvoiceDetailsHeaderCard({
    super.key,
    required this.invoice,
  });

  final InvoiceEntity invoice;

  @override
  State<InvoiceDetailsHeaderCard> createState() =>
      _InvoiceDetailsHeaderCardState();
}

class _InvoiceDetailsHeaderCardState extends State<InvoiceDetailsHeaderCard> {
  late final ValueNotifier<InvoiceStatus> _statusNotifier;

  @override
  void initState() {
    super.initState();
    _statusNotifier = ValueNotifier<InvoiceStatus>(widget.invoice.status);
  }

  @override
  void didUpdateWidget(covariant InvoiceDetailsHeaderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.invoice.status != widget.invoice.status) {
      _statusNotifier.value = widget.invoice.status;
    }
  }

  @override
  void dispose() {
    _statusNotifier.dispose();
    super.dispose();
  }

  String _getStatusText(InvoiceStatus status) => switch (status) {
        InvoiceStatus.draft => AppStrings.statusDraft,
        InvoiceStatus.sent => AppStrings.statusSent,
        InvoiceStatus.paid => AppStrings.statusPaid,
        InvoiceStatus.overdue => AppStrings.statusOverdue,
        InvoiceStatus.cancelled => AppStrings.statusCancelled,
      };

  void _showStatusBottomSheet(BuildContext context) {
    final cubit = context.read<InvoicesCubit>();
    CustomBottomSheet.show(
      context: context,
      title: AppStrings.updateStatus,
      items: InvoiceStatus.values
          .map(
            (status) => CustomBottomSheetSelectionItem<InvoiceStatus>(
              title: _getStatusText(status),
              value: status,
              isSelected: _statusNotifier.value == status,
              onTap: () {
                _statusNotifier.value = status;
                final updated = widget.invoice.copyWith(status: status);
                cubit.updateInvoice(updated);
              },
            ),
          )
          .toList(),
    );
  }

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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.receipt_rounded,
              color: colors.primary,
              size: 24.sp,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.invoice.invoiceNumber,
                  style: AppTextStyles.font16Bold.copyWith(
                    color: colors.mainText,
                  ),
                ),
                Gap(4.h),
                Text(
                  widget.invoice.client.name,
                  style: AppTextStyles.font13Regular.copyWith(
                    color: colors.subText,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<InvoiceStatus>(
            valueListenable: _statusNotifier,
            builder: (context, status, child) => InkWell(
              onTap: () => _showStatusBottomSheet(context),
              borderRadius: BorderRadius.circular(20.r),
              child: InvoiceStatusBadge(
                status: status,
                showDropdownIcon: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
