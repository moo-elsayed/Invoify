import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invoify/core/helpers/app_strings.dart';
import 'package:invoify/core/helpers/extensions.dart';
import 'package:invoify/features/dashboard/presentation/widgets/dashboard_metric_item_card.dart';

class DashboardMetricsCards extends StatelessWidget {
  const DashboardMetricsCards({
    super.key,
    required this.monthlyEarnings,
    required this.totalOverdue,
    required this.pendingAmount,
    required this.activeClientsCount,
  });

  final double monthlyEarnings;
  final double totalOverdue;
  final double pendingAmount;
  final int activeClientsCount;

  @override
  Widget build(BuildContext context) {
    final double cardWidth =
        (MediaQuery.sizeOf(context).width - 32.w - 12.w) / 2;

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: [
        SizedBox(
          width: cardWidth,
          child: DashboardMetricItemCard(
            title: AppStrings.monthlyEarnings,
            value: context.formatCurrency(monthlyEarnings),
            icon: Icons.account_balance_wallet_rounded,
            accentColor: const Color(0xFF10B981),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: DashboardMetricItemCard(
            title: AppStrings.totalOverdue,
            value: context.formatCurrency(totalOverdue),
            icon: Icons.warning_amber_rounded,
            accentColor: const Color(0xFFEF4444),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: DashboardMetricItemCard(
            title: AppStrings.pendingAmount,
            value: context.formatCurrency(pendingAmount),
            icon: Icons.hourglass_empty_rounded,
            accentColor: const Color(0xFFF59E0B),
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: DashboardMetricItemCard(
            title: AppStrings.activeClients,
            value: activeClientsCount.toString(),
            icon: Icons.people_alt_rounded,
            accentColor: const Color(0xFF3B82F6),
          ),
        ),
      ],
    );
  }
}
