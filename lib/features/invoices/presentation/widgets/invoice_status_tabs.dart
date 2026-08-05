import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';

class InvoiceStatusTabs extends StatelessWidget {
  const InvoiceStatusTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
    required this.allInvoices,
  });

  final InvoiceStatus? selectedStatus;
  final ValueChanged<InvoiceStatus?> onStatusSelected;
  final List<InvoiceEntity> allInvoices;

  int _getCount(InvoiceStatus? status) => status == null
      ? allInvoices.length
      : allInvoices.where((inv) => inv.status == status).length;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final tabs = [
      (null, AppStrings.all),
      (InvoiceStatus.paid, AppStrings.statusPaid),
      (InvoiceStatus.sent, AppStrings.statusSent),
      (InvoiceStatus.opened, AppStrings.statusOpened),
      (InvoiceStatus.overdue, AppStrings.statusOverdue),
      (InvoiceStatus.draft, AppStrings.statusDraft),
      (InvoiceStatus.cancelled, AppStrings.statusCancelled),
    ];

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => Gap(8.w),
        itemBuilder: (context, index) {
          final (status, label) = tabs[index];
          final isSelected = selectedStatus == status;
          final count = _getCount(status);

          return InkWell(
            onTap: () => onStatusSelected(status),
            borderRadius: BorderRadius.circular(12.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.font13Bold.copyWith(
                      color: isSelected ? Colors.white : colors.mainText,
                    ),
                  ),
                  Gap(6.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.25)
                          : colors.subText.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '$count',
                      style: AppTextStyles.font11SemiBold.copyWith(
                        color: isSelected ? Colors.white : colors.subText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
