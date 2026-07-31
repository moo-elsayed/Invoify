import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/core/theming/app_text_styles.dart';
import 'package:invoify/features/dashboard/presentation/widgets/recent_invoice_item_tile.dart';
import 'package:invoify/features/invoices/domain/entities/invoice_entity.dart';

class DashboardRecentInvoices extends StatelessWidget {
  const DashboardRecentInvoices({super.key, required this.recentInvoices});

  final List<InvoiceEntity> recentInvoices;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.recentInvoices,
          style: AppTextStyles.font16Bold.copyWith(color: colors.mainText),
        ),
        Gap(12.h),
        if (recentInvoices.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            margin: EdgeInsets.only(bottom: 75.h),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: context.isDarkMode
                    ? colors.border.withValues(alpha: 0.5)
                    : colors.border,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                AppStrings.noInvoicesYet,
                style: AppTextStyles.font13Regular.copyWith(
                  color: colors.subText,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentInvoices.length,
            separatorBuilder: (context, index) => Gap(10.h),
            itemBuilder: (context, index) {
              final invoice = recentInvoices[index];
              return RecentInvoiceItemTile(invoice: invoice);
            },
          ),
      ],
    );
  }
}
