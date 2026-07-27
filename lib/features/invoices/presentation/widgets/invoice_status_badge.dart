import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/invoices/domain/enums/invoice_status.dart';

class InvoiceStatusBadge extends StatelessWidget {
  const InvoiceStatusBadge({
    super.key,
    required this.status,
    this.showDropdownIcon = false,
  });

  final InvoiceStatus status;
  final bool showDropdownIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (bgColor, fgColor, text) = switch (status) {
      InvoiceStatus.draft => (
        colors.subText.withValues(alpha: 0.12),
        colors.subText,
        AppStrings.statusDraft,
      ),
      InvoiceStatus.sent => (
        colors.primary.withValues(alpha: 0.12),
        colors.primary,
        AppStrings.statusSent,
      ),
      InvoiceStatus.paid => (
        const Color(0xFF10B981).withValues(alpha: 0.12),
        const Color(0xFF10B981),
        AppStrings.statusPaid,
      ),
      InvoiceStatus.overdue => (
        colors.error.withValues(alpha: 0.12),
        colors.error,
        AppStrings.statusOverdue,
      ),
      InvoiceStatus.cancelled => (
        Colors.orange.withValues(alpha: 0.12),
        Colors.orange,
        AppStrings.statusCancelled,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: fgColor, shape: BoxShape.circle),
          ),
          Gap(6.w),
          Text(text, style: AppTextStyles.font12Bold.copyWith(color: fgColor)),
          if (showDropdownIcon) ...[
            Gap(3.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.sp,
              color: fgColor,
            ),
          ],
        ],
      ),
    );
  }
}
