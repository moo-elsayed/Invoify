import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:invoify/core/widgets/custom_bottom_sheet.dart';
import 'package:invoify/core/widgets/custom_confirmation_dialog.dart';
import 'package:invoify/core/widgets/invoice_status_badge.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';
import 'package:invoify/features/invoices/presentation/view_models/invoices_cubit/invoices_cubit.dart';

class InvoiceDetailsHeaderCard extends StatefulWidget {
  const InvoiceDetailsHeaderCard({super.key, required this.invoice});

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
    InvoiceStatus.opened => AppStrings.statusOpened,
    InvoiceStatus.paid => AppStrings.statusPaid,
    InvoiceStatus.overdue => AppStrings.statusOverdue,
    InvoiceStatus.cancelled => AppStrings.statusCancelled,
  };

  List<InvoiceStatus> _getAllowedNextStatuses(InvoiceStatus current) =>
      switch (current) {
        InvoiceStatus.draft => [InvoiceStatus.sent, InvoiceStatus.cancelled],
        InvoiceStatus.sent ||
        InvoiceStatus.opened ||
        InvoiceStatus.overdue => [InvoiceStatus.paid, InvoiceStatus.cancelled],
        InvoiceStatus.paid || InvoiceStatus.cancelled => [],
      };

  void _confirmAndApplyStatus(
    BuildContext context,
    InvoicesCubit cubit,
    InvoiceStatus newStatus,
  ) {
    if (newStatus == InvoiceStatus.sent) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CustomConfirmationDialog(
          title: AppStrings.sendInvoice,
          subtitle: AppStrings.confirmSendInvoiceSubtitle,
          textConfirmButton: AppStrings.sendInvoice,
          onConfirm: () {
            dialogContext.pop();
            _statusNotifier.value = newStatus;
            final updated = widget.invoice.copyWith(status: newStatus);
            cubit.updateInvoice(updated);
          },
        ),
      );
    } else if (newStatus == InvoiceStatus.paid) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CustomConfirmationDialog(
          title: AppStrings.confirmPaymentTitle,
          subtitle: AppStrings.confirmPaymentSubtitle,
          textConfirmButton: AppStrings.confirmPaymentButton,
          onConfirm: () {
            dialogContext.pop();
            _statusNotifier.value = newStatus;
            final updated = widget.invoice.copyWith(
              status: newStatus,
              paidAt: DateTime.now(),
            );
            cubit.updateInvoice(updated);
          },
        ),
      );
    } else if (newStatus == InvoiceStatus.cancelled) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CustomConfirmationDialog(
          title: AppStrings.cancelInvoice,
          subtitle: AppStrings.confirmCancelInvoiceSubtitle,
          textConfirmButton: AppStrings.cancelInvoice,
          onConfirm: () {
            dialogContext.pop();
            _statusNotifier.value = newStatus;
            final updated = widget.invoice.copyWith(status: newStatus);
            cubit.updateInvoice(updated);
          },
        ),
      );
    } else {
      _statusNotifier.value = newStatus;
      final updated = widget.invoice.copyWith(status: newStatus);
      cubit.updateInvoice(updated);
    }
  }

  void _showStatusBottomSheet(BuildContext context) {
    final allowedStatuses = _getAllowedNextStatuses(_statusNotifier.value);
    if (allowedStatuses.isEmpty) return;

    final cubit = context.read<InvoicesCubit>();
    CustomBottomSheet.show(
      context: context,
      title: AppStrings.updateStatus,
      items: allowedStatuses
          .map(
            (status) => CustomBottomSheetSelectionItem<InvoiceStatus>(
              title: _getStatusText(status),
              value: status,
              isSelected: _statusNotifier.value == status,
              onTap: () {
                _confirmAndApplyStatus(context, cubit, status);
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
            builder: (context, status, child) {
              final isTerminal =
                  status == InvoiceStatus.paid ||
                  status == InvoiceStatus.cancelled;
              if (isTerminal) {
                return InvoiceStatusBadge(
                  status: status,
                  showDropdownIcon: false,
                );
              }
              return InkWell(
                onTap: () => _showStatusBottomSheet(context),
                borderRadius: BorderRadius.circular(20.r),
                child: InvoiceStatusBadge(
                  status: status,
                  showDropdownIcon: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
